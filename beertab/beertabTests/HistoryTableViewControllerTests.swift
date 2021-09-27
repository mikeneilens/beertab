//
//  HistoryTableViewControllerTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 08/10/2020.
//

import XCTest
@testable import beertab

class HistoryTableViewControllerTests: XCTestCase {
    let date20122019 = Date(timeIntervalSince1970: 1576800000)
    let date21122019 = Date(timeIntervalSince1970: 1576886400)
    
    let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "", branch: "test br", id: "test id")
    let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id")
    let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHistoryReadUpdatesHistory() throws {
        let history = History(allTabs:[tab1,tab2,tab3])
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        viewController.historyRead(newHistory: history)
        
        XCTAssertEqual(tab1, history.allTabs[0])
        XCTAssertEqual(tab2, history.allTabs[1])
        XCTAssertEqual(tab3, history.allTabs[2])
    }

    func testNumberOfSectionsIsOneIfAllTabsHaveSameDate() throws {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "", branch: "test br", id: "test id")
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id")
        let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id")

        history = History(allTabs: [tab1,tab2,tab3])
        XCTAssertEqual(1, viewController.numberOfSections(in: UITableView()) )
    }
    func testNumberOfSectionsIsTwoIfTabsHaveTwoDates() throws {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "", branch: "test br", id: "test id")
        let tab2 = Tab(name: "test tab2", createTS: Date() - 86400, pubName: "test pub", branch: "test br", id: "test id")
        let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id")

        history = History(allTabs: [tab1,tab2,tab3])
        XCTAssertEqual(2, viewController.numberOfSections(in: UITableView()) )
    }

    func testNumberOfRowsInSectionIsOneIfThereIsOnlyOneTabForADate() throws {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")

        history = History(allTabs:[tab1])
        XCTAssertEqual(1, viewController.tableView(UITableView(), numberOfRowsInSection: 0))
    }
    func testNumberOfRowsInSectionIsThreeIfThereIsTwoTabsForADate() throws {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")

        history = History(allTabs:[tab1,tab2])
        XCTAssertEqual(3, viewController.tableView(UITableView(), numberOfRowsInSection: 0))
    }
    
    func testCellForARowIsTabWithOneDescriptionIfTabHasOnlyANameOrOnlyAPub() {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
       
        let bareCell = Tab1TableViewCell()
        let nameLabel = UILabel()
        let dateLabel = UILabel()
        bareCell.name = nameLabel
        bareCell.total = dateLabel
       
        let october_10_2020 = Date(timeIntervalSinceReferenceDate: 624056329.985)
        let october_11_2020 = Date(timeIntervalSinceReferenceDate: 624142723.985)
        
        let tabNoPub = Tab(name: "test tab1", createTS: october_11_2020, pubName: "", branch: "test br", id: "test id")
        let _ = viewController.setupSingleLabelCell(tab: tabNoPub, cell: bareCell)
        XCTAssertEqual(Optional("test tab1"), nameLabel.text)
        XCTAssertEqual(Optional("£0.00"), dateLabel.text)
        
        let tabNoName = Tab(name: "", createTS: october_10_2020, pubName: "test pub", branch: "test br", id: "test id")
        let _ = viewController.setupSingleLabelCell(tab: tabNoName, cell: bareCell)
        XCTAssertEqual(Optional("test pub"), nameLabel.text)
        XCTAssertEqual(Optional("£0.00"), dateLabel.text)
    }
    
    func testCellForARowIsTabWithTwoDescriptionIfTabHasNameAndPubName() {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        
        let bareCell = Tab2TableViewCell()
        let nameLabel = UILabel()
        let pubLabel = UILabel()
        let dateLabel = UILabel()
        bareCell.name = nameLabel
        bareCell.pubName = pubLabel
        bareCell.total = dateLabel
        
        let _ = viewController.setupTwoLabelCell(tab: tab2, cell: bareCell)
        XCTAssertEqual(Optional("test tab2"), nameLabel.text)
        XCTAssertEqual(Optional("test pub"), pubLabel.text)
        XCTAssertEqual(Optional("£0.00"), dateLabel.text)        
    }

    func testPropertiesOfTabItemsTVCAreSetCorrectly() {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")

        let destination = TabItemsTableViewController()
        history = History(allTabs:[tab1,tab2,tab3])
        viewController.setPropertiesOf(destination,indexPath:IndexPath(row: 0, section: 0))
        XCTAssertEqual(history.tabs[0], destination.tab)
    }
    
    func testPropertiesOfTabVCAreSetCorrectly() {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")

        viewController.currentLocation = .Set(location: Location(lng:1,lat:2))
        let destination = TabViewController()
        viewController.setPropertiesOf(destination,indexPath:IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(LocationStatus.Set(location: Location(lng: 1, lat: 2)) , destination.locationStatus)
    }
    
    func testDeleteTab() {
        let viewController = HistoryTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        
        history = History(allTabs:[tab1,tab2,tab3])
        viewController.deleteTab(tab: tab2)
        
        XCTAssertEqual(2, history.allTabs.count)
        XCTAssertEqual(tab1, history.allTabs[0])
        XCTAssertEqual(tab3, history.allTabs[1])

        func checkHistoryIsArchived(history:History) { XCTAssertEqual(2,history.allTabs.count) }
        func errorResponse(message:String) { XCTAssertTrue(false)}
        HistoryRepository(key:"test").read(historyResponse: checkHistoryIsArchived, errorResponse: errorResponse(message:) )
    }
    
    func testWhetherInstructionsShouldBePresented() {
        let viewController = HistoryTableViewController()
        UserDefaults.standard.removeObject(forKey: "HistoryHelp")
        XCTAssertTrue(viewController.instructionsShouldBePresented())
        
        UserDefaults.standard.set("No", forKey: "HistoryHelp")
        XCTAssertFalse(viewController.instructionsShouldBePresented())
    }
    
    func testDisablingInstructions() {
        let viewController = HistoryTableViewController()
        UserDefaults.standard.removeObject(forKey: "HistoryHelp")
        viewController.disableInstructions(UIAlertAction())
        let historyHelpDisabled:Any? = UserDefaults.standard.object(forKey: "HistoryHelp")
        XCTAssertNotNil(historyHelpDisabled)
        
        UserDefaults.standard.removeObject(forKey: "HistoryHelp")
    }
    
    func testCreatingDeleteTabAlert() {
        let viewController = HistoryTableViewController()
        let tab = Tab(name: "test tab1", createTS: date20122019, pubName: "", branch: "test br", id: "test id")
        let alertController = viewController.deleteTabAlert(for: tab)
        XCTAssertEqual(2, alertController.actions.count)
        XCTAssertEqual("Do you want to delete test tab1  (20 Dec 2019)", alertController.message)
        XCTAssertEqual("Yes", alertController.actions[0].title)
        XCTAssertEqual("No", alertController.actions[1].title)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
