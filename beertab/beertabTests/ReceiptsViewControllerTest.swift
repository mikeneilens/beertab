
import Foundation
//
//  TabViewControllerTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 09/10/2020.
//

import XCTest
@testable import beertab

class ReceiptsViewControllerTests: XCTestCase {
    
    let billIdText = UITextField()
    var receiptTextView = UITextView()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testProcessBill() {
        let viewController = ReceiptViewController()
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")
        
        let bill = Bill(tab:tab1)
        viewController.billIdText = billIdText
        viewController.receiptTextView = receiptTextView
        viewController.processBill(bill: bill)
        XCTAssertEqual(receiptTextView.text, bill.report(history: history))
    }
    
    func testTextFieldShouldReturnGivesFalseIfBilIDLengthLessThan4() {
        let viewController = ReceiptViewController()
        viewController.billIdText = billIdText
        viewController.billIdText.text = "ABC"
        XCTAssertFalse(viewController.textFieldShouldReturn(viewController.billIdText))
    }
    
    func testTextFieldShouldReturnGivesTrueIfBilIDLength4orMore() {
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")

        struct MockBillRepository:BillArchiver {
            let testTab:Tab
            func createOrUpdateBill(tab: Tab, onCompletion completion: @escaping (Bill) -> (), errorResponse: Optional<(String) -> ()>) {
                XCTAssertFalse(true)
            }
            
            func updateBill(tab: Tab, billId: String, onCompletion completion: @escaping (Bill) -> (), errorResponse: Optional<(String) -> ()>) {
                XCTAssertEqual(tab,testTab)
                XCTAssertEqual(billId, "ABCD")
            }
        }
        
        let viewController = ReceiptViewController()
        viewController.tab = tab1
        viewController.billRepository = MockBillRepository(testTab:tab1)
        viewController.billIdText = billIdText
        viewController.billIdText.text = "ABCD"
        XCTAssertTrue(viewController.textFieldShouldReturn(viewController.billIdText))
    }
    
    func testViewDidLoadSetsUpTheReceipt() {
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")

        struct MockBillRepository:BillArchiver {
            let testTab:Tab
            
            func createOrUpdateBill(tab: Tab, onCompletion completion: @escaping (Bill) -> (), errorResponse: Optional<(String) -> ()>) {
                XCTAssertEqual(tab,testTab)
                completion(Bill(tab: testTab))
            }
            
            func updateBill(tab: Tab, billId: String, onCompletion completion: @escaping (Bill) -> (), errorResponse: Optional<(String) -> ()>) {
                XCTAssertFalse(true)
                XCTAssertEqual(tab,testTab)
            }
        }
        
        let viewController = ReceiptViewController()
        viewController.tab = tab1
        viewController.billRepository = MockBillRepository(testTab:tab1)
        viewController.billIdText = billIdText
        viewController.receiptTextView = receiptTextView
        viewController.billIdText.text = "ABCD"
        viewController.viewDidLoad()
        XCTAssertEqual(receiptTextView.text, Bill(tab:tab1).report(history: history))
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
