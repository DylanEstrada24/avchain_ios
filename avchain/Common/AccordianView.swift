//
//  AccordianView.swift
//  avchain
//

import SwiftUI

struct AccordionView<Label, Content>: View
where Label : View, Content : View {
  @Binding var expandedIndex: Int?
  let sectionCount: Int
  @ViewBuilder let label: (Int) -> Label
  @ViewBuilder let content: (Int) -> Content

  var body: some View {
    VStack {
      ForEach(0..<sectionCount, id: \.self) { index in
        DisclosureGroup(isExpanded: .init(get: {
          expandedIndex == index
        }, set: { value in
          expandedIndex = value ? index : nil
        }), content: {
          content(index)
        }, label: {
          label(index)
        })
        Divider()
      }
    }
  }
}
