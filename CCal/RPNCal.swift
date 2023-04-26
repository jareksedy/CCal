//
//  RPNCal.swift
//  CCal
//
//  Created by Ярослав on 26.04.2023.
//

import Foundation

typealias BinaryOperation = (_ lhs: Double, _ rhs: Double) -> Double?

enum Associativity {
    case leftToRight
    case rightToLeft
}

struct Operator {
    let signifier: String
    let precedence: Int
    let associativity: Associativity
    let binaryOperation: BinaryOperation?
}

struct Operators {
    var signifiers: [String] { operators.map { $0.signifier }}
    private var operators = [Operator]()
    
    subscript(key: String) -> Operator? {
        get { operators.first(where: { $0.signifier == key })}
        set(newValue) {
            if let index = operators.firstIndex(where: { $0.signifier == key }) {
                if let newValue = newValue {
                    operators[index] = newValue
                } else {
                    operators.remove(at: index)
                }
            } else if let newValue = newValue {
                operators.append(newValue)
            }
        }
    }
    
    init(_ operators: [Operator]) {
        self.operators = operators
    }
}

class RPNCal {
    private var operators = Operators([
        Operator(signifier: .plus, precedence: 2, associativity: .leftToRight, binaryOperation: { l, r in l + r }),
        Operator(signifier: .minus, precedence: 2, associativity: .leftToRight, binaryOperation: { l, r in l - r }),
        Operator(signifier: .asterisk, precedence: 3, associativity: .leftToRight, binaryOperation: { l, r in l * r }),
        Operator(signifier: .slash, precedence: 3, associativity: .leftToRight, binaryOperation: { l, r in l / r }),
    ])

    var allowedCharacters: String {
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" + .dot + operators.signifiers.joined() + .parentheses.joined()
    }
    
    func calculate(_ exp: String) -> Double? {
        var stack: [Double] = []
        
        let tokens = exp.tokenize()
        let infixExp = rpn(tokens)
        
        infixExp.forEach { op in
            if let operand = Double(op) {
                stack.push(operand)
            } else if let b = stack.pop(),
                      let a = stack.pop(),
                      let result = operators[op]?.binaryOperation?(a, b) {
                stack.push(result)
            }
        }
        
        return stack.peek()
    }
}

private extension RPNCal {
    func strip(_ inputString: String) -> String {
        return inputString.filter(allowedCharacters.reversed().contains)
    }
    
    func tokenize(_ inputString: String) -> [String] {
        let operatorTokens: Set<Character> = Set(String.parentheses.joined() + operators.signifiers.joined())
        var result: [String] = []
        var currentString: String = ""
        
        for char in inputString.strip() {
            if operatorTokens.contains(char) {
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
    
    func rpn(_ tokens: [String]) -> [String] {
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
                            if !(o1.precedence > o2.precedence || (o1.precedence == o2.precedence && o1.associativity == .rightToLeft)) {
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
