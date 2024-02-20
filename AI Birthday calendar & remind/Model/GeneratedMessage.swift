//
//  GeneratedMessage.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 20.02.2024.
//

import Foundation

/// Generating messages using message style and wishGenerator Enum type
protocol GeneratedMessageProtocol{
    /// what kind of message: holiday, toast, birthday etc
    var metaRule: WishGeneratorEnum {get}
    /// result
    func generatedText() -> String
    /// meta for category, for example holiday title and description here
    var generatedMeta: WishGeneratorClass {get}
    /// generated text receiver
    var receiver: ReceiverEnum {get set}
    /// style of generated text
    var style: MessageStyle {get set}
}

struct GeneratedMessage: GeneratedMessageProtocol {
    var receiver: ReceiverEnum
    
    var style: MessageStyle
    
    var metaRule: WishGeneratorEnum
    
    func generatedText() -> String{
        return ""
    }
    
    var generatedMeta: WishGeneratorClass
        
    init(receiver: ReceiverEnum, style: MessageStyle, metaRule: WishGeneratorEnum) {
        self.receiver = receiver
        self.style = style
        self.metaRule = metaRule
        self.generatedMeta = WishGeneratorClass(rule: metaRule)
    }
}


