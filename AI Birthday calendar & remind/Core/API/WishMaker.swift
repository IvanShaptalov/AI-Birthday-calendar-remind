enum GptError:String{
    case
    limitReached = "You limit reached today",
    invalidApi = "Invalid api of gpt",
    noConnection = "No internet connection ",
    timeoutGPT = "Timeout, gpt not responding",
    invalidDictionary = "Data can't read"
}

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
    
    init(wishType: String, toWho: String, messageStyle: String, ageOpt: String?, mentionsOpt: String?) {
        self.wishType = wishType
        self.toWho = toWho
        self.messageStyle = messageStyle
        self.ageOpt = ageOpt
        self.addInfoOps = mentionsOpt
    }
    
    func sendRequest(callback: @escaping (String) -> Void, error: @escaping (String) -> Void) {
        var ageText = ""
        if ageOpt != nil {
            ageText = "consider years is \(ageOpt!) old"
        }
        var addInfoText = ""
        if addInfoOps != nil {
            addInfoText = "and \(toWho) Name is \(addInfoOps!)"
        }
        OpenAIApi.request("Pretend that you congratulate from my name, also \(ageText) \(addInfoText). \(toWho) with \(wishType) in \(messageStyle) style", rawCompletion: callback, errorCompletion: error)
    }
}
