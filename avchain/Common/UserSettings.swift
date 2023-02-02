//
//  UserSettings.swift
//  avchain
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var screen: AnyView = AnyView(Home())
    @Published var isLogin: Bool = false
    @Published var isSide: Bool = false
}
