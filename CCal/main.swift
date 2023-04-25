//
//  main.swift
//  CCal
//
//  Created by Ярослав on 23.04.2023.
//

import Foundation

var input: String

while true {
    print("exp:", terminator: " ")
    input = readLine() ?? ""
    if input == "" { break }
    
    if let result = calculate(input) {
        print("\(input.tokenize().joined(separator: .whitespace)) =", result)
    } else {
        print("\(input.tokenize().joined(separator: .whitespace)) = err!")
    }
}
