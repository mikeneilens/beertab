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
            XCTAssertEqual( expectedState, viewController.shouldSaveButtonBeEnabled())
        }
    }
    func testCreatingTab() throws {
        let viewController = TabViewController()
        viewController.historyRepository = HistoryRepository(key:"test")
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
    
    func testPrefixNoMoreThan() throws {
        let emptyArray:Array<Int> = []
        XCTAssertEqual(0, emptyArray.prefixNoMoreThan(3).count)
        let arrayWith5Elements:Array<Int> = [1,2,3,4,5]
        XCTAssertEqual(3, arrayWith5Elements.prefixNoMoreThan(3).count)
        XCTAssertEqual([1,2,3], arrayWith5Elements.prefixNoMoreThan(3))
        XCTAssertEqual([1,2,3,4,5], arrayWith5Elements.prefixNoMoreThan(10))
    }
    
    func testCreatingSuggestedPubAlert() throws {
        let viewController = TabViewController()
        let pubs = ListOfPubs(fromJson:[K.PubListJsonName.pubs:[
                    [K.PubListJsonName.name:"Pub1",K.PubListJsonName.id:"id1",K.PubListJsonName.branch:"branch1"],
                    [K.PubListJsonName.name:"Pub2",K.PubListJsonName.id:"id2",K.PubListJsonName.branch:"branch3"],
                    [K.PubListJsonName.name:"Pub3",K.PubListJsonName.id:"id3",K.PubListJsonName.branch:"branch3"]]])
        let suggestionsAlert = viewController.createSugegstionAlert(pubs: pubs)
        
        XCTAssertEqual("Pub1", suggestionsAlert.actions[0].title)
        XCTAssertEqual(.default, suggestionsAlert.actions[0].style)
        XCTAssertEqual("Pub2", suggestionsAlert.actions[1].title)
        XCTAssertEqual(.default, suggestionsAlert.actions[1].style)
        XCTAssertEqual("Pub3", suggestionsAlert.actions[2].title)
        XCTAssertEqual(.default, suggestionsAlert.actions[2].style)
        XCTAssertEqual("No thanks", suggestionsAlert.actions[3].title)
        XCTAssertEqual(.cancel, suggestionsAlert.actions[3].style)
    }
    
    func testEncodingATab() throws {
        let tabItem1 = TabItem(brewer: "brewer1", name: "name1", size: "pint", price: 440)
        let tabItem2 = TabItem(brewer: "brewer2", name: "name2", size: "half", price: 450)
        let tab = Tab(name: "test tab", createTS: Date(), pubName: "test pub", branch: "testbr", id: "testid", tabItems: [tabItem1,tabItem2])
        
        let expectedResult = """
        {"pubName":"test pub","createTS":627417605.82063198,"id":"testid","name":"test tab","branch":"testbr","tabItems":[{"size":"pint","brewer":"brewer1","name":"name1","price":440,"transactions":[]},{"size":"half","brewer":"brewer2","name":"name2","price":450,"transactions":[]}]}
        """
        
        //the createTS is always different so remove it.
        func removeCreateTs(_ s:String)->String {Array(s.map{$0}.enumerated().filter{$0.0 < 33 || $0.0 > 50}.map{String($0.1)}).joined()  }
        
        let jsonString = tab.encode()
        XCTAssertEqual(removeCreateTs(expectedResult), removeCreateTs(jsonString!))
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
