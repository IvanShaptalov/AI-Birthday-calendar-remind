protocol WishMakerProtocol{
    var wishType: String { get set}
    var toWho: String {get set}
    var messageStyle: String {get set}
    var ageOpt: String? {get set}
    var addInfoOps: String? {get set}
    
    func sendRequest(callback: @escaping (String) -> Void, error: @escaping (String) -> Void)
}

class WishMaker: WishMakerProtocol {
    var wishType: String
    var toWho: String
    var messageStyle: String
    var ageOpt: String?
    var addInfoOps: String?
    
    init(wishType: String, toWho: String, messageStyle: String, ageOpt: String?, addInfoOps: String?) {
        self.wishType = wishType
        self.toWho = toWho
        self.messageStyle = messageStyle
        self.ageOpt = ageOpt
        self.addInfoOps = addInfoOps
    }
    
    func sendRequest(callback: @escaping (String) -> Void, error: @escaping (String) -> Void) {
        // Implement sending the wish request here
        // You can use the properties like wishType, toWho, messageStyle, ageOpt, addInfoOps to compose the wish message
        
        // Simulating sending request for demonstration purposes
        let wishMessage = "Sending \(wishType) wish to \(toWho)"
        callback(wishMessage)
    }
}

// Creating an instance of WishMaker
let wishMaker = WishMaker(wishType: "Birthday", toWho: "Alice", messageStyle: "Formal", ageOpt: "25", addInfoOps: "Gift: Watch")

// Sending a wish request
wishMaker.sendRequest(callback: { wishMessage in
    print("Wish request sent successfully: \(wishMessage)")
}, error: { errorMessage in
    print("Error sending wish request: \(errorMessage)")
})