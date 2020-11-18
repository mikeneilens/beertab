//
//  UserOptionRepository.swift
//  beertabTests
//
//  Created by Michael Neilens on 14/11/2020.
//

import XCTest
@testable import beertab
class UserOptionRepositoryTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWriting() throws {
        UserDefaults.standard.removeObject(forKey: "testo1")
        let userOptionRepository = UserOptionsRepository(key:"test")
        userOptionRepository.set("o1", value: "v1")
        XCTAssertEqual("v1", UserDefaults.standard.object(forKey: ("testo1") ) as! String )
    }

    func testReading() throws {
        UserDefaults.standard.setValue("v1", forKey: "testo1")
        let userOptionRepository = UserOptionsRepository(key:"test")
        XCTAssertEqual("v1", userOptionRepository.read("o1") )
    }
    
    func testPerformanceExample() throws {
        UserDefaults.standard.removeObject(forKey: "testo1")
        let userOptionRepository = UserOptionsRepository(key:"test")
        XCTAssertFalse( userOptionRepository.isSet(for:"o1") )
        userOptionRepository.set("o1", value: "v1")
        XCTAssertTrue( userOptionRepository.isSet(for:"o1") )
    }
}
