//
//  RPNCal.swift
//  CCal
//
//  Created by Ярослав on 26.04.2023.
//

import Foundation

enum Associativity {
    case ltr
    case rtl
}

typealias BinaryOperation = (_ lhs: Double, _ rhs: Double) -> Double?
typealias Operator = [String: (prec: Int, assoc: Associativity, binaryOperation: BinaryOperation)]

class RPNCal {
    private var operators: Operator = [
        .plus: (prec: 2, assoc: .ltr, binaryOperation: { lhs, rhs in lhs + rhs }),
        .minus: (prec: 2, assoc: .ltr, binaryOperation: { lhs, rhs in lhs - rhs }),
        .asterisk: (prec: 3, assoc: .ltr, binaryOperation: { lhs, rhs in lhs * rhs }),
        .slash: (prec: 3, assoc: .ltr, binaryOperation: { lhs, rhs in lhs / rhs })
    ]
    
    var allowedCharacters: String {
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" + .dot + operators.keys.joined() + .parentheses.joined()
    }
    
    func calculate(_ exp: String) -> Double? {
        var stack: [Double] = []
        
        let tokens = tokenize(exp)
        let infixExp = toRPN(tokens)
        
        infixExp.forEach { op in
            if let operand = Double(op) {
                stack.push(operand)
            } else if let b = stack.pop(),
                      let a = stack.pop(),
                      let result = operators[op]?.binaryOperation(a, b) {
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
}

// MARK: - PRIVATE METHODS
private extension RPNCal {
    func strip(_ inputString: String) -> String {
        return inputString.filter(allowedCharacters.reversed().contains)
    }
    
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
            case .leftParenthesis:
                stack.push(token) // push "(" to stack
                
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
                            if !(o1.prec > o2.prec || (o1.prec == o2.prec && o1.assoc == .rtl)) {
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
