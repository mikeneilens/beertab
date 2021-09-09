
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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetBillWhenABillDoesNotExists() throws {
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")
        let tab2 = Tab(name: "test tab2", createTS: Date(), pubName: "test_pub2", branch: "test_br2", id: "test_id2")
        let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "test_pub3", branch: "test_br3", id: "test_id3")
        let tab4 = Tab(name: "test tab4", createTS: Date(), pubName: "test_pub4", branch: "test_br4", id: "test_id4")

        
        let bill1 = Bill(tab:tab1)
        let bill2 = Bill(tab:tab2)
        let bill3 = Bill(tab:tab3)
        
        bills = [bill1,bill2,bill3]
        
        let viewController = ReceiptViewController()
        viewController.tab = tab4
        let newBill = viewController.getBill()
        
        XCTAssertEqual(bills.last?.billId.count, 4)
        XCTAssertEqual(bills.last, newBill)
        XCTAssertEqual(bills.last?.tabs[0], tab4)
    }
    
    func testGetBillWhenABillExists() throws {
        let tab1 = Tab(name: "test tab1", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id")
        let tab2 = Tab(name: "test tab2", createTS: Date(), pubName: "test_pub2", branch: "test_br2", id: "test_id2")
        let tab3 = Tab(name: "test tab2", createTS: Date(), pubName: "test_pub3", branch: "test_br3", id: "test_id3")
        
        let bill1 = Bill(tab:tab1)
        let bill2 = Bill(tab:tab2)
        let bill3 = Bill(tab:tab3)
        
        bills = [bill1,bill2,bill3]
        
        let viewController = ReceiptViewController()
        viewController.tab = tab2
        
        XCTAssertEqual(viewController.getBill(), bill2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
