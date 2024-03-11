//
//  RevenueCatProductsProvider.swift
//  Learn Up
//
//  Created by PowerMac on 05.02.2024.
//

import Foundation
import RevenueCat
import UIKit

enum SubStatus: String{
    case
    AlreadySubscribed,
    Processing,
    PurchaseNotAllowedError,
    PurchaseInvalidError,
    UnknownError,
    PurchaseCancelled,
    Success
    
}


class RevenueCatProductsProvider {
    static var subscriptionList: [SubscriptionObj] = []
    
    static var hasPremium = false
        
    static func setUp() {
        getCustomerInfo()
        NSLog("Start fetch subs")
        getOffering(subCallback: {subs in
            self.subscriptionList = subs
        }, catchError: {error in
            self.subscriptionList = []
        })
    }
    
    // MARK: - Update premium status
    static private func updatePremiumStatus(customerInfo: CustomerInfo?){
        guard customerInfo != nil else {
            self.hasPremium = false
            MonetizationConfiguration.isPremiumAccount = false
            return
        }
        let hasPremium = !customerInfo!.entitlements.active.isEmpty
        self.hasPremium = hasPremium
        MonetizationConfiguration.isPremiumAccount = hasPremium
        NSLog("premium: \(MonetizationConfiguration.isPremiumAccount)")
    }
    
    // MARK: - Check premium account
    static func getCustomerInfo(){
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            updatePremiumStatus(customerInfo: customerInfo)
        }
    }
    
    // MARK: - purchase
    static func makePurchase(package: Package, errorCatcher: @escaping (SubStatus) -> Void ){
        if hasPremium {
            errorCatcher(.AlreadySubscribed)
        }
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, rawError, userCancelled) in
            // MARK: Unlock "pro" content
            if userCancelled {
                errorCatcher(.PurchaseCancelled)
                return
            }
            if let error = rawError as? RevenueCat.ErrorCode {
              print(error.errorCode)
              print(error.errorUserInfo)

              switch error {
              case .purchaseNotAllowedError:
                  errorCatcher(.PurchaseNotAllowedError)
              case .purchaseInvalidError:
                  errorCatcher(.PurchaseInvalidError)
              default:
                  errorCatcher(.UnknownError)
              }
            
            }
            updatePremiumStatus(customerInfo: customerInfo)
            errorCatcher(.Success)
        }
        errorCatcher(.Processing)
    }
    
    static func getOffering(subCallback: @escaping([SubscriptionObj]) -> (),
                            catchError: @escaping (RevenueCatError) -> Void){
        NSLog("subs fetch received")
        // Using Completion Blocks
        Purchases.shared.getOfferings { (offerings, error) in
            
            do {
                if let rawPackages = offerings?.current?.availablePackages {
                    let packages = convertPackages(rawPackages)
                    subCallback(packages)
                    return
                } else {
                    throw RevenueCatError.OffersNotFound
                    
                }
            } catch {
                catchError(RevenueCatError.OffersNotFound)
            }
            
        }
    }
    static private func convertPackages(_ packages: [RevenueCat.Package]) -> [SubscriptionObj] {
        var subs: [SubscriptionObj] = []
        for pack in packages {
            
            let storeProduct = pack.storeProduct
            
            var subOffer: String? = nil
            
            if storeProduct.introductoryDiscount?.subscriptionPeriod.value != nil {
                subOffer = "\(storeProduct.introductoryDiscount!.subscriptionPeriod.value) week free"
            }
            
            subs.append(SubscriptionObj(title: storeProduct.localizedTitle, discount: 0, subOffer: subOffer, priceDuration: "\(storeProduct.pricePerMonth ?? 1)$ per month", package: pack))
        }
        return subs
    }
}


enum RevenueCatError: Error {
    case
    OffersNotFound
}



class SubscriptionObj {
    var title: String
    var discount: Int
    var subOffer : String?
    var priceDuration: String
    var package: RevenueCat.Package
    
    init(title: String, discount: Int, subOffer: String?, priceDuration: String, package: RevenueCat.Package) {
        self.title = title
        self.discount = discount
        self.subOffer = subOffer
        self.priceDuration = priceDuration
        self.package = package
    }
}
