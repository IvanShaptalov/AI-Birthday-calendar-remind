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
    
    // MARK: - Date tests
    func testEventDateDistance() throws {
        let mainEvent1 = MainEvent(eventDate: .now.addingTimeInterval(-(24*60*60)), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DateEventFormatter.dateDistance(from: mainEvent1.eventDate, to: .now, components: [.day]).day, 1)
    }
    
    func testDayOfWeek() throws {
        let mainEvent1 = MainEvent(eventDate: Date(timeIntervalSince1970: 0), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DateEventFormatter(date: mainEvent1.eventDate).dayOfWeekCalendarFormat(), "Thu")
    }
    
    func testYearsTurnsNewDate() throws {
        let mainEvent1 = MainEvent(eventDate: .now.addingTimeInterval(+(24*60*60)), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DateEventFormatter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 0 in 1 day")
        
        var comps = Calendar.current.dateComponents([.year, .month,.day,.hour,.minute,.second], from: mainEvent1.eventDate)
        
        for i in 1...23 {
            comps.hour = i
            mainEvent1.eventDate = Calendar.current.date(from: comps)!
            NSLog("hour: \(i)")
            XCTAssertEqual(DateEventFormatter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 0 in 1 day")
        }
    }
    
    func testYearsTurnsOldDate() throws {
        let mainEvent1 = MainEvent(eventDate: .now.addingTimeInterval(-(24*60*60)), eventType: .anniversary, title: "title", id: UUID().uuidString)
        
        XCTAssertEqual(DateEventFormatter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 1 in 364 days")
        
        var comps = Calendar.current.dateComponents([.year, .month,.day,.hour,.minute,.second], from: mainEvent1.eventDate)
        for i in 1...23 {
            comps.hour = i
            mainEvent1.eventDate = Calendar.current.date(from: comps)!
            NSLog("hour: \(i)")
            XCTAssertEqual(DateEventFormatter(date: mainEvent1.eventDate).yearsTurnsInDays(), "turns 1 in 364 days")

        }
    }
    
    
    // MARK: - GPT switch
    func testGptSwitch(){
        XCTAssert(AppConfiguration.gptModel == "gpt-3.5-turbo-1106")
        AppConfiguration.switchGptModel()
        
        XCTAssert(AppConfiguration.gptModel == "gpt-3.5-turbo-0301")
        
        AppConfiguration.switchGptModel()
        AppConfiguration.switchGptModel()
        XCTAssert(AppConfiguration.gptModel == "gpt-3.5-turbo-0613")
    }
    
    
    
    func testSeason(){
        for i in 3 ... 5{
            let date = Calendar.current.date(bySetting: .month, value: i, of: .now)
            XCTAssertEqual(EventSeasonController.getSeason(date!), .SpringSeason)
        }
        for i in 6 ... 8{
            let date = Calendar.current.date(bySetting: .month, value: i, of: .now)
            XCTAssertEqual(EventSeasonController.getSeason(date!), .Summer)
        }
        for i in 9 ... 11{
            let date = Calendar.current.date(bySetting: .month, value: i, of: .now)
            XCTAssertEqual(EventSeasonController.getSeason(date!), .Autumn)
        }
        for i in 1 ... 2{
            let date = Calendar.current.date(bySetting: .month, value: i, of: .now)
            XCTAssertEqual(EventSeasonController.getSeason(date!), .Winter)
        }
        let date = Calendar.current.date(bySetting: .month, value: 12, of: .now)
        XCTAssertEqual(EventSeasonController.getSeason(date!), .Winter)
        
    }
    
    
    func testRemovePunctuationAndSpaces() {
            let input = "Hello, World!"
            let expectedOutput = "Hello, World"
            
        let result = BaseRuleConverter.removePunctuationAndSpaces(from: input)
            
            XCTAssertEqual(result, expectedOutput)
        }
        
        func testRemovePunctuationAndSpacesWithSpaces() {
            let input = "  Hello, World!  "
            let expectedOutput = "Hello, World"
            
            let result = BaseRuleConverter.removePunctuationAndSpaces(from: input)
            
            XCTAssertEqual(result, expectedOutput)
        }
        
        func testRemovePunctuationAndSpacesWithMixedCharacters() {
            let input = "He*llo, W#orld!"
            let expectedOutput = "He*llo, W#orld"
            
            let result = BaseRuleConverter.removePunctuationAndSpaces(from: input)
            
            XCTAssertEqual(result, expectedOutput)
        }
    
    func testManualTextImportAllSeparators() {
        let raws = ["17.04.2002",
        "2002-04-17",
        "04/17/2002",
        "17/04/2002",
        "04-17-2002",
        "2002/04/17",
        "17 Apr 2002",
        "Apr 17, 2002",
        "2002/Apr/17",
        "17-04-2002",
        "2002.04.17",
        "17 Apr 2002",
        "Apr-17-2002",
        "2002 Apr 17",
        "17/04/2002 00:00:00",
        "04/17/2002 00:00:00",
        "2002-04-17 00:00:00",
        "17.04.2002 00:00:00",
        "Apr 17, 2002 00:00:00",
        "2002/Apr/17 00:00:00"]
        
        for (index, raw) in raws.enumerated() {
            let ready = "helena ! " + raw
            
            let dateString = "17.04.2002"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"

            let date = dateFormatter.date(from: dateString)

            let converter = RuleConverterV1(raw: ready)
            
            converter.convert(line: index, statusCallback: {status,isOk  in
                XCTAssertEqual(status, .eventConverted)
                XCTAssertEqual(converter.event.eventDate, date)
                XCTAssertEqual(converter.event.title, "helena")
            })
            NSLog("🥦 raw format : \(ready)")
            NSLog("🐨 event name: \(converter.event.title)")
            NSLog("📅 event date: \(converter.event.eventDate)")
        }
        
        sleep(10)
        
        for (index,raw) in raws.enumerated() {
            let ready = raw +  "! helena"
            
            let dateString = "17.04.2002"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"

            let date = dateFormatter.date(from: dateString)

            let converter = RuleConverterV1(raw: ready)
            
            converter.convert(line: index, statusCallback: {status,isOk  in
                XCTAssertEqual(status, .eventConverted)
                XCTAssertEqual(converter.event.eventDate, date)
                XCTAssertEqual(converter.event.title, "helena")
            })
            NSLog("🥦 raw format : \(ready)")
            NSLog("🐨 event name: \(converter.event.title)")
            NSLog("📅 event date: \(converter.event.eventDate)")
        }
        sleep(10)
    }
    
    
}
