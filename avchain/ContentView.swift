//
//  ContentView.swift
//  avchain
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
//                ZStack(alignment: .leading) {
//                    Image("background")
//                        .resizable()
//                        .edgesIgnoringSafeArea(.all)
//                        .aspectRatio(contentMode: .fit)
//                        .scaledToFit()
//                        .frame(width: .infinity)
                    VStack(alignment: .leading) {
                        Image("app_icon")
                            .resizable()
                            .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                        Text("콩팥콩팥")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Avchain Beans")
                            .foregroundColor(.yellow)
                            .fontWeight(.bold)
                    }
                    .navigationBarHidden(true)
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                    .padding(.top, 15)
                    .zIndex(20)
//                }
                Spacer()
                VStack {
                    NavigationLink(destination: Login()) {
                        Text("로그인")
                            .frame(maxWidth: .infinity)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .background(.yellow)
                            .cornerRadius(100)
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                    }
                    HStack {
                        Spacer()
                        NavigationLink("회원가입 >") {
                            Enroll()
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.brown)
                        Spacer()
                        NavigationLink("비밀번호/이메일 찾기 >") {
                            FindPW()
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .padding(/*@START_MENU_TOKEN@*/.bottom, 50.0/*@END_MENU_TOKEN@*/)
                .padding(.horizontal)
            }
            .background(
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .frame(maxWidth: .infinity)
        .onAppear(){
            UserDefaults.standard.setValue("0", forKey: "autoLogin")
        }.navigationBarHidden(true)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 8")
    }
}
