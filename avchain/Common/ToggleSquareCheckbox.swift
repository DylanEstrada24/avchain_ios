//
//  ToggleCheckbox.swift
//  avchain
//

import Foundation
import SwiftUI

struct ToggleSquareCheckbox: ToggleStyle {
    
    let color: Color
    
    init (color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .symbolVariant(configuration.isOn ? .fill : .none)
        }
        .tint(color)
    }
}

extension ToggleStyle where Self == ToggleSquareCheckbox {
    static var checklist: ToggleSquareCheckbox { .init(color: .black) }
}
