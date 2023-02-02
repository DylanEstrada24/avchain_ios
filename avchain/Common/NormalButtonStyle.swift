//
//  NormalButtonStyle.swift
//  avchain
//

import SwiftUI

struct NormalButtonStyle: ButtonStyle {
  var labelColor = Color.white
  var backgroundColor = Color.blue
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(labelColor)
      .padding(.init(top: 6.5, leading: 10, bottom: 6.5, trailing: 10))
      .background(Capsule().fill(backgroundColor)) // <-
  }
}
