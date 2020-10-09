//
//  TabViewControllerTests.swift
//  beertabTests
//
//  Created by Michael Neilens on 09/10/2020.
//

import XCTest
@testable import beertab

class TabViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTestSettingDoneButtonState() throws {
        let testData = [ (name:"", pubName:"", expectedState:false ),
                         (name:"something", pubName:"", expectedState:true ),
                         (name:"", pubName:"something", expectedState:true ),
        ]
        
        let viewController = TabViewController()
        let nameTextField = UITextField()
        let pubNameTextField  = UITextField()
        viewController.name = nameTextField
        viewController.pubName = pubNameTextField
        
        testData.forEach{ (name, pubName, expectedState ) in
            viewController.name.text = name
            viewController.pubName.text = pubName
            XCTAssertEqual( expectedState, viewController.getDoneButtonState())
        }
    }
    func testCreatingTab() throws {
        let viewController = TabViewController()
        let nameTextField = UITextField()
        let pubNameTextField  = UITextField()
        viewController.name = nameTextField
        viewController.pubName = pubNameTextField
        
        viewController.name.text = "a name"
        viewController.pubName.text = "a pub"
        
        viewController.createTabAndAddToHistory()
        
        XCTAssertEqual("a name", history.allTabs.last?.name)
        XCTAssertEqual("a pub", history.allTabs.last?.pubName)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
