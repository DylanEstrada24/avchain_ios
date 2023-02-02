//
//  TextInputBox.swift
//  avchain
//

import SwiftUI

struct TextInputBox: View {
    let title: String
    let text: String
    let placeholder: String
    let callback: (String)->()
    init (
        title: String,
        text: String,
        placeholder: String,
        callback: @escaping (String)->()
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.callback = callback
    }
    var body: some View {
        HStack {
            Text(title)
            TextField(placeholder, text: callback)
                .padding()
        }
        .padding(.horizontal)
        .padding(.vertical, -3.0)
        Divider()
            .background(.yellow)
            .padding(.vertical, -5.0)
    }
}
