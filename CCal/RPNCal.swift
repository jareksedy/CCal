//
//  RPNCal.swift
//  CCal
//
//  Created by Yaroslav Sedyshev on 26.04.2023.
//

import Foundation

typealias BinaryOperation = (_ lhs: Double, _ rhs: Double) -> Double?
typealias BinaryOperator = [String: (precedence: Int, binaryOperation: BinaryOperation)]

class RPNCal {
    private var operators: BinaryOperator = [
        .plus: (precedence: 2, binaryOperation: { lhs, rhs in lhs + rhs }),
        .minus: (precedence: 2, binaryOperation: { lhs, rhs in lhs - rhs }),
        .asterisk: (precedence: 3, binaryOperation: { lhs, rhs in lhs * rhs }),
        .slash: (precedence: 3, binaryOperation: { lhs, rhs in lhs / rhs })
    ]
    
    func evaluate(_ exp: String) -> Double? {
        let tokens = tokenize(exp)
        let rpnExp = toRPN(tokens)
        
        var stack = [Double]()
        
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

// MARK: - PUBLIC METHODS
extension RPNCal {
    func getSupportedOperators() -> String {
        return operators.keys.sorted().joined(separator: .whitespace)
    }
    
    func addUpdateOperator(_ op: BinaryOperator) {
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
        
        inputString.forEach { char in
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
        var queue = [String]()
        var stack = [String]()
        
        tokens.forEach { token in
            switch token {
            case .leftParenthesis:
                stack.push(token)
            case .rightParenthesis:
                while !stack.isEmpty {
                    let op = stack.pop()!
                    if op == .leftParenthesis {
                        break
                    } else {
                        queue.enqueue(op)
                    }
                }
            default:
                if let o1 = operators[token] {
                    for op in stack.reversed() {
                        if let o2 = operators[op] {
                            if !(o1.precedence > o2.precedence) {
                                queue.enqueue(stack.pop()!)
                                continue
                            }
                        }
                        break
                    }
                    stack.push(token)
                } else {
                    queue.enqueue(token)
                }
            }
        }
        
        return queue + stack.reversed()
    }
}
