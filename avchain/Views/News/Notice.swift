//
//  Notice.swift
//  avchain
//

import SwiftUI

struct Notice: View  {
    var body: some View {
        VStack {
            // 카테고리 시작
            Group {
                HStack {
                    Text("공지사항 / 이벤트")
                        .foregroundColor(.brown)
                    Spacer()
                }
                .navigationBarHidden(true)
            }
            // 카테고리 끝
            
            WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v1/notice/patient/main.jsp")
                .padding(.horizontal,20)
            Spacer()
        }
    }
}

struct Notice_Previews: PreviewProvider {
    static var previews: some View {
        Notice()
    }
}
