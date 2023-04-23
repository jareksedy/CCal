//
//  Calculator.swift
//  CCal
//
//  Created by Ярослав on 23.04.2023.
//

import Foundation

let operators = [
    "^": (prec: 4, rAssoc: true),
    "*": (prec: 3, rAssoc: false),
    "/": (prec: 3, rAssoc: false),
    "+": (prec: 2, rAssoc: false),
    "-": (prec: 2, rAssoc: false),
]

var stringStack: [String] = [] // holds operators and left parenthesis
var doubleStack: [Double] = [] // used to calculate the result of the expression

func performOperation(_ a: Double, _ b: Double, _ op: String) -> Double? {
    switch op {
    case "+": return a + b
    case "-": return a - b
    case "*": return a * b
    case "/": return a / b
    case "^": return pow(a, b)
    default: return nil
    }
}

func rpn(_ tokens: [String]) -> [String] {
    var rpn : [String] = []
    
    for tok in tokens {
        switch tok {
        case "(":
            stringStack += [tok] // push "(" to stack
        case ")":
            while !stringStack.isEmpty {
                let op = stringStack.removeLast() // pop item from stack
                if op == "(" {
                    break // discard "("
                } else {
                    rpn += [op] // add operator to result
                }
            }
        default:
            if let o1 = operators[tok] { // token is an operator?
                for op in stringStack.reversed() {
                    if let o2 = operators[op] {
                        if !(o1.prec > o2.prec || (o1.prec == o2.prec && o1.rAssoc)) {
                            // top item is an operator that needs to come off
                            rpn += [stringStack.removeLast()] // pop and add it to the result
                            continue
                        }
                    }
                    break
                }

                stringStack += [tok] // push operator (the new one) to stack
            } else { // token is not an operator
                rpn += [tok] // add operand to result
            }
        }
    }

    return rpn + stringStack.reversed()
}

func calculate(_ exp: String) -> Double? {
    let tokens = exp.split{ $0 == " " }.map(String.init)
    let infixExp = rpn(tokens)
    
    infixExp.forEach { op in
        if let operand = Double(op) {
            doubleStack.push(operand)
        } else {
            if let a = doubleStack.pop(),
               let b = doubleStack.pop(),
               let c = performOperation(b, a, op) {
                doubleStack.push(c)
            }
        }
    }
    
    return doubleStack.peek()
}
