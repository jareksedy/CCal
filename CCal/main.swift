//
//  main.swift
//  CCal
//
//  Created by Yaroslav Sedyshev on 23.04.2023.
//

import Foundation

var input: String
let rpnCal = RPNCal()
let prompt = "E:"

rpnCal.addUpdateOperator([.circumflex: (precedence: 4, binaryOperation: { lhs, rhs in pow(lhs, rhs) })])
rpnCal.addUpdateOperator([.percent: (precedence: 3, binaryOperation: { lhs, rhs in lhs.truncatingRemainder(dividingBy: rhs) })])

let welcomeMessage = Strings.welcomeMessage.format(rpnCal.getSupportedOperators().sorted().joined(separator: .comma + .whitespace))
print(welcomeMessage)

repeat {
    print(prompt, terminator: .whitespace)
    input = readLine()?.stripWhitespaces() ?? .empty
    
    let formattedExpression = rpnCal.getFormattedExpression(input)
    
    if let result = rpnCal.evaluate(input) {
        print("\(formattedExpression) = \(result)")
    } else if input != .empty {
        print("\(formattedExpression) = ERROR!")
    }
} while input != .empty
