//
//  main.swift
//  CCal
//
//  Created by Ярослав on 23.04.2023.
//

import Foundation

let rpnCal = RPNCal()
var input: String

rpnCal.addUpdateOperator([.circumflex: (prec: 4, assoc: .rtl, binaryOperation: { lhs, rhs in pow(lhs, rhs) })])

while true {
    print("exp:", terminator: .whitespace)
    input = readLine() ?? .empty
    if input == .empty { break }
    
    if let result = rpnCal.calculate(input) {
        print("\(input) =", result)
    } else {
        print("\(input) = err!")
    }
}
