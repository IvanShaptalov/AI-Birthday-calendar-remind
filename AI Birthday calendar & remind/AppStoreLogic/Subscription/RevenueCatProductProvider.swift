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
    
    static func restorePurchase(callback: @escaping (Bool) -> ()){
    
        Purchases.shared.restorePurchases { customerInfo, error in
            // ... check customerInfo to see if entitlement is now active

            let isPremium = self.updatePremiumStatus(customerInfo: customerInfo)
            
            callback(isPremium)
        }
    }
    
    // MARK: - Update premium status
    /// returns true if customer had active subscription
    static private func updatePremiumStatus(customerInfo: CustomerInfo?) -> Bool{
        guard customerInfo != nil else {
            self.hasPremium = false
            MonetizationConfiguration.isPremiumAccount = false
            return false
        }
        let hasPremium = !customerInfo!.entitlements.active.isEmpty
        self.hasPremium = hasPremium
        MonetizationConfiguration.isPremiumAccount = hasPremium
        NSLog("👑 premium: \(MonetizationConfiguration.isPremiumAccount)")
        return hasPremium
    }
    
    // MARK: - Check premium account
    static func getCustomerInfo(){
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            _ = updatePremiumStatus(customerInfo: customerInfo)
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
            _ = updatePremiumStatus(customerInfo: customerInfo)
            errorCatcher(.Success)
        }
        errorCatcher(.Processing)
    }
    
    // MARK: - get offerings 🕊️
    static func getOffering(subCallback: @escaping([SubscriptionObj]) -> (),
                            catchError: @escaping (RevenueCatError) -> Void){
        NSLog("subs fetch received")
        // Using Completion Blocks
        Purchases.shared.getOfferings { (offerings, error) in
            
            do {
                if let rawPackages = offerings?.offering(identifier: AppConfiguration.revenueCatOfferingId)?.availablePackages {
                    NSLog("✅📦 fetch packages from identifier: \(AppConfiguration.revenueCatOfferingId) ")
                    let packages = convertPackages(rawPackages)
                    subCallback(packages)
                    return
                } else {
                    NSLog("error ❌📦 while fetching packages from identifier: \(AppConfiguration.revenueCatOfferingId) ")
                    
                    NSLog("🎰 try get current package")
                    if let rawPackages = offerings?.current?.availablePackages {
                        NSLog("✅📦 fetch packages from current ")
                        let packages = convertPackages(rawPackages)
                        subCallback(packages)
                        return
                    } else {
                        NSLog("error ❌📦 while fetching packages from current package")
                        throw RevenueCatError.OffersNotFound
                        
                    }

                }
                
                
            } catch {
                catchError(RevenueCatError.OffersNotFound)
            }
            
        }
    }
    // MARK: - Convert packages 📦
    static private func convertPackages(_ packages: [RevenueCat.Package]) -> [SubscriptionObj] {
        var subs: [SubscriptionObj] = []
        for pack in packages {
            
            let storeProduct = pack.storeProduct
            let offering = storeProduct.introductoryDiscount?.subscriptionPeriod.value
            let isFreeTrial = offering != nil
            subs.append(SubscriptionObj(title: storeProduct.localizedTitle, discount: 0,  priceDuration: "\(storeProduct.pricePerMonth ?? 1)$ per month", package: pack, totalPrice: storeProduct.price.formatted(), isFamilyShareable: storeProduct.isFamilyShareable, isFreeTrial: isFreeTrial))
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
    var priceDuration: String
    var package: RevenueCat.Package
    var totalPrice: String
    var isFamilyShareable: Bool
    var isFreeTrial: Bool
    
    init(title: String, discount: Int, priceDuration: String, package: RevenueCat.Package, totalPrice: String, isFamilyShareable: Bool, isFreeTrial: Bool) {
        self.title = title
        self.discount = discount
        self.priceDuration = priceDuration
        self.package = package
        self.totalPrice = totalPrice
        self.isFamilyShareable = isFamilyShareable
        self.isFreeTrial = isFreeTrial
    }
}
