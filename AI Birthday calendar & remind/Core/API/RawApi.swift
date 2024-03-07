//
//  RawRequests.swift
//  Learn Up
//
//  Created by PowerMac on 08.01.2024.
//

import Foundation
import UIKit

enum GptError:String{
    case
    limitReached = "You limit reached today",
    invalidApi = "Invalid api of gpt",
    
    noConnection = "No internet connection ",
    
    timeout = "Timeout, gpt not responding"
}

// MARK: - Api abstraction
protocol RawApi {
    static func request(_ request: RawRequestProtocol, rawCompletion: @escaping(RawResponseProcotol)->(),
    error: @escaping(GptError)->())
}

protocol RawRequestProtocol {
    var raw: String {get set}
}

protocol RawResponseProcotol {
    var response: String {get set}
    var code: Int {get set}
}


// MARK: - GPTAPI
class RawRequest: RawRequestProtocol {
    var raw: String
    
    init(raw: String) {
        self.raw = raw
    }
    
    
}

class RawResponse: RawResponseProcotol {
    var response: String
    var code = 200
    private var defaultResponse = "default"
    
    init(response: String, code: Int) {
        self.response = response
        self.code = code
    }
    
    init() {
        self.response = defaultResponse
        self.code = 200
    }
}

