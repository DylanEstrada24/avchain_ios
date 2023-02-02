//
//  Extentions.swift
//  avchain
//

import Foundation
import UIKit


extension UIView {
    /// Returns the first constraint with the given identifier, if available.
    ///
    /// - Parameter identifier: The constraint identifier.
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.first { $0.identifier == identifier }
    }
}

extension Double {
    func toInt() -> Int? {
        let minInt = Double(Int.min)
        let maxInt = Double(Int.max)

        guard case minInt ... maxInt = self else {
            return nil
        }

        return Int(self)
    }
}

extension BinaryFloatingPoint {
    func integer<B: BinaryInteger>() -> B { .init(self) }
    var int: Int { integer() }
}

extension String {
    func toDateForUserInfo() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone(identifier: "GMT+9")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toDateForInput() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        dateFormatter.timeZone = TimeZone(identifier: "GMT+9")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}


extension Date {
    func toStringForUserInfo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func toStringForInput() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}


extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
