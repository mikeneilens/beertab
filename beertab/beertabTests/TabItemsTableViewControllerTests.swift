//
//  TabItemsTableViewControllerTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 09/10/2020.
//

import XCTest
@testable import beertab

class TabItemsTableViewControllerTests: XCTestCase {

    let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
    let tabItem2 = TabItem(brewer: "brewer1", name: "name2", size: "half", price: 430)
    let tabItem3 = TabItem(brewer: "brewer3", name: "name3", size: "third", price: 330)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoOfSectionsIsOneWhenThereAreNoTabItems() throws {
        let viewController = TabItemsTableViewController()
        viewController.tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "")
        XCTAssertEqual(1, viewController.numberOfSections(in:UITableView()) )
    }
    func testNoOfSectionsIsOneWhenThereAreMoreThanAoneTabItems() throws {
        let viewController = TabItemsTableViewController()
        viewController.tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        XCTAssertEqual(2, viewController.numberOfSections(in:UITableView()) )
    }
    func testNoOfRowsInSection() throws {
        let tabWithNoItems   = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "")
        let tabWithSomeItems = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        
        let testData = [ (tab:tabWithNoItems,   section:0, expectedResult:0),
                         (tab:tabWithSomeItems, section:0, expectedResult:2),
                         (tab:tabWithSomeItems, section:1, expectedResult:1),
        ]
        let viewController = TabItemsTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        
        testData.forEach{ (tab, section, expectedResult) in
            viewController.tab = tab
            XCTAssertEqual(expectedResult, viewController.tableView(UITableView(), numberOfRowsInSection: section) )
        }
    }
    func testConfiguringTabItemCell() throws {
        let viewController = TabItemsTableViewController()
        let tabWithSomeItems = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        viewController.tab = tabWithSomeItems
                                .addTransaction(brewer: "brewer1", name: "name1", size: "pint")
                                .addTransaction(brewer: "brewer1", name: "name2", size: "half")
                                .addTransaction(brewer: "brewer1", name: "name1", size: "pint")
        
        let cell = TabItemTableViewCell()
        let brewerLabel = UILabel()
        let nameLabel = UILabel()
        let sizeLabel = UILabel()
        let qtyLabel = UILabel()
        cell.brewer = brewerLabel
        cell.name = nameLabel
        cell.size = sizeLabel
        cell.quantity = qtyLabel

        viewController.configureTabItemCell(cell,IndexPath(row: 0, section: 0))
        XCTAssertEqual("brewer1", cell.brewer.text)
        XCTAssertEqual("name1", cell.name.text)
        XCTAssertEqual("pint £4.40", cell.size.text)
        XCTAssertEqual("2", cell.quantity.text)
        
        let summaryCell = TabTotalTableViewCell()
        let totalValueLabel = UILabel()
        summaryCell.totalValue = totalValueLabel
        viewController.configureSummaryCell(summaryCell)
        XCTAssertEqual("£13.10", summaryCell.totalValue.text)
    }
    
    func testHeadingForSection() throws {
        let viewController = TabItemsTableViewController()
        XCTAssertEqual("You have no items on your tab", viewController.tableView(UITableView(), titleForHeaderInSection: 0))
        XCTAssertEqual("Your Total Bill", viewController.tableView(UITableView(), titleForHeaderInSection: 1))
        
        viewController.tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        XCTAssertEqual("Items", viewController.tableView(UITableView(), titleForHeaderInSection: 0))
    }

    func testPreparingWhenDestinationIsAddTabItem() throws {
        let viewController = TabItemsTableViewController()
        let destination = TabItemAddViewController()
        viewController.prepare(destination)
        
        XCTAssertTrue(destination.tabUpdater != nil)
    }
    func testPreparingWhenDestinationIsUpdateTabItem() throws {
        let viewController = TabItemsTableViewController()
        viewController.tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        
        let destination = TabItemUpdateViewController()
        let brewerTextField = UITextField()
        let nameText = UITextField()
        let sizeText = UITextField()
        destination.brandTextField = brewerTextField
        destination.nameTextField = nameText
        destination.sizeTextField = sizeText
        
        viewController.prepare(destination,row: 1)
        
        XCTAssertTrue(destination.tabUpdater != nil)
        XCTAssertEqual("brewer1", destination.tabItem.brewer)
        XCTAssertEqual("name2", destination.tabItem.name)
        XCTAssertEqual("half", destination.tabItem.size)
    }
    
    func testAddingAnItem() throws {
        let viewController = TabItemsTableViewController()
        viewController.historyRepository =  HistoryRepository(key:"test")
        let tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        viewController.tab = tab
        history = History(allTabs: [tab])
        
        let newTabItem = TabItem(brewer: "brewer3", name: "name3", size: "other", price: 100)
        viewController.addTabItems(tabItems: [newTabItem])
        
        XCTAssertEqual("brewer3", viewController.tab.tabItems.last?.brewer )
        XCTAssertEqual("name3", viewController.tab.tabItems.last?.name )
        XCTAssertEqual("other", viewController.tab.tabItems.last?.size )
        XCTAssertEqual(100, viewController.tab.tabItems.last?.price )
        
        XCTAssertEqual("brewer3", history.allTabs[0].tabItems.last?.brewer )
        XCTAssertEqual("name3", history.allTabs[0].tabItems.last?.name )
        XCTAssertEqual("other", history.allTabs[0].tabItems.last?.size )
        XCTAssertEqual(100, history.allTabs[0].tabItems.last?.price )
    }
    func testDeletinggAnItem() throws {
        let viewController = TabItemsTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        let tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2,tabItem3])
        viewController.tab = tab
        history = History(allTabs: [tab])
        
        viewController.deleteTabItem(tabItem: tabItem2)
        
        XCTAssertEqual("brewer1", viewController.tab.tabItems[0].brewer )
        XCTAssertEqual("name1", viewController.tab.tabItems[0].name )
        XCTAssertEqual("pint", viewController.tab.tabItems[0].size )
        XCTAssertEqual(440, viewController.tab.tabItems[0].price )
        
        XCTAssertEqual("brewer3", viewController.tab.tabItems[1].brewer )
        XCTAssertEqual("name3", viewController.tab.tabItems[1].name )
        XCTAssertEqual("third", viewController.tab.tabItems[1].size )
        XCTAssertEqual(330, viewController.tab.tabItems[1].price )
        
        XCTAssertEqual("brewer3", history.allTabs[0].tabItems[1].brewer )
        XCTAssertEqual("name3", history.allTabs[0].tabItems[1].name )
        XCTAssertEqual("third", history.allTabs[0].tabItems[1].size )
        XCTAssertEqual(330, history.allTabs[0].tabItems[1].price )
    }
    
    func testBuyingAnItem() throws {
        let viewController = TabItemsTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        let tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        viewController.tab = tab
        history = History(allTabs: [tab])
        
        viewController.buyTabItem(tabItem: tabItem1)
        
        XCTAssertEqual(1, viewController.tab.tabItems[0].quantity )
        XCTAssertEqual(1, history.allTabs[0].tabItems[0].quantity )
        
        viewController.buyTabItem(tabItem: tabItem2)
        viewController.buyTabItem(tabItem: tabItem2)

        XCTAssertEqual(1, viewController.tab.tabItems[0].quantity )
        XCTAssertEqual(1, history.allTabs[0].tabItems[0].quantity )
        XCTAssertEqual(2, viewController.tab.tabItems[1].quantity )
        XCTAssertEqual(2, history.allTabs[0].tabItems[1].quantity )
    }
    func testReturningAnItem() throws {
        let viewController = TabItemsTableViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
        let tab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        viewController.tab = tab
        history = History(allTabs: [tab])
        
        viewController.buyTabItem(tabItem: tabItem2)
        viewController.buyTabItem(tabItem: tabItem2)
        viewController.returnTabItem(tabItem: tabItem2)

        XCTAssertEqual(1, viewController.tab.tabItems[1].quantity )
        XCTAssertEqual(1, history.allTabs[0].tabItems[1].quantity )
    }
    
    func testWhetherInstructionsShouldBePresented() {
        let viewController = TabItemsTableViewController()
        UserDefaults.standard.removeObject(forKey: "TabItemHelp")
        XCTAssertTrue(viewController.instructionsShouldBePresented())
        
        UserDefaults.standard.set("No", forKey: "TabItemHelp")
        XCTAssertFalse(viewController.instructionsShouldBePresented())
    }
    
    func testDisablingInstructions() {
        let viewController = TabItemsTableViewController()
        UserDefaults.standard.removeObject(forKey: "TabItemHelp")
        
        viewController.disableInstructions(UIAlertAction())
        let historyHelpDisabled:Any? = UserDefaults.standard.object(forKey: "TabItemHelp")
        XCTAssertNotNil(historyHelpDisabled)
        UserDefaults.standard.removeObject(forKey: "TabItemHelp")
    }
    
    func testSettingNavigationTitle() {
        let viewController = TabItemsTableViewController()
        let tabWithPubName = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        XCTAssertEqual("pub1", viewController.navigationTitle(for:tabWithPubName) )
        let tabWithNoPubName = Tab(name: "tab1", createTS: Date(), pubName: "", branch: "", id: "").replaceItemsWith([tabItem1,tabItem2])
        XCTAssertEqual("tab1", viewController.navigationTitle(for:tabWithNoPubName) )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
