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
    missedElement = "missed element or separator used more than once"
}

// MARK: - Converters
class BaseRuleConverter{
    var event: MainEvent
    var raw: String
    
    init(raw: String) {
        self.event = .init(eventDate: .now, eventType: .birthday, title: "-", id: UUID().uuidString)
        self.raw = raw
    }
    
    func convert(line: Int, statusCallback: @escaping(Status, Int) -> Void){
        
    }
    
    static func removePunctuationAndSpaces(from input: String) -> String {
        let cleanedString = input.trimmingCharacters(in: CharacterSet.punctuationCharacters.union(CharacterSet.whitespaces))
        
        return cleanedString
    }
    
    static func removeSubstring(originalString: String, substringToRemove: String) -> String{

        if originalString.range(of: substringToRemove) != nil {
            let result = originalString.replacingOccurrences(of: substringToRemove, with: "")
            return result
        } else {
            return originalString
        }

    }
}

// MARK: - Separator List
enum SeparatorList: String {
    case
    dot = ".",
    comma = ",",
    exclamation = "!",
    questionMark = "?",
    semicolon = ";",
    colon = ":",
    hyphen = "-",
    underscore = "_"
    
    static func allValues() -> [SeparatorList]{
        return [dot, comma, exclamation, questionMark, semicolon, colon, hyphen, underscore]
    }
}

// MARK: - Converter to use
class RuleConverterV1: BaseRuleConverter{
    
    override func convert(line: Int, statusCallback: @escaping(Status, Int) -> Void) {
        var components: [String] = []
        
        // split using all separator list
        for separator in SeparatorList.allValues() {
            let newComponents = self.raw.components(separatedBy: separator.rawValue)
            if newComponents.count == 2 {
                components += newComponents
            }
        }
        
        // split not give any results
        if components.count < 2 {
            statusCallback(.missedElement, line)
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
                rawForName = RuleConverterV1.removeSubstring(originalString: self.raw, substringToRemove: component)
                
                
                
                break
            }
        }
        // date not found
        if date == nil {
            statusCallback(.dateNotConverted, line)
            return
        }
        
        // name not found
        if rawForName == nil {
            statusCallback(.nameNotConverted, line)
            return
        }
        
        // add name
        rawForName = RuleConverterV1.removePunctuationAndSpaces(from: rawForName!)
        self.event.title = rawForName!
        statusCallback(.eventConverted, line)
        
    }
    
    func retrieveDate(rawPart: String) -> Date? {
        let cleanedString = RuleConverterV1.removePunctuationAndSpaces(from: rawPart)
        return RawDateAggregator.tryRetrieveDate(from: cleanedString)
    }
    
    func retrieveName(rawPart: String) -> String {
        return RuleConverterV1.removePunctuationAndSpaces(from: rawPart)
    }
}

// MARK: - DateAggregator
class RawDateAggregator {
    static var retrieverList = [BaseDateRetriever()]
    
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
        let formatter = DateFormatter()
        var date: Date?
        
        for format in DATE_FORMATS {
            formatter.dateFormat = format
            date = formatter.date(from: rawDate)
            
            if date != nil {
                return date
            }
        }
        
        return nil
    }
}

