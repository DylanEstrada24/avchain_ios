//
//  BottomMenu.swift
//  avchain
//

import SwiftUI

struct BottomMenu: View {
    @State private var showMenu = false
    @ObservedObject var router = ViewRouter()
    var bgColor: Color = lightGray
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(.black.opacity(0.6))
                .opacity(showMenu ? 1 : 0)
                .animation(.easeInOut, value: showMenu)
                .onTapGesture {
                    showMenu.toggle() 
                }
                    
                
                HStack {
                    TabIcon(viewModel: .home)
                    TabIcon(viewModel: .phr)
                    
                    TabMenuIcon(showMenu: $showMenu)
                        .onTapGesture {
                            withAnimation {
                                if showMenu == false {
                                    settings.screen = AnyView(SelfManagement())
                                }
                                showMenu.toggle()
                                
                            }
                        }
                    
                    TabIcon(viewModel: .helper)
                    TabIcon(viewModel: .news)
                }
                .frame(height: UIScreen.main.bounds.height / 8)
                .frame(maxWidth: .infinity)
                .background(bgColor)
            }
            
            if showMenu {
                HStack {
                    Spacer()
                    PopUpMenu()
                        .onTapGesture {
                            showMenu = false
                        }
//                        .padding(.bottom, 144)
                }
                .padding(.trailing, 20)
                
            }
            
        }
        .ignoresSafeArea()
        
    }
}

struct TabMenuIcon: View {
    @Binding var showMenu: Bool
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(red: 99 / 255, green: 47 / 255, blue: 17 / 255))
                .frame(width: 80, height: 80)
                .shadow(radius: 4)
            
            Image(systemName: "square.and.pencil")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
//                .rotationEffect(Angle(degrees: showMenu ? 90 : 0))
        }
//        .offset(y: -44)
    }
}

struct TabIcon: View {
    let viewModel: TabBarViewModel
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        Button {
            settings.screen = AnyView(viewModel.view)
        } label: {
            VStack {
                Image(viewModel.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .frame(maxWidth: .infinity)
                Text(viewModel.title)
                    .foregroundColor(darkBrown)
            }
        }
    }
}

struct BottomMenu_Previews: PreviewProvider {
    static var previews: some View {
        BottomMenu()
    }
}
