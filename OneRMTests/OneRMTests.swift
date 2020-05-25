/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import XCTest

@testable import OneRM

class OneRMTests: XCTestCase {

    let weight: Double = 100.0
    let epsilon = 0.000000001

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBrzycki() {
        let formula = Brzycki()
        for reps in 1...12 {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            debugPrint(reps, oneRM, rm)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
            if reps == 1 {
                XCTAssert(oneRM.almostEquals(rm, epsilon: epsilon))
            }
        }
    }

    func testEpley() {
        let formula = Epley()
        for reps in 1...12 {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
            if reps == 1 {
                XCTAssert(oneRM.almostEquals(rm, epsilon: epsilon))
            }
        }
    }

    func testMcGlothin() {
        let formula = McGlothin()
        for reps in 1...12 {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
            if reps == 1 {
                XCTAssert(oneRM.almostEquals(rm, epsilon: epsilon))
            }
        }
    }

    func testLombardi() {
        let formula = Lombardi()
        for reps in 1...12 {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
            if reps == 1 {
                XCTAssert(oneRM.almostEquals(rm, epsilon: epsilon))
            }
        }
    }

    func testMayhew() {
        let formula = Mayhew()
        for reps in 1...12 {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
            if reps == 1 {
                XCTAssert(oneRM.almostEquals(rm, epsilon: epsilon))
            }
        }
    }

    func testOConner() {
        let formula = OConner()
        for reps in 1...12 {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
            if reps == 1 {
                XCTAssert(oneRM.almostEquals(rm, epsilon: epsilon))
            }
        }
    }

    func testWathen() {
        let formula = Wathen()
        for reps in 1...12 {
            let oneRM = formula.oneRM(weight: weight, reps: reps)
            let rm = formula.rm(for: reps, with: oneRM)
            XCTAssert(weight.almostEquals(rm, epsilon: epsilon))
        }
    }

    func testClosedRange() {
        let range = 1...12
        XCTAssert(range.clamp(value: 0) == 1)
        for i in range {
            XCTAssert(range.clamp(value: i) == i)
        }
        XCTAssert(range.clamp(value: 13) == 12)
    }

    func testPerformanceExample() {
        measure {
        }
    }

}
