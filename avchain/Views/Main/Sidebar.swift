//
//  Sidebar.swift
//  avchain
//

import SwiftUI


struct SidebarItem: Identifiable {
    var id: Int
    var icon: String
    var text: String
    var destination: String
    
}

var bottomActions: [SidebarItem] = [
    SidebarItem(id: 0, icon: "", text: "(주)애브체인 개인정보 처리방침", destination: ""),
    SidebarItem(id: 1, icon: "", text: "(구) 헬스아바타 개인정보 처리방침", destination: ""),
    SidebarItem(id: 2, icon: "", text: "휴대폰 본인 확인 서비스", destination: ""),
    SidebarItem(id: 3, icon: "", text: "위치기반서비스 이용약관", destination: ""),
    SidebarItem(id: 4, icon: "", text: "애브체인 헬스아바타 약관", destination: "")
]

struct simpleView: View {
    var text: String
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack {
                Image("back_arrow")
                    .font(.title)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .onTapGesture {
                        self.mode.wrappedValue.dismiss()
                    }
                Spacer()
            }
            ScrollView{
                Text(text)
            }
        }
        .navigationBarHidden(true)
    }
}

struct Sidebar: View {
    @EnvironmentObject var settings: UserSettings
    @Binding var isSidebarVisible: Bool
    @State private var username = UserDefaults.standard.string(forKey: "name") ?? "홍길동"
//    @State private var theme = UserDefaults.standard.string(forKey: "theme")
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    var bgColor: Color = Color(.init(
                                  red: 52 / 255,
                                  green: 70 / 255,
                                  blue: 182 / 255,
                                  alpha: 1))

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
            .onTapGesture {
                isSidebarVisible.toggle()
            }

            content
                .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @Environment(\.presentationMode) var presentationMode

    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                menuColor
//                MenuChevron

                VStack(alignment: .center, spacing: 10) {
                    backButton(isSidebarVisible: $isSidebarVisible)
                    userProfile
                    Divider()
                    Group {
                        logoutButton()
                        //애브체인 개인정보
                        NavigationLink("(주)애브체인 개인정보 처리방침") {
                            simpleView(text: TERMS_SERVICE_PRIVATE_INFO)
//                            .navigationBarItems(leading:
//                                        Button(action: {
//                                            self.presentationMode.wrappedValue.dismiss()
//                                        }) {
//                                            HStack {
//                                                Image(systemName: "arrow.left.circle")
//                                                Text("Go Back")
//                                            }
//                                    })
//
                        }
                        .foregroundColor(darkBrown)
                        
                        //헬스아바타 개인정보
                        NavigationLink("(구)헬스아바타 개인정보 처리방침") {
                            simpleView(text: TERMS_HEALTHAVATA)
                            
                        }
                        .foregroundColor(darkBrown)
                        
                        //휴대폰 본인확인
                        NavigationLink("휴대폰 본인 확인 서비스") {
                            simpleView(text: TERMS_MOBILE)
                            
                        }
                        .foregroundColor(darkBrown)
                        
                        //위치기반
                        NavigationLink("위치기반서비스 이용약관") {
                            simpleView(text: TERMS_MAP_SERVICE)
                            
                        }
                        .foregroundColor(darkBrown)
                        
                        
                        //애브체인 헬스아바타
                        NavigationLink("애브체인 헬스아바타 약관") {
                            simpleView(text: TERMS_MOBILE)
                            
                        }
                        .foregroundColor(darkBrown)
//                        MenuLinks(items: bottomActions)
                    }
                }
                .padding(.top, 80)
                .padding(.horizontal, 10)
                .navigationBarHidden(true)
            }
            .frame(width: sideBarWidth)
            .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: isSidebarVisible)

            Spacer()
        }
    }

    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(bgColor)
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: 45))
                .offset(x: isSidebarVisible ? -18 : -10)
                .onTapGesture {
                    isSidebarVisible.toggle()
                }

            Image(systemName: "chevron.right")
                .foregroundColor(secondaryColor)
                .rotationEffect(isSidebarVisible ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: isSidebarVisible ? -4 : 8)
                .foregroundColor(.blue)
        }
        .offset(x: sideBarWidth / 2, y: 80)
        .animation(.default, value: isSidebarVisible)
    }

    var userProfile: some View {
        VStack(alignment: .center) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
//                    .overlay(Circle().stroke(.gray, lineWidth: 2))
//                    .aspectRatio(3 / 2, contentMode: .fill)
//                    .shadow(radius: 4)
//                    .padding(.trailing, 18)
                    .foregroundColor(.white)

                VStack(alignment: .center, spacing: 6) {
                    Group {
                        Text("\(username ?? "")님")
                            .bold()
                            .font(.title3)
                        Text("건강한 하루되세요")
                            .foregroundColor(secondaryColor)
                            .font(.caption)
//                        Text("테마:환경설정에서 변경가능합니다.")
//                            .foregroundColor(Color(.init(red: 161 / 255, green: 201 / 255, blue: 64 / 255, alpha: 1)))
//                            .bold()
//                            .font(.system(size: 16))
//                        Text("\(theme ?? "테마입니다")")
//                            .bold()
//                            .font(.system(size: 16))
                    }
                    HStack {
                        Text("프로필")
                            .foregroundColor(.white)
                            .padding(.init(top: 12, leading: 15, bottom: 12, trailing: 15))
                            .background(Capsule().fill(darkBrown))
                            .onTapGesture {
                                print("프로필 이동")
                                isSidebarVisible.toggle()
                                settings.screen = AnyView(Profile())
                            }
                        Spacer()
                        Text("환경설정")
                            .foregroundColor(.white)
                            .padding(.init(top: 12, leading: 15, bottom: 12, trailing: 15))
                            .background(Capsule().fill(darkBrown))
                            .onTapGesture {
                                print("환경설정 이동")
                                isSidebarVisible.toggle()
                                settings.screen = AnyView(Setting())
                                
                            }
                    }
                    .padding(.horizontal, 30)
                }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
    }
}

struct backButton: View {
    @Binding var isSidebarVisible: Bool
    var body: some View {
        VStack(alignment: .trailing) {
            Image(systemName: "arrow.left")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(secondaryColor)
                .padding(.trailing, 18)
                .onTapGesture {
                    isSidebarVisible.toggle()
                }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct logoutButton: View {
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        VStack(alignment: .center) {
            NavigationLink(destination: AnyView(ContentView())){
                VStack(alignment: .center){
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(secondaryColor)
                    Text("로그아웃")
                        .bold()
                        .font(.title3)
                        .foregroundColor(darkBrown)
                }
            }
            
            .navigationBarHidden(true)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
}

struct MenuLinks: View {
    var items: [SidebarItem]
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(items) { item in
                menuLink(icon: item.icon, text: item.text, destination: item.destination)
            }
        }
        .padding(.vertical, 10)
        .padding(.leading, 8)
    }
}

struct menuLink: View {
    var icon: String
    var text: String
    var destination: String
    var body: some View {
        HStack {
//            Image(systemName: icon)
//                .resizable()
//                .frame(width: 20, height: 20)
//                .foregroundColor(secondaryColor)
//                .padding(.trailing, 18)
            Text(text)
                .foregroundColor(.brown)
                .font(.body)
        }
        .onTapGesture {
            print("Tapped on \(text)")
            // NavigationLink, destination으로 이동하게 하면 됨
            // 약관항목이라 아마 id 값 받아서 가게될거같음(웹뷰일때만?)
            // ... JY
        }
    }
}
