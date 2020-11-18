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
    func testReplaceTabItemInTabContainingThreeItems() {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint1", price: 440)
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "pint2", price: 450).addTransaction().addTransaction()
        let tabItem3 = TabItem(brewer: "brewer3", name: "name3", size: "pint3", price: 460)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "test br", id: "test id", tabItems: [tabItem1, tabItem2, tabItem3])
        
        let newTabItem = TabItem(brewer: "brewer4", name: "name4", size: "pint4", price: 470)
        let newTab = tab.replace(position:1, newTabItem:newTabItem)
        XCTAssertEqual("test tab", newTab.name)
        XCTAssertEqual("test pub", newTab.pubName)
        XCTAssertEqual("test br", newTab.branch)
        XCTAssertEqual("test id", newTab.id)
        XCTAssertEqual("name1", newTab.tabItems[0].name)
        XCTAssertEqual("name3", newTab.tabItems[2].name)
        XCTAssertEqual("name4", newTab.tabItems[1].name)
        XCTAssertEqual(470, newTab.tabItems[1].price)
        XCTAssertEqual(2, newTab.tabItems[1].transactions.count)
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
        
        XCTAssertEqual("Your bill for test tab1 at test_pub: ", reportLines[0])
        XCTAssertEqual("brewer1 name1 pint +£4.40", reportLine1WithoutTime)
        XCTAssertEqual("brewer2 name2 half -£2.40", reportLine2WithoutTime)
        XCTAssertEqual(" ", reportLines[3])
        XCTAssertEqual("Total: £2.00", reportLines[4])
        
    }
    
    func testCurrencyParsing() throws {
        let empty = try createCurrency(string: "").inPence()
        XCTAssertEqual(0, empty)
        let integerNoSign = try createCurrency(string: "123").inPence()
        XCTAssertEqual(12300, integerNoSign)
        let integerPositiveSign = try createCurrency(string: "+1234").inPence()
        XCTAssertEqual(123400, integerPositiveSign)
        let integerNegativeSign = try createCurrency(string: "-123").inPence()
        XCTAssertEqual(-12300, integerNegativeSign)
        let valueWithOneDecimalPlace = try createCurrency(string: "123.4").inPence()
        XCTAssertEqual(12340, valueWithOneDecimalPlace)
        let valueWithTwoDecimalPlace = try createCurrency(string: "123.45").inPence()
        XCTAssertEqual(12345, valueWithTwoDecimalPlace)
        let valueWithThreeDecimalPlaceRoundDown = try createCurrency(string: "123.454").inPence()
        XCTAssertEqual(12345, valueWithThreeDecimalPlaceRoundDown)
        let valueWithThreeDecimalPlaceRoundUp = try createCurrency(string: "123.455").inPence()
        XCTAssertEqual(12346, valueWithThreeDecimalPlaceRoundUp)
        do {let _ = try createCurrency(string: "+").inPence()
            XCTAssertFalse(true,"should throw if sign is not followed by something")
        } catch ParseError.badData(let char) {XCTAssertEqual(nil,char) }
        do {let _ = try createCurrency(string: "+£").inPence()
            XCTAssertFalse(true,"should throw if sign is not followed by a numerical digit")
        } catch ParseError.badData(let char) {XCTAssertEqual("£",char) }
        do {let _ = try createCurrency(string: "1.").inPence()
            XCTAssertFalse(true,"should throw if decimal is not followed by something")
        } catch ParseError.badData(let char) {XCTAssertEqual(nil,char) }
        do {let _ = try createCurrency(string: "1.x").inPence()
            XCTAssertFalse(true,"should throw if decimal is not followed by a numerical digit")
        } catch ParseError.badData(let char) {XCTAssertEqual("x",char) }
        do {let _ = try createCurrency(string: "x").inPence()
            XCTAssertFalse(true,"should throw if first character is not a sign or a digit")
        } catch ParseError.badData(let char) {XCTAssertEqual("x",char) }
        do {let _ = try createCurrency(string: "1z").inPence()
            XCTAssertFalse(true,"should throw if digit is not followed by a digit or decimal")
        } catch ParseError.badData(let char) {XCTAssertEqual("z",char) }
        do {let _ = try createCurrency(string: "1.3y").inPence()
            XCTAssertFalse(true,"should throw if a lower digit is not followed by a lower digit")
        } catch ParseError.badData(let char) {XCTAssertEqual("y",char) }
    }
    func testCurrencyValidation() throws {
        XCTAssertTrue(isValidCurrency(string: "1.23"))
        XCTAssertTrue(isValidCurrency(string: "-1.23"))
        XCTAssertTrue(isValidCurrency(string: ""))
        XCTAssertFalse(isValidCurrency(string: "+"))
        XCTAssertFalse(isValidCurrency(string: "1."))
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
    func testtabsByDate() throws {
        let emptyHistory = History(allTabs: [])
        XCTAssertEqual(0, emptyHistory.tabsByDate.count)
        
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440).addTransaction()
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "half", price: 240).removeTransaction()
        let tab1 = Tab(name: "test tab1", createTS: Date() - 1, pubName: "test_pub", branch: "test_br", id: "test_id", tabItems: [tabItem1, tabItem2])
        
        let historyWithOneTab = History(allTabs: [tab1])
        XCTAssertEqual(1, historyWithOneTab.tabsByDate.count)
        XCTAssertEqual(tab1, historyWithOneTab.tabsByDate[0].tabs[0])
        XCTAssertEqual(tab1.dateString, historyWithOneTab.tabsByDate[0].date)

        let tab2 = Tab(name: "test tab2", createTS: Date(), pubName: "test_pub", branch: "test_br", id: "test_id", tabItems: [tabItem1, tabItem2])
        let historyWithTwoTabsSameDate = History(allTabs: [tab1, tab2])
        XCTAssertEqual(1, historyWithTwoTabsSameDate.tabsByDate.count)
        XCTAssertEqual(tab2, historyWithTwoTabsSameDate.tabsByDate[0].tabs[0])
        XCTAssertEqual(tab1, historyWithTwoTabsSameDate.tabsByDate[0].tabs[1])
        XCTAssertEqual(tab1.dateString, historyWithTwoTabsSameDate.tabsByDate[0].date)

        let tab3 = Tab(name: "test tab2", createTS: Date() - 86400, pubName: "test_pub", branch: "test_br", id: "test_id", tabItems: [tabItem1, tabItem2])
        let historyWithTwoTabsSameDateAndOneTabOlder = History(allTabs: [tab1, tab2, tab3])
        XCTAssertEqual(2, historyWithTwoTabsSameDateAndOneTabOlder.tabsByDate.count)
        XCTAssertEqual(tab2, historyWithTwoTabsSameDateAndOneTabOlder.tabsByDate[0].tabs[0])
        XCTAssertEqual(tab1, historyWithTwoTabsSameDateAndOneTabOlder.tabsByDate[0].tabs[1])
        XCTAssertEqual(tab1.dateString, historyWithTwoTabsSameDateAndOneTabOlder.tabsByDate[0].date)
        XCTAssertEqual(tab3, historyWithTwoTabsSameDateAndOneTabOlder.tabsByDate[1].tabs[0])
        XCTAssertEqual(tab3.dateString, historyWithTwoTabsSameDateAndOneTabOlder.tabsByDate[1].date)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
