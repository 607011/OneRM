// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import XCTest

@testable import OneRM

class OneRMTests: XCTestCase {

    let weight: Double = 100.0
    let epsilon = 0.000000001
    let repRange = 1...12

    /// This method is called before the invocation of each test method in the class.
    override func setUp() {
    }

    /// This method is called after the invocation of each test method in the class.
    override func tearDown() {
    }

    func runFormulaTest(_ formula: OneRMFormula) {
        for reps in repRange {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
            if reps == 1 {
                XCTAssert(oneRM.almostEquals(rm, epsilon: epsilon))
            }
        }
    }

    func testBrzycki() {
        runFormulaTest(Brzycki())
    }

    func testEpley() {
        runFormulaTest(Epley())
    }

    func testMcGlothin() {
        runFormulaTest(McGlothin())
    }

    func testLombardi() {
        runFormulaTest(Lombardi())
    }

    func testMayhew() {
        runFormulaTest(Mayhew())
    }

    func testOConner() {
        runFormulaTest(OConner())
    }

    func testWathen() {
        runFormulaTest(Wathen())
    }

    func testClosedRange() {
        let range = repRange
        XCTAssert(range.clamp(value: repRange.lowerBound - 1) == 1)
        for i in range {
            XCTAssert(range.clamp(value: i) == i)
        }
        XCTAssert(range.clamp(value: repRange.upperBound + 1) == 12)
    }

//    func testPerformanceExample() {
//        measure {
//        }
//    }

}
