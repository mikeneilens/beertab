//
//  TabRepositoryTest.swift
//  beertabTests
//
//  Created by Michael Neilens on 18/11/2020.
//

import XCTest
@testable import beertab
class TabRepositoryTest: XCTestCase {

    let tabJsonString = """
    {"pubName":"Dodo Micropub","createTS":627405767.42329299,"id":"17030","name":"","branch":"MDX","tabItems":[{"size":"Pint","brewer":"Siren","name":"Broken Dream","price":440,"transactions":[]},{"size":"Half","brewer":"Siren","name":"Broken Dream","price":225,"transactions":[]},{"size":"Pint","brewer":"Anspach","name":"Ordinary","price":420,"transactions":[]},{"size":"Half","brewer":"Anspach","name":"Ordinary","price":215,"transactions":[]}]}
    """
    
    enum RequestError:Error {
        case badRequest
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadLatestRequestIsAssembledCorrectly() throws {
        var tabRepository = TabRepository()
        let mockConnector = MockConnector(data: nil, response: nil, error: nil)
        tabRepository.connector = mockConnector
        
        tabRepository.readLatest(id: "17030", branch: "MDX", onCompletion: {tabItems in})
        let request = mockConnector.urlRequest
        XCTAssertEqual("https://pubcrawlapi.appspot.com/tab/MDX/17030/", request.url?.absoluteString)
        XCTAssertEqual("GET",request.httpMethod)
        XCTAssertEqual(1,mockConnector.noOfTimesSendRequested)
    }

    func testWriteLatestRequestIsAssembledCorrectly() throws {
        var tabRepository = TabRepository()
        let mockConnector = MockConnector(data: nil, response: nil, error: nil)
        tabRepository.connector = mockConnector
        
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "half", price: 450)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "testbr", id: "testid", tabItems: [tabItem1,tabItem2])
        tabRepository.writeLatest(tab: tab, onCompletion:{tabItems in})
        
        let request = mockConnector.urlRequest
        XCTAssertEqual("https://pubcrawlapi.appspot.com/tab/testbr/testid/", request.url?.absoluteString)
        XCTAssertEqual("POST",request.httpMethod)
        XCTAssertEqual(1,mockConnector.noOfTimesSendRequested)
    }
    
    func testDecodeCreatesTabItemsCorrectly() throws {
        let tabJsonData =  tabJsonString.data(using: .utf8)
        let tabItems = decode(data: tabJsonData!)
        
        XCTAssertEqual(4, tabItems.count)
        XCTAssertEqual("Siren", tabItems[0].brewer)
        XCTAssertEqual("Broken Dream", tabItems[0].name)
        XCTAssertEqual("Pint", tabItems[0].size)
        XCTAssertEqual(440, tabItems[0].price)
        XCTAssertEqual("Anspach", tabItems[3].brewer)
        XCTAssertEqual("Ordinary", tabItems[3].name)
        XCTAssertEqual("Half", tabItems[3].size)
        XCTAssertEqual(215, tabItems[3].price)
    }
    
    func testReadCompletionDoesntCompleteIfError() {
        let expectation = self.expectation(description: "Should not execute completion")
        expectation.expectedFulfillmentCount = 1
        expectation.isInverted = true
        
        let tabRepository = TabRepository()
        let tabJsonData =  tabJsonString.data(using: .utf8)
        func completion(tabItems:Array<TabItem>) {  expectation.fulfill()}
        tabRepository.readCompletion(data: tabJsonData, response: nil, error: RequestError.badRequest, completion: completion(tabItems:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testReadCompletionDoesCompleteIfNoError() {
        let expectation = self.expectation(description: "Should execute completion")
        expectation.expectedFulfillmentCount = 1
        
        let tabRepository = TabRepository()
        let tabJsonData =  tabJsonString.data(using: .utf8)
        func completion(tabItems:Array<TabItem>) {
            XCTAssertEqual(4,tabItems.count)
            expectation.fulfill()}
        tabRepository.readCompletion(data: tabJsonData, response: nil, error: nil, completion: completion(tabItems:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testWriteCompletionDoesntCompleteIfError() {
        let expectation = self.expectation(description: "Should not execute completion")
        expectation.expectedFulfillmentCount = 1
        expectation.isInverted = true
        
        let tabRepository = TabRepository()
        let tabJsonData =  tabJsonString.data(using: .utf8)
        func completion(tabItems:Array<TabItem>) {  expectation.fulfill()}
        tabRepository.writeCompletion(data: tabJsonData, response: nil, error: RequestError.badRequest, completion: completion(tabItems:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testWriteCompletionDoesCompleteIfNoError() {
        let expectation = self.expectation(description: "Should execute completion")
        expectation.expectedFulfillmentCount = 1
        
        let tabRepository = TabRepository()
        let tabJsonData =  tabJsonString.data(using: .utf8)
        func completion(tabItems:Array<TabItem>) {
            XCTAssertEqual(4,tabItems.count)
            expectation.fulfill()}
        tabRepository.writeCompletion(data: tabJsonData, response: nil, error: nil, completion: completion(tabItems:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testReadLatest() throws {
        let expectation = self.expectation(description: "Should execute completion and return list of tabItems")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        var tabRepository = TabRepository()
        let tabJsonData =  tabJsonString.data(using: .utf8)
        let mockConnector = MockConnector(data: tabJsonData, response: nil, error: nil)
        tabRepository.connector = mockConnector
        
        func completion(tabItems:Array<TabItem>) {
            XCTAssertEqual(4, tabItems.count)
            expectation.fulfill()
        }
        tabRepository.readLatest(id: "id1", branch: "br1", onCompletion: completion(tabItems:))
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testWriteLatest() throws {
        let expectation = self.expectation(description: "Should execute completion and return list of tabItems")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        var tabRepository = TabRepository()
        let tabJsonData =  tabJsonString.data(using: .utf8)
        let mockConnector = MockConnector(data: tabJsonData, response: nil, error: nil)
        tabRepository.connector = mockConnector
        
        func completion(tabItems:Array<TabItem>) {
            XCTAssertEqual(4, tabItems.count)
            expectation.fulfill()
        }
        
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "half", price: 450)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "testbr", id: "testid", tabItems: [tabItem1,tabItem2])
        
        tabRepository.writeLatest(tab: tab, onCompletion: completion)
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
