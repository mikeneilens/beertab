//
//  CurryTest.swift
//  beertabTests
//
//  Created by Michael Neilens on 19/11/2020.
//

import XCTest
@testable import beertab
class CurryTest: XCTestCase {
    func testSingleParamCurrying() throws {
        func addOne(to value:Int) -> Int { value + 1 }
        XCTAssertEqual(7, (addOne <<== 6) ())
    }
    func testTwoParamCurrying() throws {
        func addTogether(_ first:Int, _ second:Int) -> Int { first + second }
        XCTAssertEqual(9, (addTogether <<== 5 )(4))
        XCTAssertEqual(9, (addTogether <<== 5 <<== 4)())
    }
    func testThreeParamCurrying() throws {
        func addThreeTogether(_ first:Int, _ second:Int, _ third:Int) -> Int { first + second + third }
        XCTAssertEqual(12, (addThreeTogether <<== 5 <<== 4 <<== 3)())
    }
    func testFourParamCurrying() throws {
        func addFourTogether(_ first:Int, _ second:Int, _ third:Int, _ fourth:Int) -> Int { first + second + third + fourth }
        XCTAssertEqual(14, (addFourTogether <<== 5 <<== 4 <<== 3 <<== 2)())
    }
    
}
