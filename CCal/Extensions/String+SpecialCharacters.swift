//
//  String+SpecialCharacters.swift
//  CCal
//
//  Created by Ярослав on 24.04.2023.
//

import Foundation

extension String {
    static var empty = ""
    static var whitespace = " "
    
    static var plus = "+"
    static var minus = "-"
    static var asterisk = "*"
    static var slash = "/"
    static var circumflex = "^"
    static var percent = "%"
    static var dot = "."
    
    static var leftParenthesis = "("
    static var rightParenthesis = ")"
    static var parentheses = [leftParenthesis, rightParenthesis]
}

extension String {
    func stripWhitespaces() -> String {
        return self.replacingOccurrences(of: Self.whitespace, with: Self.empty)
    }
}
