//
//  Array+Stack.swift
//  CCal
//
//  Created by Yaroslav Sedyshev on 23.04.2023.
//

extension Array {
    mutating func push(_ element: Element) { self.append(element) }
    mutating func pop() -> Element? { self.popLast() }
    func peek() -> Element? { self.last }
}
