//
//  Calculator.swift
//  CCal
//
//  Created by Ярослав on 23.04.2023.
//

import Foundation

let operators: [String: (prec: Int, rAssoc: Bool)] = [
    .power: (prec: 4, rAssoc: true),
    .multiplication: (prec: 3, rAssoc: false),
    .division: (prec: 3, rAssoc: false),
    .plus: (prec: 2, rAssoc: false),
    .minus: (prec: 2, rAssoc: false),
]

func parseString(_ string: String) -> [String] {
    let arithmeticOperators: Set<Character> = ["+", "-", "*", "/", "%", "^", "(", ")"]
    var result: [String] = []
    var currentString: String = ""
    
    for char in string {
        if arithmeticOperators.contains(char) {
            if !currentString.isEmpty {
                result.append(currentString)
            }
            currentString = String(char)
            result.append(currentString)
            currentString = ""
        } else {
            currentString.append(char)
        }
    }
    
    if !currentString.isEmpty {
        result.append(currentString)
    }
    
    return result
}

func performOperation(_ a: Double, _ b: Double, _ op: String) -> Double? {
    switch op {
    case .plus: return a + b
    case .minus: return a - b
    case .multiplication: return a * b
    case .division: return a / b
    case .power: return pow(a, b)
    default: return nil
    }
}

func rpn(_ tokens: [String]) -> [String] {
    var stack: [String] = [] // holds operators and left parenthesis
    var rpn: [String] = []
    
    for tok in tokens {
        switch tok {
        case "(":
            stack.push(tok) // push "(" to stack
        case ")":
            while !stack.isEmpty {
                let op = stack.pop()! // pop item from stack
                if op == "(" {
                    break // discard "("
                } else {
                    rpn += [op] // add operator to result
                }
            }
        default:
            if let o1 = operators[tok] { // token is an operator?
                for op in stack.reversed() {
                    if let o2 = operators[op] {
                        if !(o1.prec > o2.prec || (o1.prec == o2.prec && o1.rAssoc)) {
                            // top item is an operator that needs to come off
                            rpn += [stack.pop()!] // pop and add it to the result
                            continue
                        }
                    }
                    break
                }

                stack.push(tok) // push operator (the new one) to stack
            } else { // token is not an operator
                rpn += [tok] // add operand to result
            }
        }
    }

    return rpn + stack.reversed()
}

func calculate(_ exp: String) -> Double? {
    var stack: [Double] = []

    let tokens = exp.tokenize()
    let infixExp = rpn(tokens)
    
    infixExp.forEach { op in
        if let operand = Double(op) {
            stack.push(operand)
        } else {
            if let b = stack.pop(),
               let a = stack.pop(),
               let c = performOperation(a, b, op) {
                stack.push(c)
            }
        }
    }
    
    return stack.peek()
}
