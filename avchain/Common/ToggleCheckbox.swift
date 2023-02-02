//
//  ToggleCheckbox.swift
//  avchain
//

import Foundation
import SwiftUI

struct ToggleCheckbox: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: "circle")
                .symbolVariant(configuration.isOn ? .fill : .none)
        }
        .tint(.green)
    }
}

extension ToggleStyle where Self == ToggleCheckbox {
    static var checklist: ToggleCheckbox { .init() }
}
