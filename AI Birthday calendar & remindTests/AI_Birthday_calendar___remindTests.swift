//___FILEHEADER___

import XCTest
@testable import AI_Birthday_calendar___remind

final class ___FILEBASENAMEASIDENTIFIER___: XCTestCase {

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
        let mainEvent1 = MainEvent(eventDate: .now, eventType: .anniversary, title: "title", rule: .twoDaysBefore, id: UUID().uuidString)
        let mainEvent2 = MainEvent(eventDate: .now, eventType: .simpleEvent, title: "title", rule: .oneDayBefore, id: UUID().uuidString, congratulation: "aboba")
        let mainEvent3 = MainEvent(eventDate: .now, eventType: .birthday, title: "title", rule: .fiveDaysBefore, id: UUID().uuidString)
        
        let events = [mainEvent1, mainEvent2, mainEvent3]
        
        let jsonString = MainEventJsonCoder.toJson(events)
        
        let events2 = MainEventJsonCoder.fromJson(eventListJson: jsonString)
        
        XCTAssertEqual(events, events2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
