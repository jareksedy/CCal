//
//  main.swift
//  CCal
//
//  Created by Yaroslav Sedyshev on 23.04.2023.
//

import Foundation

var input: String
let rpnCal = RPNCal()

rpnCal.addUpdateOperator([.circumflex: (precedence: 4, binaryOperation: { lhs, rhs in pow(lhs, rhs) })])

while true {
    print("exp:", terminator: .whitespace)
    input = readLine() ?? .empty
    if input == .empty { break }
    
    if let result = rpnCal.evaluate(input) {
        print("\(input) =", result)
    } else {
        print("\(input) = err!")
    }
}
