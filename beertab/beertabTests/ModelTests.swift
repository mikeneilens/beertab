//
//  beertabTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 04/10/2020.
//

import XCTest
@testable import beertab

class ModelTests: XCTestCase {

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
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let newTabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTab = tab.add(tabItem: newTabItem)
        XCTAssertEqual(1,newTab.tabItems.count)
    }
    func testAddTabItemToTabContainingOneItem() {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [tabItem])
        let newTabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let newTab = tab.add(tabItem: newTabItem)
        XCTAssertEqual(2,newTab.tabItems.count)
    }
    func testRemoveTabItemFromTabContainingTwoItems() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer2", name: "name1", size: "pint", price: 440)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [tabItem1, tabItem2])
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
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [tabItem1, tabItem2])
        
        let newTab = tab.addTransaction(brewer: "brewer1", name: "name2", size: "pint")
        XCTAssertEqual(1, newTab.tabItems[1].quantity)
    }
    func testAddingSeveralTransactionsForABeerToTheTab() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer1", name: "name2", size: "pint", price: 430)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [tabItem1, tabItem2])
        
        let newTab = tab.addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
        
        XCTAssertEqual(0, newTab.tabItems[0].quantity)
        XCTAssertEqual(3, newTab.tabItems[1].quantity)
    }
    func testAddingAndRemovingSeveralTransactionsForABeerToTheTab() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer1", name: "name2", size: "pint", price: 430)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [tabItem1, tabItem2])
        
        let newTab = tab.addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .removeTransaction(brewer: "brewer1", name: "name2", size: "pint")
                        .addTransaction(brewer: "brewer1", name: "name2", size: "pint")
        
        XCTAssertEqual(0, newTab.tabItems[0].quantity)
        XCTAssertEqual(2, newTab.tabItems[1].quantity)
    }
    func testHistoryReturnsTabsInDescendingDateOrder() {
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        
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
        let newTab = Tab(name: "tab1", createTS: Date(), pubName: "pub1", branch: "test br", id: "test id", tabItems: [])
        let newHistory = history.add(tab: newTab)
        
        XCTAssertEqual(1, newHistory.tabs.count)
        XCTAssertEqual("tab1", newHistory.tabs[0].name)
    }
    func testAddingATabToAHistoryContainingTabs() {
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        
        let history = History(allTabs:[tab1,tab2])

        let newTab = Tab(name: "test tab3", createTS: Date(), pubName: "pub1", branch: "test br", id: "test id", tabItems: [])
        let newHistory = history.add(tab: newTab)
        
        XCTAssertEqual(3, newHistory.tabs.count)
        XCTAssertEqual("test tab3", newHistory.tabs[0].name)
        XCTAssertEqual("test tab3", newHistory.allTabs[2].name)
    }
    func testRemovingATabFromAHistoryContainingTabs() {
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab3 = Tab(name: "test tab3", createTS: Date() - 3, pubName: "pub1", branch: "test br", id: "test id", tabItems: [])
        
        let history = History(allTabs:[tab1,tab2, tab3])

        let newHistory = history.remove(tab: tab2)
        
        XCTAssertEqual(2, newHistory.tabs.count)
        XCTAssertEqual("test tab1", newHistory.allTabs[0].name)
        XCTAssertEqual("test tab3", newHistory.allTabs[1].name)
    }
    func testRemovingATabFromAHistoryContainingTabsWithSameNameAndPub() {
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab2 = Tab(name: "test tab1", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab3 = Tab(name: "test tab3", createTS: Date() - 3, pubName: "pub1", branch: "test br", id: "test id", tabItems: [])
        
        let history = History(allTabs:[tab1,tab2, tab3])

        let newHistory = history.remove(tab: tab1)
        
        XCTAssertEqual(2, newHistory.tabs.count)
        XCTAssertEqual("test tab1", newHistory.allTabs[0].name)
        XCTAssertEqual(tab2.createTS, newHistory.allTabs[0].createTS)
        XCTAssertEqual("test tab3", newHistory.allTabs[1].name)
    }
    func testupdatingATabInAHistoryContainingTabs() {
        
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab2 = Tab(name: "test tab2", createTS: Date() - 2, pubName: "test pub", branch: "test br", id: "test id", tabItems: [])
        let tab3 = Tab(name: "test tab3", createTS: Date(), pubName: "pub1", branch: "test br", id: "test id", tabItems: [])
        let history = History(allTabs:[tab1,tab2,tab3])

        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let updatedTab2 = Tab(name: "new name", createTS: tab2.createTS, pubName: "new pub", branch: "new br", id: "new id", tabItems: [tabItem])
        
        let newHistory = history.update(tab: updatedTab2)
        
        XCTAssertEqual(3, newHistory.tabs.count)
        XCTAssertEqual("new name", newHistory.allTabs[1].name)
        XCTAssertEqual("new pub", newHistory.allTabs[1].pubName)
        XCTAssertEqual("new br", newHistory.allTabs[1].branch)
        XCTAssertEqual("new id", newHistory.allTabs[1].id)
        XCTAssertEqual(1, newHistory.allTabs[1].tabItems.count)
    }
    func testTotalValue() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440).addTransaction()
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "half", price: 240).removeTransaction()
       
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test_pub", branch: "test_br", id: "test_id", tabItems: [tabItem1, tabItem2])
        
        XCTAssertEqual("£2.00", tab1.totalValue)
    }
    
    func testCreatingAReceiptItemWithAnAddTransaction() throws {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let transaction = Transaction(transactionType: .add)
        let receiptItem = ReceiptItem(tabItem, transaction)
        XCTAssertEqual("name1",receiptItem.name)
        XCTAssertEqual("brewer1",receiptItem.brewer)
        XCTAssertEqual("pint",receiptItem.size)
        XCTAssertEqual("4.40",receiptItem.price)
        XCTAssertEqual("+",receiptItem.sign)
        XCTAssertEqual(transaction.createTS,receiptItem.createTS)
    }
    func testCreatingAReceiptItemWithARemoveTransaction() throws {
        let tabItem = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let transaction = Transaction(transactionType: .remove)
        let receiptItem = ReceiptItem(tabItem, transaction)
        XCTAssertEqual("name1",receiptItem.name)
        XCTAssertEqual("brewer1",receiptItem.brewer)
        XCTAssertEqual("pint",receiptItem.size)
        XCTAssertEqual("4.40",receiptItem.price)
        XCTAssertEqual("-",receiptItem.sign)
        XCTAssertEqual(transaction.createTS,receiptItem.createTS)
    }
    func testDecriptionOfAReceiptItem() throws {
        let date = Date()
        let receiptItem = ReceiptItem("brewer", "beer name", "pint", "5.50", date, "+")
        let descriptionWithoutTime = receiptItem.description.split(separator: " ").dropFirst().joined(separator: " ")
        let descriptionTime = String(receiptItem.description.split(separator: " ").first ?? "")
        XCTAssertEqual("brewer beer name pint +£5.50",  descriptionWithoutTime)
        XCTAssertEqual(date.asTimeString,  descriptionTime)
    }
    
    func testTransactionReport() throws {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440).addTransaction()
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "half", price: 240).removeTransaction()
       
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test_pub", branch: "test_br", id: "test_id", tabItems: [tabItem1, tabItem2])
        
        let reportLines = tab1.transactionsReport().split(separator: "\n").map{String($0)}
        
        let reportLine1WithoutTime = reportLines[1].split(separator: " ").dropFirst().joined(separator: " ")
        let reportLine2WithoutTime = reportLines[2].split(separator: " ").dropFirst().joined(separator: " ")
        
        XCTAssertEqual("Your receipt for test tab1 test_pub: ", reportLines[0])
        XCTAssertEqual("brewer1 name1 pint +£4.40", reportLine1WithoutTime)
        XCTAssertEqual("brewer2 name2 half -£2.40", reportLine2WithoutTime)
        XCTAssertEqual(" ", reportLines[3])
        XCTAssertEqual("Total: £2.00", reportLines[4])
        
    }
    func testEncodedTab() throws {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440).addTransaction()
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "half", price: 240).removeTransaction()
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test_pub", branch: "test_br", id: "test_id", tabItems: [tabItem1, tabItem2])
        
        let encoder = JSONEncoder()
        
        do {let json = try encoder.encode(tab1)
            print(String(data:json,encoding: .utf8)! )
        } catch {
            print("error decoding tab")
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
