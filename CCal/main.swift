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

print(Strings.welcomeMessage)

repeat {
    print(":", terminator: .whitespace)
    input = readLine() ?? .empty
    
    if let result = rpnCal.evaluate(input) {
        print("\(input) =", result)
    } else if input != .empty {
        print("\(input) = ERROR!")
    }
} while input != .empty
