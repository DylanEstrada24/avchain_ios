//
//  Header.swift
//  avchain
//

import SwiftUI

struct Header: View {
    var title: String
    var color: Color = headerColor
    var body: some View {
        ZStack {
            color
            Group {
                VStack(alignment: .center) {
                    HStack {
                        Text(title)
                            .font(.body)
                            .foregroundColor(.white)
                        
                        
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
        }
        .frame(height: 40)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(title: "header")
    }
}
