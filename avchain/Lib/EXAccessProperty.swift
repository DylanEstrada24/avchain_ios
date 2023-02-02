//
//  EXAccessProperty.swift
//  EXBinder
//

protocol EXAccessProperty {}

extension EXAccessProperty {
    subscript(key: String) -> Any? {
        let m = Mirror(reflecting: self)
        for child in m.children {
            if child.label == key { return child.value }
        }
        return nil
    }
}
