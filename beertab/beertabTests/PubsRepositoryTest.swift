//
//  PubsRepositoryTest.swift
//  beertabTests
//
//  Created by Michael Neilens on 18/11/2020.
//

import XCTest
@testable import beertab
class PubsRepositoryTest: XCTestCase {

    let pubsJsonString = """
    {"Pubs":[{"Id":"17030","Branch":"MDX","Name":"Dodo Micropub","Distance":"0.0 miles (0.0km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=17030&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"16798","Branch":"MDX","Name":"w7emporium","Distance":"0.0 miles (0.1km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=16798&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"12215","Branch":"MDX","Name":"Prince of Wales","Distance":"0.1 miles (0.1km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=12215&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"12206","Branch":"MDX","Name":"Village Inn","Distance":"0.1 miles (0.1km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=12206&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"12216","Branch":"MDX","Name":"Green W7","Distance":"0.1 miles (0.1km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=12216&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"12213","Branch":"MDX","Name":"Kings Arms","Distance":"0.1 miles (0.2km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=12213&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"12211","Branch":"MDX","Name":"Duke Of York","Distance":"0.1 miles (0.2km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=12211&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"12212","Branch":"MDX","Name":"Lavins","Distance":"0.2 miles (0.3km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=12212&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"12214","Branch":"MDX","Name":"Viaduct","Distance":"0.2 miles (0.3km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=12214&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"},{"Id":"13201","Branch":"MDX","Name":"Hanwell Conservative Club","Distance":"0.2 miles (0.4km)","Town":"Hanwell","PubService":"https://pubcrawlapi.appspot.com/pub/?v=1&id=13201&branch=MDX&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&town=Hanwell"}],"PageNo":1,"NoOfPages":88,"ListTitle":"Pubs nearby","MorePubsService":"https://pubcrawlapi.appspot.com/listofpubs/?search=nearby&page=2&lat=51.507074&lng=-0.337626&uId=&pubs=&realAle=&memberDiscount=&garden=&lmeals=&emeals=&events=","Message":{"Status":0,"Text":"Pubs retrieved."}}
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

    func testRequestIsAssembledCorrectly() throws {
        var pubsRepository = PubsRepository()
        let mockConnector = MockConnector(data: nil, response: nil, error: nil)
        pubsRepository.connector = mockConnector
        
        pubsRepository.readPubsNearBy(location: Location(lng: 1.0, lat: 2.0), onCompletion: {pubs in })
        let request = mockConnector.urlRequest
        XCTAssertEqual("https://pubcrawlapi.appspot.com/listofpubs/?search=nearby&page=1&lat=2.0&lng=1.0", request.url?.absoluteString)
        XCTAssertEqual("GET",request.httpMethod)
        XCTAssertEqual(1,mockConnector.noOfTimesSendRequested)
    }

    func testDecodeReturnsListOfPubs() throws {
        let pubsRepository = PubsRepository()
        let pubsJsonData =  pubsJsonString.data(using: .utf8)
        let listOfPubs = pubsRepository.decode(data: pubsJsonData!)
        XCTAssertEqual(10, listOfPubs.pubHeaders.count)
        XCTAssertEqual("Dodo Micropub", listOfPubs.pubHeaders[0].name)
        XCTAssertEqual("MDX", listOfPubs.pubHeaders[0].branch)
        XCTAssertEqual("17030", listOfPubs.pubHeaders[0].id)
        XCTAssertEqual("Hanwell Conservative Club", listOfPubs.pubHeaders[9].name)
        XCTAssertEqual("MDX", listOfPubs.pubHeaders[9].branch)
        XCTAssertEqual("13201", listOfPubs.pubHeaders[9].id)
    }
    
    func testReadCompletionDoesntCompleteIfError() {
        let expectation = self.expectation(description: "Should not execute completion")
        expectation.expectedFulfillmentCount = 1
        expectation.isInverted = true
        
        let pubsRepository = PubsRepository()
        let pubsJsonData =  pubsJsonString.data(using: .utf8)
        func completion(pubs:ListOfPubs) {  expectation.fulfill()}
        pubsRepository.readCompletion(data: pubsJsonData, response: nil, error: RequestError.badRequest, completion: completion(pubs:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testReadCompletionCompletesIfNoErrors() {
        let expectation = self.expectation(description: "Should execute completion")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        let pubsRepository = PubsRepository()
        let pubsJsonData =  pubsJsonString.data(using: .utf8)
        func completion(pubs:ListOfPubs) {
            XCTAssertEqual(10, pubs.pubHeaders.count)
            expectation.fulfill()}
        pubsRepository.readCompletion(data: pubsJsonData, response: nil, error: nil, completion: completion(pubs:))
        wait(for: [expectation], timeout: 0.1)
    }

    func testReadPubsNearBy() throws {
        let expectation = self.expectation(description: "Should execute completion and return list of pubs")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        var pubsRepository = PubsRepository()
        let pubsJsonData =  pubsJsonString.data(using: .utf8)
        let mockConnector = MockConnector(data: pubsJsonData, response: nil, error: nil)
        pubsRepository.connector = mockConnector
        
        func completion(pubs:ListOfPubs) {
            XCTAssertEqual(10, pubs.pubHeaders.count)
            expectation.fulfill()
        }
        
        pubsRepository.readPubsNearBy(location: Location(lng: 1.0, lat: 2.0), onCompletion: completion(pubs:))
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

