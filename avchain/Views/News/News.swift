//
//  News.swift
//  avchain
//

import SwiftUI

struct News: View {
    @State var category = ["새소식", "카드뉴스", "영상뉴스"]
    @State var selected: String = "새소식"
    var body: some View {
        VStack {
            // 카테고리 시작
            Group {
                HStack {
                    ForEach(category, id: \.self) { str in
                        Spacer()
                        VStack {
                            Button(str) {
                                print(str)
                                self.selected = str
                            }
                                .foregroundColor(.brown)
                        }
                        .padding(.bottom, 10)
                        .overlay(
                            selected == str ? Group {
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.yellow)
                                }
                            } : nil
                        )
                    }
                    Spacer()
                }
                .navigationBarHidden(true)
                .padding(.vertical)
                .background(gray)
            }
            // 카테고리 끝
            
            switch (selected) {
                case "새소식":
                    WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v1/news/patient/news.jsp")
                case "카드뉴스":
                    WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v1/news/patient/card_news.jsp")
                case "영상뉴스":
                    WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v2/education/index.html?avatarType=beans")
                default:
                    emptySpace()
            }
            
            Spacer()
        }
    }
}

struct News_Previews: PreviewProvider {
    static var previews: some View {
        News()
    }
}
