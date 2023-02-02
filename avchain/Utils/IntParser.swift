//
//  IntParser.swift
//  avchain
//

import Foundation

extension Double {
    static func parse(from string: String) -> Double {
        if string.contains(".") { return Double(string)! }
        return Double(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0.0
    }
}
