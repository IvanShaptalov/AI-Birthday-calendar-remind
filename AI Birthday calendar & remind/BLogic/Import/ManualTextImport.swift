//
//  ManualImport.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 29.03.2024.
//

import Foundation

enum Status: String {
    case 
    eventConverted = "converted",
    eventUnknownError = "unknown",
    dateNotConverted = "date not converted",
    nameNotConverted = "name not converted",
    hasNoName = "has no name",
    hasNoDate = "has no date",
    missedElement = "missed element"
}

class ManualTextImport {
    
}


class BaseRuleConverter{
    var event: MainEvent
    var raw: String
    
    init(event: MainEvent, raw: String) {
        self.event = event
        self.raw = raw
    }
    
    func convert(statusCallback: @escaping(Status) -> Void, separator: String){
        
    }
}

class DashRuleConverter: BaseRuleConverter{
    override func convert(statusCallback: @escaping(Status) -> Void, separator: String) {
        let components = self.raw.components(separatedBy: separator)
        
        if components.count != 2 {
            statusCallback(.missedElement)
        }
    }
}
