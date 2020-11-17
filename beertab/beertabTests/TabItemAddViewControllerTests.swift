//
//  TabItemAddViewControllerTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 09/10/2020.
//

import XCTest
@testable import beertab

class TabItemAddViewControllerTests: XCTestCase {

    let brandTextField = UITextField()
    let nameTextField = UITextField()
    let pintPriceText = UITextField()
    let halfPriceText = UITextField()
    let thirdPriceText = UITextField()
    let twoThirdPriceText = UITextField()
    let otherPrice = UITextField()
    
    class MockUpdater:TabUpdater {
        var listOfTabItems:Array<TabItem> = []
        func addTabItems(tabItems: [TabItem]) {
            listOfTabItems += tabItems
        }
        func buyTabItem(tabItem: TabItem) {
        }
        func returnTabItem(tabItem: TabItem) {
        }
        func deleteTabItem(tabItem: TabItem) {
        }
        func replaceTabItem(position:Int, newTabItem: TabItem) {
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func setUp(viewController:TabItemAddViewController) {
        viewController.brandTextField = brandTextField
        viewController.nameTextField = nameTextField
        viewController.pintPriceText = pintPriceText
        viewController.halfPriceText = halfPriceText
        viewController.thirdPriceText = thirdPriceText
        viewController.twoThirdPriceText = twoThirdPriceText
        viewController .otherPrice = otherPrice
    }
    func testCreatingATabItemFromTheView() throws {
        let viewController = TabItemAddViewController()
        setUp(viewController:viewController)
        
        viewController.brandTextField.text = "brewer1"
        viewController.nameTextField.text = "beer1"
        
        let newTabItem = viewController.tabItemFromView(size: "pint", price: 120)
        XCTAssertEqual("brewer1", newTabItem.brewer)
        XCTAssertEqual("beer1", newTabItem.name)
        XCTAssertEqual("pint", newTabItem.size)
        XCTAssertEqual(120, newTabItem.price)
    }
    
    func testCreatingATabItemsForEachPrice() throws {
        let viewController = TabItemAddViewController()
        setUp(viewController:viewController)
        
        viewController.brandTextField.text = "brewer1"
        viewController.nameTextField.text = "beer1"
        viewController.pintPriceText.text = "2.50"
        viewController.halfPriceText.text = "1.30"
        viewController.thirdPriceText.text = "1.00"
        viewController.twoThirdPriceText.text = "2.00"
        viewController.otherPrice.text = "2.20"
        
        let mockUpdater = MockUpdater()
        viewController.createTabItems(mockUpdater)
        
        XCTAssertEqual(5,mockUpdater.listOfTabItems.count)
        XCTAssertEqual("brewer1",mockUpdater.listOfTabItems[0].brewer)
        XCTAssertEqual("beer1",mockUpdater.listOfTabItems[0].name)
        XCTAssertEqual("Pint",mockUpdater.listOfTabItems[0].size)
        XCTAssertEqual(250,mockUpdater.listOfTabItems[0].price)
        XCTAssertEqual("brewer1",mockUpdater.listOfTabItems[1].brewer)
        XCTAssertEqual("beer1",mockUpdater.listOfTabItems[1].name)
        XCTAssertEqual("Half",mockUpdater.listOfTabItems[1].size)
        XCTAssertEqual(130,mockUpdater.listOfTabItems[1].price)
        XCTAssertEqual("1/3",mockUpdater.listOfTabItems[2].size)
        XCTAssertEqual(100,mockUpdater.listOfTabItems[2].price)
        XCTAssertEqual("2/3",mockUpdater.listOfTabItems[3].size)
        XCTAssertEqual(200,mockUpdater.listOfTabItems[3].price)
        XCTAssertEqual("Other",mockUpdater.listOfTabItems[4].size)
        XCTAssertEqual(220,mockUpdater.listOfTabItems[4].price)
    }
    
    func testCreatingATabItemsWhenNoPricesSet() throws {
        let viewController = TabItemAddViewController()
        setUp(viewController:viewController)
        
        viewController.brandTextField.text = "brewer1"
        viewController.nameTextField.text = "beer1"
        viewController.pintPriceText.text = ""
        viewController.halfPriceText.text = ""
        viewController.thirdPriceText.text = ""
        viewController.twoThirdPriceText.text = ""
        viewController.otherPrice.text = ""
        
        let mockUpdater = MockUpdater()
        viewController.createTabItems(mockUpdater)
        
        XCTAssertEqual(1,mockUpdater.listOfTabItems.count)
        XCTAssertEqual("brewer1",mockUpdater.listOfTabItems[0].brewer)
        XCTAssertEqual("beer1",mockUpdater.listOfTabItems[0].name)
        XCTAssertEqual("Any",mockUpdater.listOfTabItems[0].size)
        XCTAssertEqual(0,mockUpdater.listOfTabItems[0].price)
    }
    
    func testTabItemsWithAPrice() {
        let viewController = TabItemAddViewController()
        setUp(viewController:viewController)
        viewController.brandTextField.text = "brand"
        viewController.nameTextField.text = "name"
        
        viewController.pintPriceText.text = "1.5"
        let tabItemsWithOnePrice = viewController.tabItemsWithAPrice()
        XCTAssertEqual(1, tabItemsWithOnePrice.count)
        XCTAssertEqual("brand", tabItemsWithOnePrice[0].brewer)
        XCTAssertEqual("name", tabItemsWithOnePrice[0].name)
        XCTAssertEqual("Pint", tabItemsWithOnePrice[0].size)
        XCTAssertEqual(150, tabItemsWithOnePrice[0].price)
        
        viewController.halfPriceText.text = "2.5"
        let tabItemsWithTwoPrices = viewController.tabItemsWithAPrice()
        XCTAssertEqual(2, tabItemsWithTwoPrices.count)
        XCTAssertEqual("brand", tabItemsWithTwoPrices[1].brewer)
        XCTAssertEqual("name", tabItemsWithTwoPrices[1].name)
        XCTAssertEqual("Half", tabItemsWithTwoPrices[1].size)
        XCTAssertEqual(250, tabItemsWithTwoPrices[1].price)
        
        viewController.thirdPriceText.text = "3.5"
        let tabItemsWithThreePrices = viewController.tabItemsWithAPrice()
        XCTAssertEqual(3, tabItemsWithThreePrices.count)
        XCTAssertEqual("brand", tabItemsWithThreePrices[2].brewer)
        XCTAssertEqual("name", tabItemsWithThreePrices[2].name)
        XCTAssertEqual("1/3", tabItemsWithThreePrices[2].size)
        XCTAssertEqual(350, tabItemsWithThreePrices[2].price)
        
        viewController.twoThirdPriceText.text = "4.5"
        let tabItemsWithFourPrices = viewController.tabItemsWithAPrice()
        XCTAssertEqual(4, tabItemsWithFourPrices.count)
        XCTAssertEqual("brand", tabItemsWithFourPrices[3].brewer)
        XCTAssertEqual("name", tabItemsWithFourPrices[3].name)
        XCTAssertEqual("2/3", tabItemsWithFourPrices[3].size)
        XCTAssertEqual(450, tabItemsWithFourPrices[3].price)
        
        viewController.otherPrice.text = "5.5"
        let tabItemsWithFivePrices = viewController.tabItemsWithAPrice()
        XCTAssertEqual(5, tabItemsWithFivePrices.count)
        XCTAssertEqual("brand", tabItemsWithFivePrices[4].brewer)
        XCTAssertEqual("name", tabItemsWithFivePrices[4].name)
        XCTAssertEqual("Other", tabItemsWithFivePrices[4].size)
        XCTAssertEqual(550, tabItemsWithFivePrices[4].price)
        
    }
    
    func testGettingStateForDoneButton() throws {
        let viewController = TabItemAddViewController()
        setUp(viewController:viewController)
        
        let testData = [(brandText:"",          nameText:"",           expectedResult:false),
                        (brandText:"something", nameText:"",          expectedResult:true),
                        (brandText:"",          nameText:"something", expectedResult:true),
                        (brandText:"something", nameText:"something", expectedResult:true),
                        ]
        testData.forEach{ (brandText, nameText, expectedResult ) in
            viewController.brandTextField.text = brandText
            viewController.nameTextField.text = nameText
            XCTAssertEqual(expectedResult, viewController.doneButtonShouldBeEnabled())
        }
    }

    func testConvertingATextFieldToPence() {
        let textField = UITextField()
        
        textField.text = ""
        XCTAssertEqual(0, textField.inPence())
        textField.text = "one"
        XCTAssertEqual(0, textField.inPence())
        textField.text = "4"
        XCTAssertEqual(400, textField.inPence())
        textField.text = "4.2"
        XCTAssertEqual(420, textField.inPence())
        textField.text = "4.25"
        XCTAssertEqual(425, textField.inPence())
        textField.text = "4.254"
        XCTAssertEqual(425, textField.inPence())
        textField.text = "4.255"
        XCTAssertEqual(426, textField.inPence())
        textField.text = "-4.255"
        XCTAssertEqual(-426, textField.inPence())
        textField.text = "4.60"
        XCTAssertEqual(460, textField.inPence())
        textField.text = "-4.60"
        XCTAssertEqual(-460, textField.inPence())
        
        textField.text = " -4. 60"
        XCTAssertEqual(-460, textField.inPence())
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
