//
//  main.swift
//  CCal
//
//  Created by Ярослав on 23.04.2023.
//

import Foundation

var input: String

while true {
    print("Введите выражение:", terminator: " ")
    input = readLine() ?? ""
    if input == "" { break }
    if let result = calculate(input) {
        print("Результат выражения \(input.tokenize().joined(separator: .whitespace)) =", result)
    } else {
        print("Ошибка в выражении!")
    }
}
