//
//  GuidePage.swift
//  avchain
//

import SwiftUI

struct GuidePage: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        return GeometryReader { proxy in
            ScrollView(.horizontal) {
                HStack {
                    Spacer()
                    Image(systemName: "multiply")
                        .font(.title)
                        .onTapGesture {
                            print("1231231232")
                            self.mode.wrappedValue.dismiss()
                        }
                        .zIndex(20)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top)
                HStack(spacing: 0) {
                    VStack(spacing: 50) {
                        Text("환자들을 위한\n희소식!!!")
                            .bold()
                            .foregroundColor(.white)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            
                        
                        Text("새로워진 아바타빈즈의\n체계적인 관리와\n맞춤형 특화 정보들을 만나보세요")
                            .foregroundColor(lightYellow)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 10) {
                            Text("보기")
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width: 20, height: 10)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            print("606060600")
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    VStack {
                        Spacer()
                        Image("guide2")
                            .resizable()
                            .frame(width: proxy.size.width - 40, height: 300)
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    VStack {
                        Spacer()
                        Image("guide3")
                            .resizable()
                            .frame(width: proxy.size.width - 40, height: 500)
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
        }.onAppear {
            UIScrollView.appearance().isPagingEnabled = true
        }
        .background(darkGray)
        .navigationBarBackButtonHidden(true)
    }
}

struct GuidePage_Previews: PreviewProvider {
    static var previews: some View {
        GuidePage()
    }
}
