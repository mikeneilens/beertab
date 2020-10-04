//
//  beertabTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 04/10/2020.
//

import XCTest
@testable import beertab

class beertabTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTwoTabsWithSameBrewNameAndSizeAreEqual() {
        let newTabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTabItem2 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 450)
        XCTAssertTrue(newTabItem1 == newTabItem2)
        XCTAssertFalse(newTabItem1 != newTabItem2)
    }
    
    func testTwoTabsWithDifferentBrewerAreNotEqual() {
        let newTabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTabItem2 = TabItem(brewer: "brewer2", name: "name1", size: "pint", price: 440)
        XCTAssertTrue(newTabItem1 != newTabItem2)
        XCTAssertFalse(newTabItem1 == newTabItem2)
    }
    
    func testTwoTabsWithDifferentNameAreNotEqual() {
        let newTabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTabItem2 = TabItem(brewer: "brewer1", name: "name2", size: "pint", price: 440)
        XCTAssertTrue(newTabItem1 != newTabItem2)
        XCTAssertFalse(newTabItem1 == newTabItem2)
    }
    func testTwoTabsWithDifferentSizeAreNotEqual() {
        let newTabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTabItem2 = TabItem(brewer: "brewer1", name: "name1", size: "half", price: 440)
        XCTAssertTrue(newTabItem1 != newTabItem2)
        XCTAssertFalse(newTabItem1 == newTabItem2)
    }
    
    func testAddTabItemToEmptyTab() {
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", postcode: "test postcode", tabItems: [])
        let newTabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTab = tab.add(tabItem: newTabItem)
        XCTAssertEqual(1,newTab.tabItems.count)
    }
    func testAddTabItemToTabContainingOneItem() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", postcode: "test postcode", tabItems: [tabItem])
        let newTabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTab = tab.add(tabItem: newTabItem)
        XCTAssertEqual(2,newTab.tabItems.count)
    }
    func testRemoveTabItemFromTabContainingTwoItems() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer2", name: "name1", size: "pint", price: 440)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", postcode: "test postcode", tabItems: [tabItem1, tabItem2])
        let newTab = tab.remove(tabItem: tabItem1)
        XCTAssertEqual(1,newTab.tabItems.count)
        XCTAssertTrue(newTab.tabItems[0] == tabItem2)
    }
    func testAddFirstTransactionToEmptyTabItem() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let updatedTabItem = tabItem.addTransaction()
        
        XCTAssertEqual(1, updatedTabItem.transactions.count)
        XCTAssertTrue(updatedTabItem.transactions[0].transactionType == .add)
    }
    func testAddTransactionToTabItemContainingATransaction() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let updatedTabItem = tabItem.addTransaction().addTransaction()
        XCTAssertEqual(2, updatedTabItem.transactions.count)
        XCTAssertTrue(updatedTabItem.transactions[1].transactionType == .add)
    }
    func testQuantityOfTransactionsForATabItemWithNoTransactions() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        XCTAssertEqual(0, tabItem.quantity)
    }
    func testQuantityOfTransactionsForATabItemWithOnePositiveTransactions() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440).addTransaction()
        XCTAssertEqual(1, tabItem.quantity)
    }
    func testQuantityOfTransactionsForATabItemWithTwoPositiveTransactions() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440).addTransaction().addTransaction()
        XCTAssertEqual(2, tabItem.quantity)
    }
    func testQuantityOfTransactionsForATabItemWithTwoPositiveTransactionsAndOneNegative() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440).addTransaction().addTransaction().removeTransaction()
        XCTAssertEqual(1, tabItem.quantity)
    }

    func testRemoveTransactionToTabItemContainingTwoTransaction() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let updatedTabItem = tabItem.addTransaction().addTransaction().removeTransaction()
        XCTAssertEqual(3, updatedTabItem.transactions.count)
        XCTAssertTrue(updatedTabItem.transactions[2].transactionType == .remove)
    }
    
    func testAddingATransactionForABeerToTheTab() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer1", name: "name2", size: "pint", price: 430)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", postcode: "test postcode", tabItems: [tabItem1, tabItem2])
        
        let newTab = tab.addTransaction(brewer: "brewer1", name: "name2", size: "pint")
        XCTAssertEqual(1, newTab.tabItems[1].quantity)
    }
    func testAddingSeveralTransactionsForABeerToTheTab() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer1", name: "name2", size: "pint", price: 430)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", postcode: "test postcode", tabItems: [tabItem1, tabItem2])
        
        let newTab = tab.addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
        
        XCTAssertEqual(0, newTab.tabItems[0].quantity)
        XCTAssertEqual(3, newTab.tabItems[1].quantity)
    }
    func testAddingAndRemovingSeveralTransactionsForABeerToTheTab() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer1", name: "name2", size: "pint", price: 430)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", postcode: "test postcode", tabItems: [tabItem1, tabItem2])
        
        let newTab = tab.addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .removeTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
        
        XCTAssertEqual(0, newTab.tabItems[0].quantity)
        XCTAssertEqual(2, newTab.tabItems[1].quantity)
    }
    func testHistoryReturnsTabsInDescendingDateOrder() {
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", postcode: "test postcode", tabItems: [])
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", postcode: "test postcode", tabItems: [])
        let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "test pub", postcode: "test postcode", tabItems: [])
        
        let history = History(allTabs:[tab1,tab2,tab3])
        
        let firstName = history.tabs[0].name
        let secondName = history.tabs[1].name
        let thirdName = history.tabs[2].name
        
        XCTAssertEqual(tab3.name, firstName)
        XCTAssertEqual(tab1.name, secondName)
        XCTAssertEqual(tab2.name, thirdName)
    }
    func testAddingATabToAnEmptyHistory() {
        let history = History(allTabs: [])
        let newTab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", postcode: "", tabItems: [])
        let newHistory = history.add(tab: newTab)
        
        XCTAssertEqual(1, newHistory.tabs.count)
        XCTAssertEqual("tab1", newHistory.tabs[0].name)
    }
    func testAddingATabToAHistoryContainingTabs() {
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", postcode: "test postcode", tabItems: [])
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", postcode: "test postcode", tabItems: [])
        
        let history = History(allTabs:[tab1,tab2])

        let newTab = Tab(name: "test tab3", createTS: Date(), pubName: "pub1", postcode: "", tabItems: [])
        let newHistory = history.add(tab: newTab)
        
        XCTAssertEqual(3, newHistory.tabs.count)
        XCTAssertEqual("test tab3", newHistory.tabs[0].name)
        XCTAssertEqual("test tab3", newHistory.allTabs[2].name)
    }
    func testupdatingATabInAHistoryContainingTabs() {
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", postcode: "test postcode", tabItems: [])
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", postcode: "test postcode", tabItems: [])
        let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "pub1", postcode: "", tabItems: [])
        let history = History(allTabs:[tab1,tab2,tab3])

        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let updatedTab2 = Tab(name: "new name", createTS: tab2.createTS, pubName: "new pub", postcode: "new postcode", tabItems: [tabItem])
        
        let newHistory = history.update(tab: updatedTab2)
        
        XCTAssertEqual(3, newHistory.tabs.count)
        XCTAssertEqual("new name", newHistory.allTabs[1].name)
        XCTAssertEqual("new pub", newHistory.allTabs[1].pubName)
        XCTAssertEqual("new postcode", newHistory.allTabs[1].postcode)
        XCTAssertEqual(1, newHistory.allTabs[1].tabItems.count)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
