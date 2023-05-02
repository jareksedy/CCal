//
//  String+Helpers.swift
//  CCal
//
//  Created by Ярослав on 02.05.2023.
//

import Foundation

extension String {
    func stripWhitespaces() -> String {
        return self.replacingOccurrences(of: Self.whitespace, with: Self.empty)
    }
    
    func format(_ args: CVarArg...) -> String {
        String(format: self, arguments: args)
    }
}
