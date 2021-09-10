//
//  BillRepositoryTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 09/09/2021.
//

import XCTest
@testable import beertab
class BillRepositoryTest: XCTestCase {

    let tabJsonString = """
    {"pubName":"Dodo Micropub","createTS":627405767.42329299,"id":"17030","name":"","branch":"MDX","tabItems":[{"size":"Pint","brewer":"Siren","name":"Broken Dream","price":440,"transactions":[]},{"size":"Half","brewer":"Siren","name":"Broken Dream","price":225,"transactions":[]},{"size":"Pint","brewer":"Anspach","name":"Ordinary","price":420,"transactions":[]},{"size":"Half","brewer":"Anspach","name":"Ordinary","price":215,"transactions":[]}]}
    """
    static let bill1JsonString = """
    {"tabs":[{"branch":"test_br","tabItems":[],"id":"test_id","createTS":652883601.96784794,"tabId":"GCHHYWVC","pubName":"test_pub","name":"test tab1"}],"billId":"BDLT"}
    """
    static let bill2JsonString = """
    {"tabs":[{"branch":"test_br2","tabItems":[],"id":"test_id2","createTS":652883601.96784794,"tabId":"ABHHYWVC","pubName":"test_pub2","name":"test tab2"}],"billId":"QYTA"}
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

    func testUpdateBillCompletionDoesntCompleteIfBadRequest() {
        let expectation = self.expectation(description: "Should execute errorResponse")
        expectation.expectedFulfillmentCount = 1
        
        let billRepository = BillRepository()
        let billJsonData =  "bad json data".data(using: .utf8)
        func completion(bill:Bill) { }
        func errorResponse(error:String) { expectation.fulfill()}
        billRepository.updateBillCompletion(data: billJsonData, response: nil, error: RequestError.badRequest, completion: completion(bill:),errorResponse: errorResponse(error:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUpdateBillCompletionDoesntCompleteIfBadData() {
        let expectation = self.expectation(description: "Should execute errorResponse")
        expectation.expectedFulfillmentCount = 1
        
        let billRepository = BillRepository()
        let billJsonData =  "bad json data".data(using: .utf8)
        func completion(bill:Bill) { }
        func errorResponse(error:String) { expectation.fulfill()}
        billRepository.updateBillCompletion(data: billJsonData, response: nil, error: nil, completion: completion(bill:),errorResponse: errorResponse(error:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUpdateBillCompletionDoesntCompleteIfValidResponseWithValidData() throws {
        let expectation = self.expectation(description: "Should execute completion function")
        expectation.expectedFulfillmentCount = 1
        
        let billRepository = BillRepository()
        let billJsonData =  BillRepositoryTest.bill1JsonString.data(using: .utf8)
        func completion(bill:Bill) { expectation.fulfill(); XCTAssertEqual(bill.billId, "BDLT")}
        func errorResponse(error:String) { }
        billRepository.updateBillCompletion(data: billJsonData, response: nil, error: nil, completion: completion(bill:),errorResponse: errorResponse(error:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCreateBillCompletionDoesntDoesNotCompleteWithBadResponse() throws {
        let expectation = self.expectation(description: "Should execute errorResponse")
        expectation.expectedFulfillmentCount = 1
        
        let billRepository = BillRepository()
        let billJsonData =  BillRepositoryTest.bill1JsonString.data(using: .utf8)
        func completion(bill:Bill) { }
        func errorResponse(error:String) {expectation.fulfill(); }
        billRepository.createCompletion(data: billJsonData, response:nil, error:RequestError.badRequest, completion: completion(bill:), errorResponse: errorResponse(error:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCreateBillCompletionDoesntDoesNotCompleteWithBadData() throws {
        let expectation = self.expectation(description: "Should execute errorResponse")
        expectation.expectedFulfillmentCount = 1
        
        let billRepository = BillRepository()
        let billJsonData =  "bad data".data(using: .utf8)
        func completion(bill:Bill) { }
        func errorResponse(error:String) {expectation.fulfill(); }
        billRepository.createCompletion(data: billJsonData, response:nil, error:nil, completion: completion(bill:), errorResponse: errorResponse(error:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCreateBillCompletionDoesntDoesNotCompleteWithNoDataInResponse() throws {
        let expectation = self.expectation(description: "Should execute errorResponse")
        expectation.expectedFulfillmentCount = 1
        
        let billRepository = BillRepository()
        func completion(bill:Bill) { }
        func errorResponse(error:String) {expectation.fulfill(); }
        billRepository.createCompletion(data: nil, response:nil, error:nil, completion: completion(bill:), errorResponse: errorResponse(error:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCreateBillCompletionDoesntCompleteIfValidResponseWithValidData() throws {
        let expectation = self.expectation(description: "Should execute completion function")
        expectation.expectedFulfillmentCount = 1
        
        let billRepository = BillRepository()
        let billJsonData =  BillRepositoryTest.bill1JsonString.data(using: .utf8)
        func completion(bill:Bill) { expectation.fulfill(); XCTAssertEqual(bill.billId, "BDLT")}
        func errorResponse(error:String) { }
        billRepository.createCompletion(data: billJsonData, response: nil, error: nil, completion: completion(bill:), errorResponse: errorResponse(error:))
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCreateBillBillRepositoryIsAssembledCorrectly() throws {
        var billRepository = BillRepository()
        let mockConnector = MockConnector(data: nil, response: nil, error: nil)
        billRepository.connector = mockConnector
        
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")
        func completion(bill:Bill){}
        func errorResponse(error:String) { }

        billRepository.createOrUpdateBill(tab: tab1, onCompletion: completion(bill:), errorResponse: errorResponse(error:))
        let request = mockConnector.urlRequest
        let urlOfRequest = request.url?.absoluteString.split(separator: "=")[0] //remove query string value

        XCTAssertEqual("https://pubcrawlapi.appspot.com/bill/?tabId", urlOfRequest)
        XCTAssertEqual("POST",request.httpMethod)
        XCTAssertEqual(1,mockConnector.noOfTimesSendRequested)
    }
    
    func testUpdateBillRepositoryIsAssembledCorrectly() throws {
        var billRepository = BillRepository()
        let mockConnector = MockConnector(data: nil, response: nil, error: nil)
        billRepository.connector = mockConnector
        
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")
        let bill1 = Bill(tab:tab1)
        func completion(bill:Bill){}
        func errorResponse(error:String) { }

        billRepository.updateBill(tab: tab1, billId:bill1.billId, onCompletion: completion(bill:), errorResponse: errorResponse(error:))
        let request = mockConnector.urlRequest
        let urlOfRequest = request.url?.absoluteString

        XCTAssertEqual("https://pubcrawlapi.appspot.com/bill/\(bill1.billId)/\(tab1.tabId ?? "")/", urlOfRequest)
        XCTAssertEqual("POST",request.httpMethod)
        XCTAssertEqual(1,mockConnector.noOfTimesSendRequested)
    }

    
    func testCreateOrUpdate() throws {
        let expectation = self.expectation(description: "Should execute completion and return a bill")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        var billRepository = BillRepository()
        let billJsonData =  BillRepositoryTest.bill1JsonString.data(using: .utf8)
        let mockConnector = MockConnector(data: billJsonData, response: nil, error: nil)
        billRepository.connector = mockConnector
        
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")
        
        func completion(bill:Bill) {
            XCTAssertEqual("BDLT", bill.billId)
            expectation.fulfill()
        }
        func errorResponse(error:String) { }
        billRepository.createOrUpdateBill(tab:tab1, onCompletion: completion(bill:), errorResponse: errorResponse(error:))
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUpdate() throws {
        let expectation = self.expectation(description: "Should execute completion and return a bill")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        var billRepository = BillRepository()
        let billJsonData =  BillRepositoryTest.bill1JsonString.data(using: .utf8)
        let mockConnector = MockConnector(data: billJsonData, response: nil, error: nil)
        billRepository.connector = mockConnector
        
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")
        
        func completion(bill:Bill) {
            XCTAssertEqual("BDLT", bill.billId)
            expectation.fulfill()
        }
        func errorResponse(error:String) { }
        billRepository.updateBill(tab:tab1, billId: "BDLT",onCompletion: completion(bill:), errorResponse: errorResponse(error:))
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
