//
//  Drug.swift
//  avchain
//

import SwiftUI

struct Drug: View {
    
    @State var flag: Bool = false
    var name: String
    var ampm: String
    var hhmm: String
    var week: String
    var lastUpdate: String
    
    func getToggle() -> Bool {
        return self.flag
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("icon_medic")
                    .resizable()
                    .frame(width: 40, height: 60)
                    .opacity(0.2)
                VStack(alignment: .leading) {
                    Text(name)
                        .bold()
                        .foregroundColor(.gray)
                    HStack {
                        Text("\(ampm) \(hhmm)")
                        Text("\(lastUpdate)")
                    }
                }
                Spacer()
                Toggle("", isOn: $flag)
                    .frame(width: 60)
            }
            Divider()
        }
    }
}

struct Drug_Previews: PreviewProvider {
    static var previews: some View {
        Drug(name: "asdas", ampm: "am", hhmm: "10:30", week: "월", lastUpdate: "2023-01-23 10:31:55")
    }
}
