//
//  WordFiller.swift
//  Learn Up
//
//  Created by PowerMac on 08.01.2024.
//

import Foundation

/// use Converter as layer
/// WordFiller fillWord -> Converter
/// Converter -> RawAPI
/// RawAPI -> Converter
/// Converter -> WordFiller fillWord Response
protocol WordFillerProtocol {
    static func fillWord(_ request: MessageGeneratorRequestProtocol, fillerCompletion: @escaping(MessageGeneratorResponseProtocol)->())
}

protocol MessageGeneratorRequestProtocol {
    var message: String {get set}
}

protocol MessageGeneratorResponseProtocol {
    var message: String {get set}
}


class WordFiller: WordFillerProtocol{
    static func fillWord(_ request: MessageGeneratorRequestProtocol, fillerCompletion: @escaping (MessageGeneratorResponseProtocol) -> ()) {
        NSLog("enter fillWord")
        GPTConverter.delegateToRawApi(wfRequest: request, converterCompletion: {response in
            
            NSLog("enter converter Completion \(response.message)")

            return fillerCompletion(response)
        })
    }
}

class MessageGeneratorRequest: MessageGeneratorRequestProtocol, Equatable{
    static func == (lhs: MessageGeneratorRequest, rhs: MessageGeneratorRequest) -> Bool {
        return lhs.message == rhs.message
    }
    
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    
}

class MessageGeneratorResponse: MessageGeneratorResponseProtocol {
    
    var message: String
    
    init(message: String) {
       
        self.message = message
    }
    
    init(){
     // MARK: - TODO create default congrats
        self.message = "default"
    }
}
