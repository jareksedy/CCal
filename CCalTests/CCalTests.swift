//
//  CCalTests.swift
//  CCalTests
//
//  Created by Yaroslav Sedyshev on 26.04.2023.
//

import XCTest

final class CCalTests: XCTestCase {
    let expressions: [String: Int] = [
        "2+2": 4,
        "(2+4) * (4+6)": 60,
        "234.3+23.2/2+(32.3^4)/2": 544472,
        "45.4*345^3-2/(3+24.2)*99.03-24.22+12.4*45.4/22.1-4.2/2.5+0.3253": 1_864_288_567,
        "((43.5-2)/2.5039*0.255-23.5/25)*5.2^3-244566/99": -2_008,
        "23^9*2*(44.2-12.5)/2.4*9^5/100000000000000": 28_095,
        "((43.5-(1+1))/2.5039*0.255-23.5/(20+5))*5.2^3-244566/(88 + 11)": -2_008,
        ]
    
    var rpnCal: RPNCal?

    override func setUpWithError() throws {
        rpnCal = RPNCal()
        rpnCal?.addUpdateOperator([.circumflex: (precedence: 4, binaryOperation: { lhs, rhs in pow(lhs, rhs) })])
    }

    override func tearDownWithError() throws {
        rpnCal = nil
    }

    func testEvaluate() throws {
        for (key, value) in expressions {
            let result = rpnCal?.evaluate(key.stripWhitespaces()) ?? 0
            print(Int(result), value)
            XCTAssertTrue(Int(result) == value)
        }
    }
}
