//
//  RPNCal.swift
//  CCal
//
//  Created by Yaroslav Sedyshev on 26.04.2023.
//

import Foundation

typealias BinaryOperation = (_ lhs: Double, _ rhs: Double) -> Double?
typealias Operator = [String: (precedence: Int, binaryOperation: BinaryOperation)]

class RPNCal {
    private var operators: Operator = [
        .plus: (precedence: 2, binaryOperation: { lhs, rhs in lhs + rhs }),
        .minus: (precedence: 2, binaryOperation: { lhs, rhs in lhs - rhs }),
        .asterisk: (precedence: 3, binaryOperation: { lhs, rhs in lhs * rhs }),
        .slash: (precedence: 3, binaryOperation: { lhs, rhs in lhs / rhs })
    ]
    
    func evaluate(_ exp: String) -> Double? {
        let tokens = tokenize(exp)
        let rpnExp = toRPN(tokens)
        
        var stack: [Double] = []
        
        rpnExp.forEach { op in
            if let operand = Double(op) {
                stack.push(operand)
            } else if let rhs = stack.pop(),
                      let lhs = stack.pop(),
                      let result = operators[op]?.binaryOperation(lhs, rhs) {
                stack.push(result)
            }
        }
        
        return stack.peek()
    }
}

// MARK: - OPERATOR PUBLIC METHODS
extension RPNCal {
    func addUpdateOperator(_ op: Operator) {
        guard let key = op.keys.first, let value = op.values.first else { return }
        operators[key] = value
    }
    
    func removeOperator(_ op: String) {
        operators.removeValue(forKey: op)
    }
}

// MARK: - PRIVATE METHODS
private extension RPNCal {
    func tokenize(_ inputString: String) -> [String] {
        let operatorTokens: Set<Character> = Set(String.parentheses.joined() + operators.keys.joined())
        var result: [String] = []
        var currentString: String = .empty
        
        for char in inputString.stripWhitespaces() {
            if operatorTokens.contains(char) {
                if !currentString.isEmpty {
                    result.append(currentString)
                }
                currentString = String(char)
                result.append(currentString)
                currentString = .empty
            } else {
                currentString.append(char)
            }
        }
        
        if !currentString.isEmpty {
            result.append(currentString)
        }
        
        return result
    }
    
    func toRPN(_ tokens: [String]) -> [String] {
        var stack: [String] = [] // holds operators and left parenthesis
        var rpn: [String] = []
        
        for token in tokens {
            switch token {
            case .leftParenthesis: stack.push(token) // push "(" to stack
            case .rightParenthesis:
                while !stack.isEmpty {
                    let op = stack.pop()! // pop item from stack
                    if op == .leftParenthesis {
                        break // discard "("
                    } else {
                        rpn += [op] // add operator to result
                    }
                }
            default:
                if let o1 = operators[token] { // token is an operator?
                    for op in stack.reversed() {
                        if let o2 = operators[op] {
                            if !(o1.precedence > o2.precedence) {
                                // top item is an operator that needs to come off
                                rpn += [stack.pop()!] // pop and add it to the result
                                continue
                            }
                        }
                        break
                    }
                    stack.push(token) // push operator (the new one) to stack
                } else { // token is not an operator
                    rpn += [token] // add operand to result
                }
            }
        }
        
        return rpn + stack.reversed()
    }
}
