import Foundation



class OpenAIApi{
    
    static func request(_ reqText: String, rawCompletion: @escaping (String)->Void, errorCompletion: @escaping(String)-> Void) {
        NSLog("enter RAW")
        NSLog(reqText)

        let jsonData = [
            "model": AppConfiguration.gptModel,
            "messages": [
                [
                    "role": "system",
                    "content": "\(AppConfiguration.gptSystemPrompt)"
                ],
                [
                    "role": "user",
                    "content": reqText
                ]
            ]
        ] as [String : Any]
        
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AppConfiguration.gptToken)"
        ]
        
        if AppConfiguration.gptToken.isEmpty {
            errorCompletion(GptError.invalidApi.rawValue)
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        NSLog("url request sent")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                errorCompletion(error.localizedDescription)
                return
            } else if let data = data {
                print("url data received")
                if let dict = convertToDictionary(data: data),
                   let choices = dict["choices"] as? NSArray,
                    let message = choices.firstObject as? NSDictionary,
                    let messageValue = message["message"] as? NSDictionary,
                    let str = messageValue["content"] as? String {
                    print(str)
                    rawCompletion(str)
                    return
                } else {
                    AppConfiguration.switchGptModel()
                    errorCompletion(GptError.limitReached.rawValue)
                    return
                }
                
            }
        }.resume()
        
        func convertToDictionary(data: Data) -> NSDictionary? {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                return json
            } catch {
                errorCompletion(GptError.invalidDictionary.rawValue)
            }
            return nil
        }
    }
}


