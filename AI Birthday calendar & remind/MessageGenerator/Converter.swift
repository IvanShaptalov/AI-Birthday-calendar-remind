//
//  WordFiller.swift
//  Learn Up
//
//  Created by PowerMac on 08.01.2024.
//

import Foundation

protocol GPTConverterProtocol {
    static func delegateToRawApi(wfRequest: MessageGeneratorRequestProtocol,converterCompletion: @escaping(MessageGeneratorResponseProtocol)->())
}


class GPTConverter: GPTConverterProtocol {
    static func delegateToRawApi(wfRequest: MessageGeneratorRequestProtocol, converterCompletion: @escaping (MessageGeneratorResponseProtocol) -> ()) {
        NSLog("enter delegateToRawApi")
        
        

        let rawRequest = "generate birthday congratulation"
        
        OpenAIApi.request(RawRequest(raw: rawRequest), rawCompletion: {response in
            NSLog("RAW completion")

            let fillerResponse: MessageGeneratorResponseProtocol = fromRawToFiller(rawResponse: response.response)
            
            return converterCompletion(fillerResponse)
            
        })
    }
    
    public static func fromRawToFiller(rawResponse: String) -> MessageGeneratorResponseProtocol {
        return MessageGeneratorResponse(message: rawResponse)
    }
    
    
    
}
