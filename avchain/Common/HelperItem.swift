//
//  HelperItem.swift
//  avchain
//

import SwiftUI

struct HelperItem: View {
    @State var title: String
    @State var content: String
    var seq: Int
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        Group {
            HStack(alignment: .top) {
                Image("icon_checkup_result")
                    .resizable()
                    .frame(width: 50, height: 70)
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.system(size: 18))
                        .foregroundColor(.brown)
                        .fontWeight(.bold)
                    Text(content)
                        .font(.system(size: 14))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.gray)
                }
                .padding(.leading,20)
                Spacer()
                VStack(alignment: .trailing) {
//                     더보기 같은 옵션기능 구현해야함 ... JY
                    Menu {
                        Button {
                            // do something
                        } label: {
                            Text("건강기록 숨기기")
                        }
                        Button {
                            // do something
                        } label: {
                            Text("건강기록 보이기")
                        }
                        Button {
                            // do something
                            if seq == 1 {
                                settings.screen = AnyView(AgentShare())
                            }
                        } label: {
                            Text("자료공유설정")
                        }
                        Button {
                            // do something
                        } label: {
                            Text("자료공유영수증")
                        }
                    } label: {
                        Image("agent_option_icon")
                            .resizable()
                            .frame(width: 10, height: 20)

                    }
//
//                    Spacer()
//                    Image("swife_icon")
//                        .resizable()
//                        .frame(width: 8, height: 20)
                }
                .frame(width: 30, height: 30)
                
            }
            .padding(.vertical, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 130, alignment: .leading)
        .border(Color(white: 0.8))
        .background(Color.white
            .shadow(radius: 2)
        )
    }
}
