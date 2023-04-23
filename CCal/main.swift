//
//  main.swift
//  CCal
//
//  Created by Ярослав on 23.04.2023.
//

import Foundation

var input: String

repeat {
    print("exp:", terminator: " ")
    input = readLine() ?? ""
    if let result = calculate(input) {
        print("res:", result)
    } else {
        print("err!")
    }
} while input != ""
