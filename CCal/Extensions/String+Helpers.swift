//
//  String+Helpers.swift
//  CCal
//
//  Created by Ярослав on 24.04.2023.
//

import Foundation

extension String {
    func strip() -> String {
        let allowedCharacters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-*/."
        return self.filter(allowedCharacters.reversed().contains)
    }
    
    func tokenize() -> [String] {
        let arithmeticOperators: Set<Character> = ["+", "-", "*", "/", "%", "^"]
        var result: [String] = []
        var currentString: String = ""
        
        for char in self.strip() {
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
}
