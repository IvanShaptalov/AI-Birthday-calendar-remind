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
    missedElement = "missed element"
}

// MARK: - Converters
class BaseRuleConverter{
    var event: MainEvent
    var raw: String
    
    init(raw: String) {
        self.event = .init(eventDate: .now, eventType: .birthday, title: "-", id: UUID().uuidString)
        self.raw = raw
    }
    
    func convert(statusCallback: @escaping(Status) -> Void){
        
    }
    
    static func removePunctuationAndSpaces(from input: String) -> String {
        let cleanedString = input.trimmingCharacters(in: CharacterSet.punctuationCharacters.union(CharacterSet.whitespaces))
        
        return cleanedString
    }
    
    static func removeSubstring(originalString: String, substringToRemove: String) -> String{

        if let range = originalString.range(of: substringToRemove) {
            let result = originalString.replacingOccurrences(of: substringToRemove, with: "")
            return result
        } else {
            return originalString
        }

    }
}

enum SeparatorList: String {
    case
    dot = ".",
    comma = ",",
    exclamation = "!",
    questionMark = "?",
    semicolon = ";",
    colon = ":",
    hyphen = "-",
    underscore = "_",
    space = " "
    
    static func allValues() -> [SeparatorList]{
        return [dot, comma, exclamation, questionMark, semicolon, colon, hyphen, underscore, space]
    }
}

class EnglishRuleConverter: BaseRuleConverter{
    
    override func convert(statusCallback: @escaping(Status) -> Void) {
        var components: [String] = []
        
        // split using all separator list
        for separator in SeparatorList.allValues() {
            var newComponents = self.raw.components(separatedBy: separator.rawValue)
            if newComponents.count == 2 {
                components += newComponents
            }
        }
        
        // split not give any results
        if components.count < 2 {
            statusCallback(.missedElement)
            return
        }
        
        // try to retrieve date
        var date: Date?
        var rawForName: String?
        
        for component in components {
            date = retrieveDate(rawPart: component)
            if date != nil {
                self.event.eventDate = date!
                // remove date component to get name
                rawForName = EnglishRuleConverter.removeSubstring(originalString: self.raw, substringToRemove: component)
                
                
                
                break
            }
        }
        // date not found
        if date == nil {
            statusCallback(.dateNotConverted)
            return
        }
        
        // name not found
        if rawForName == nil {
            statusCallback(.nameNotConverted)
            return
        }
        
        // add name
        rawForName = EnglishRuleConverter.removePunctuationAndSpaces(from: rawForName!)
        self.event.title = rawForName!
        statusCallback(.eventConverted)
        
    }
    
    func retrieveDate(rawPart: String) -> Date? {
        let cleanedString = EnglishRuleConverter.removePunctuationAndSpaces(from: rawPart)
        return BaseDateRetriever().retrieveDate(from: rawPart)
    }
    
    func retrieveName(rawPart: String) -> String {
        return EnglishRuleConverter.removePunctuationAndSpaces(from: rawPart)
    }
}

// MARK: - DateAggregator
class RawDateAggregator {
    static var retrieverList = [AvailableFormatDateRetriever()]
    
    static func tryRetrieveDate(from rawDate: String) -> Date? {
        var date: Date?
        for retriever in retrieverList {
            date = retriever.retrieveDate(from: rawDate)
            if date != nil {
                return date
            }
        }
        return nil
    }
}

// MARK: - Date retrievers
class BaseDateRetriever {
    func retrieveDate(from rawDate: String) -> Date? {
        return .now
    }
}


class AvailableFormatDateRetriever: BaseDateRetriever {
    override func retrieveDate(from rawDate: String) -> Date? {
        
        var date = DateFormatter().date(from: rawDate)
        
        return date
    }
}
