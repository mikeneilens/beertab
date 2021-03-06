//
//  TabItemsUpdateViewControllerTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 09/10/2020.
//

import XCTest
@testable import beertab
class TabItemsUpdateViewControllerTests: XCTestCase {

    let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
    
    let brandTextField = UITextField()
    let nameTextField = UITextField()
    let priceTextField = UITextField()

    class MockUpdater:TabUpdater {
        var listOfAddedTabItems:Array<TabItem> = []
        var listOfBoughtTabItems:Array<TabItem> = []
        var listOfReturnedTabItems:Array<TabItem> = []
        var listOfDeletedTabItems:Array<TabItem> = []
        var listOfReplacedTabItems:Array<TabItem> = []
        
        func addTabItems(tabItems: [TabItem]) {
            listOfAddedTabItems += tabItems
        }
        func buyTabItem(tabItem: TabItem) {
            listOfBoughtTabItems.append(tabItem)
        }
        func returnTabItem(tabItem: TabItem) {
            listOfReturnedTabItems.append(tabItem)
        }
        func deleteTabItem(tabItem: TabItem) {
            listOfDeletedTabItems.append(tabItem)
        }
        func replaceTabItem(position:Int, newTabItem: TabItem) {
            listOfReplacedTabItems.append(newTabItem)
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func setUp(viewController:TabItemUpdateViewController) {
        viewController.brandTextField = brandTextField
        viewController.nameTextField = nameTextField
        viewController.priceTextField = priceTextField
    }
    
    func testBuyTabItem() throws {
        let viewController = TabItemUpdateViewController()
        setUp(viewController: viewController)
        viewController.tabItem = tabItem1
        
        let mockUpdater = MockUpdater()
        
        var completions = 0
        let completer = {completions += 1}
        viewController.buyTabItem(tabUpdater:mockUpdater, completer)
        
        XCTAssertEqual(1, mockUpdater.listOfBoughtTabItems.count)
        XCTAssertEqual(1, completions)
        XCTAssertEqual(tabItem1.brewer, mockUpdater.listOfBoughtTabItems[0].brewer)
        XCTAssertEqual(tabItem1.name, mockUpdater.listOfBoughtTabItems[0].name)
        XCTAssertEqual(tabItem1.size, mockUpdater.listOfBoughtTabItems[0].size)
        XCTAssertEqual(tabItem1.price, mockUpdater.listOfBoughtTabItems[0].price)
    }

    func testReturnTabItem() throws {
        let viewController = TabItemUpdateViewController()
        viewController.tabItem = tabItem1
        
        let mockUpdater = MockUpdater()
        
        var completions = 0
        let completer = {completions += 1}
        viewController.returnTabItem(tabUpdater:mockUpdater, completer)
        
        XCTAssertEqual(1, mockUpdater.listOfReturnedTabItems.count)
        XCTAssertEqual(1, completions)
        XCTAssertEqual(tabItem1.brewer, mockUpdater.listOfReturnedTabItems[0].brewer)
        XCTAssertEqual(tabItem1.name, mockUpdater.listOfReturnedTabItems[0].name)
        XCTAssertEqual(tabItem1.size, mockUpdater.listOfReturnedTabItems[0].size)
        XCTAssertEqual(tabItem1.price, mockUpdater.listOfReturnedTabItems[0].price)
    }
    
    func testGetDeleteButtonState() {
        let viewController = TabItemUpdateViewController()
        viewController.tabItem = tabItem1
        
        XCTAssertFalse( viewController.shouldDeleteButtonBeEnabled() )
        
        viewController.tabItem = tabItem1.addTransaction()
        
        XCTAssertTrue( viewController.shouldDeleteButtonBeEnabled() )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
