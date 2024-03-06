import Foundation



class OpenAIApi: RawApi {
    
    static func request(_ request: RawRequestProtocol, rawCompletion: @escaping (RawResponseProcotol)->()) {
        NSLog("enter RAW")

        let jsonData = [
            "model": AppConfiguration.gptModel,
            "messages": [
                [
                    "role": "system",
                    "content": """
You are helpful assistant that generate congratulations on birthdays and anniversaries
"""
                ],
                [
                    "role": "user",
                    "content": request.raw
                ]
            ]
        ] as [String : Any]
        
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        // let data = "{\n    \"model\": \"gpt-3.5-turbo\",\n    \"messages\": [\n      {\n        \"role\": \"system\",\n        \"content\": \"You are a helpful assistant designed to translate words and give output JSON., you have 3 fields: translation, pronunciation, meaning\"\n      },\n      {\n        \"role\": \"user\",\n        \"content\": \"cabbage перевод на русский. ответь в формате translation:_;meaning тут вставь значение слова cabbage до 10 слов; pronunciation: транскрипция слова cabbage\"\n      }\n    ]\n  }".data(using: .utf8)
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AppConfiguration.gptToken)"
        ]
        
        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        NSLog("url request sent")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return rawCompletion(RawResponse(response: error.localizedDescription, code: 400))
            } else if let data = data {
                print("url data received")
                if let dict = convertToDictionary(data: data),
                   let choices = dict["choices"] as? NSArray,
                    let message = choices.firstObject as? NSDictionary,
                    let messageValue = message["message"] as? NSDictionary,
                    let str = messageValue["content"] as? String {
                    print(str)
                    return rawCompletion(RawResponse(response: str, code: 200))
                } else {
                    AppConfiguration.switchGptModel()
                    return rawCompletion(RawResponse(response: "limit reached", code: 400))
                }
                
            }
        }.resume()
        
        
        
        func convertToDictionary(data: Data) -> NSDictionary? {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                return json
            } catch {
                print("Something went wrong")
            }
            return nil
        }
    }
}


