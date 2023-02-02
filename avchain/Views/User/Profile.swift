//
//  Profile.swift
//  avchain
//

import SwiftUI

struct ProfileItem: Identifiable {
    var id: Int
    var title: String
    var content: String
}



struct Profile: View {
    @StateObject var settings = UserSettings()
    
    @State var username = UserDefaults.standard.string(forKey: "name") ?? ""
    @State var birth = UserDefaults.standard.string(forKey: "birth") ?? ""
    @State var gender = UserDefaults.standard.string(forKey: "gender") ?? ""
    @State var nickname = UserDefaults.standard.string(forKey: "nickName") ?? ""
    @State var email = UserDefaults.standard.string(forKey: "email") ?? ""
    @State var phone = UserDefaults.standard.string(forKey: "mobile") ?? ""
    @State var date = Date()
    
    @State var isUpdateUser = false
    
    var body: some View {
        ScrollView{
            
            VStack {
                Header(title: "프로필")
                ZStack {
                    menuColor
                    Group {
                        VStack(alignment: .center) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 90, height: 90, alignment: .center)
                                .clipShape(Circle())
                                .padding(.top,10)
                                .foregroundColor(.white)
                            Text(username ?? "")
                                .bold()
                                .font(.title)
                            
                            Text(gender == "male" ? "남" : "여")
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            Text(birth ?? KoreanDate.dateFormat.string(from: date))
                                .font(.title3)
                                .padding(.bottom)
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                ZStack {
                    white
                    Group {
                        VStack(alignment: .center, spacing: 10) {
                            infoItem(title: "별명", content: nickname )
                            infoItem(title: "이메일", content: email )
                            infoItem(title: "연락처", content: phone )
                            
                            HStack(spacing: 50) {
//                                Button("취소") {
//                                    isUpdateUser = false
//                                }.buttonStyle(NormalButtonStyle(labelColor: .white, backgroundColor: .brown))
//                                Button("수정") {
//                                    isUpdateUser.toggle()
//                                    print("11111")
//
//            //                        settings.screen = AnyView(ChangeInfo())
//                                }.buttonStyle(NormalButtonStyle(labelColor: .white, backgroundColor: .brown))
                                NavigationLink(destination: ChangeInfo()){
                                    Text("수정")
                                        .foregroundColor(.white)
                                        .padding(.init(top: 12, leading: 15, bottom: 12, trailing: 15))
                                        .background(Capsule().fill(darkBrown))
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationBarHidden(true)
        
    }
    
}

struct infoItem: View {
    var title: String
    var content: String
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, 10)
            Text(content)
                .bold()
                .font(.title3)
                .padding(.bottom, 10)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

