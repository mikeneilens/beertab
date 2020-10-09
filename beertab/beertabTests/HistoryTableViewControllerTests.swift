//
//  HistoryTableViewControllerTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 08/10/2020.
//

import XCTest
@testable import beertab

class HistoryTableViewControllerTests: XCTestCase {
    let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "", branch: "test br", id: "test id", tabItems: [])
    let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
    let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHistoryReadUpdatesHistory() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let history = History(allTabs:[tab1,tab2,tab3])
        let viewController = HistoryTableViewController()
        viewController.historyRead(newHistory: history)
        
        XCTAssertEqual(tab1, history.allTabs[0])
        XCTAssertEqual(tab2, history.allTabs[1])
        XCTAssertEqual(tab3, history.allTabs[2])
    }

    func testNumberOfSectionsIsOne() throws {
        let viewController = HistoryTableViewController()
        XCTAssertEqual(1, viewController.numberOfSections(in: UITableView()) )
    }
    
    func testNumberOfRowsInFirstSectionIsSameAsNoOfTabsInHistory() throws {
        let viewController = HistoryTableViewController()
        history = History(allTabs:[tab1,tab2,tab3])
        XCTAssertEqual(3, viewController.tableView(UITableView(), numberOfRowsInSection: 0))
    }
    
    func testCellForARowIsTabWithOneDescriptionIfTabHasOnlyANameOrOnlyAPub() {
        let viewController = HistoryTableViewController()
       
        let bareCell = Tab1TableViewCell()
        let nameLabel = UILabel()
        let dateLabel = UILabel()
        bareCell.name = nameLabel
        bareCell.date = dateLabel
        
        let tabNoPub = Tab(name: "test tab1", createTS: Date() - 1, pubName: "", branch: "test br", id: "test id", tabItems: [])
        let _ = viewController.setupSingleLabelCell(tab: tabNoPub, cell: bareCell)
        XCTAssertEqual(Optional("test tab1"), nameLabel.text)
        XCTAssertEqual(Optional(tabNoPub.dateString), dateLabel.text)
        
        let tabNoName = Tab(name: "", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let _ = viewController.setupSingleLabelCell(tab: tabNoName, cell: bareCell)
        XCTAssertEqual(Optional("test pub"), nameLabel.text)
        XCTAssertEqual(Optional(tabNoName.dateString), dateLabel.text)
    }
    
    func testCellForARowIsTabWithTwoDescriptionIfTabHasNameAndPubName() {
        let viewController = HistoryTableViewController()
        
        let bareCell = Tab2TableViewCell()
        let nameLabel = UILabel()
        let pubLabel = UILabel()
        let dateLabel = UILabel()
        bareCell.name = nameLabel
        bareCell.pubName = pubLabel
        bareCell.date = dateLabel
        
        let _ = viewController.setupTwoLabelCell(tab: tab2, cell: bareCell)
        XCTAssertEqual(Optional("test tab2"), nameLabel.text)
        XCTAssertEqual(Optional("test pub"), pubLabel.text)
        XCTAssertEqual(Optional(tab2.dateString), dateLabel.text)        
    }

    func testPropertiesOfTabItemsTVCAreSetCorrectly() {
        let viewController = HistoryTableViewController()
        let destination = TabItemsTableViewController()
        history = History(allTabs:[tab1,tab2,tab3])
        viewController.setPropertiesOf(destination,row:0)
        
        XCTAssertEqual(history.tabs[0], destination.tab)
    }
    
    func testDeleteTab() {
        let viewController = HistoryTableViewController()
        history = History(allTabs:[tab1,tab2,tab3])
        archiveKey = "test"
        viewController.deleteTab(tab: tab2)
        
        XCTAssertEqual(2, history.allTabs.count)
        XCTAssertEqual(tab1, history.allTabs[0])
        XCTAssertEqual(tab3, history.allTabs[1])

        func checkHistoryIsArchived(history:History) { XCTAssertEqual(2,history.allTabs.count) }
        func errorResponse(message:String) { XCTAssertTrue(false)}
        HistoryArchive(key:archiveKey).read(historyResponse: checkHistoryIsArchived, errorResponse: errorResponse(message:) )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
