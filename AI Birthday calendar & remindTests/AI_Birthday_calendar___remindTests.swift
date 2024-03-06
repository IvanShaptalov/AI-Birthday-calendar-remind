//___FILEHEADER___

import XCTest
@testable import AI_Birthday_calendar___remind

final class AI_Birthday_calendar___remind: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    // MARK: - Origin word
    func testMainEventJson() throws {
        let mainEvent1 = MainEvent(eventDate: .now, eventType: .anniversary, title: "title", id: UUID().uuidString)
        let mainEvent2 = MainEvent(eventDate: .now, eventType: .simpleEvent, title: "title",  id: UUID().uuidString, congratulation: "aboba")
        let mainEvent3 = MainEvent(eventDate: .now, eventType: .birthday, title: "title",  id: UUID().uuidString)
        
        let events = [mainEvent1, mainEvent2, mainEvent3]
        
        let jsonString = MainEventJsonCoder.toJson(events)
        
        let events2 = MainEventJsonCoder.fromJson(eventListJson: jsonString)
        
        XCTAssertEqual(events, events2)
    }
    
    func testMainEventJsonAndStorage() throws {
        MainEventStorage.reset()
        let mainEvent1 = MainEvent(eventDate: .now, eventType: .anniversary, title: "title", id: UUID().uuidString)
        let mainEvent2 = MainEvent(eventDate: .now, eventType: .simpleEvent, title: "title",  id: UUID().uuidString, congratulation: "aboba")
        let mainEvent3 = MainEvent(eventDate: .now, eventType: .birthday, title: "title",  id: UUID().uuidString)
        
        let events = [mainEvent1, mainEvent2, mainEvent3]
        
        MainEventStorage.save(events)
        
        let events2 = MainEventStorage.load()
        
        XCTAssertEqual(events, events2)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEventDateDistance() throws {
        let mainEvent1 = MainEvent(eventDate: .now.addingTimeInterval(-(24*60*60)), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DatePrinter.dateDistance(from: mainEvent1.eventDate, to: .now, components: [.day]).day, 1)
    }
    
    func testDayOfWeek() throws {
        let mainEvent1 = MainEvent(eventDate: Date(timeIntervalSince1970: 0), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DatePrinter(date: mainEvent1.eventDate).dayOfWeekCalendarFormat(), "Thu")
    }
    
    func testYearsTurnsNewDate() throws {
        let mainEvent1 = MainEvent(eventDate: .now.addingTimeInterval(+(24*60*60)), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DatePrinter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 0 in 1 day")
        
        var comps = Calendar.current.dateComponents([.year, .month,.day,.hour,.minute,.second], from: mainEvent1.eventDate)
        
        for i in 1...23 {
            comps.hour = i
            mainEvent1.eventDate = Calendar.current.date(from: comps)!
            NSLog("hour: \(i)")
            XCTAssertEqual(DatePrinter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 0 in 1 day")
        }
    }
    
    func testYearsTurnsOldDate() throws {
        let mainEvent1 = MainEvent(eventDate: .now.addingTimeInterval(-(24*60*60)), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DatePrinter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 1 in 364 days")
        
        var comps = Calendar.current.dateComponents([.year, .month,.day,.hour,.minute,.second], from: mainEvent1.eventDate)
        for i in 1...23 {
            comps.hour = i
            mainEvent1.eventDate = Calendar.current.date(from: comps)!
            NSLog("hour: \(i)")
            XCTAssertEqual(DatePrinter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 1 in 364 days")

        }
    }
    
    func testGptSwitch(){
        XCTAssert(AppConfiguration.gptModel == "gpt-3.5-turbo-1106")
        AppConfiguration.switchGptModel()
        
        XCTAssert(AppConfiguration.gptModel == "gpt-3.5-turbo-0301")
        
        AppConfiguration.switchGptModel()
        AppConfiguration.switchGptModel()
        XCTAssert(AppConfiguration.gptModel == "gpt-3.5-turbo-0613")
    }
    
//    func testKeys() throws {
//        XCTAssertGreaterThan(LearnUpConfiguration.gptToken.count, 10)
//        XCTAssertGreaterThan(LearnUpConfiguration.gptOrganization.count, 0)
//    }
//    
//    func testRequest() throws {
//        
//        var myResponse = RawResponse(response: "", code: 404)
//        
//        OpenAIApi.request(RawRequest(raw: "translate sakartvelo from English to Russian. give answer in this format: translation: word translation| meaning: meaning in English"), rawCompletion: {response in
//            XCTAssertEqual(response.code, 200)
//            myResponse = response as! RawResponse
//            print(response.response)
//        })
//                
//        sleep(10)
//        
//        XCTAssertEqual(myResponse.code, 200)
//        NSLog(myResponse.response)
//    }
//    
//    func testFillWord() throws {
//        var myResponse = WordFillerResponse()
//
//        WordFiller.fillWord(WordFillerRequest(word: "hello", toLang: .Ukrainian, fromLang: .English), fillerCompletion: {response in
//            NSLog("enter fillWord completion")
//            NSLog(response.translation)
//            
//            XCTAssertTrue(response.translation.contains("привіт") || response.translation.contains("топор"))
//            myResponse = response as! WordFillerResponse
//        })
//        sleep(10)
//        XCTAssertNotEqual(myResponse.meaning, "default")
//    }
}
