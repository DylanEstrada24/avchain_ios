//
//  PopUpMenu.swift
//  avchain
//

import SwiftUI

struct PopUpMenu: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            ForEach(PopUpViewModel.allCases, id: \.self) { item in
                if item == .target {
                    MenuItem(viewModel: item)
                    .onTapGesture {
                        settings.screen = AnyView(item.destination)
                    }
                } else {
                    NavigationLink(destination: item.destination) {
                        MenuItem(viewModel: item)
                    }
                }
            }
            Spacer()
        }
//        .transition(.scale.animation(.easeInOut))
        .transition(.move(edge: .trailing))
        .animation(.easeInOut)
    }
}

enum PopUpViewModel: Int, CaseIterable {
    case food
    case exercise
    case blood
    case bloodsugar
    case sleep
    case medication
    case target
    
    var imageName: String {
        switch self {
        case .food: return "menu001"
        case .exercise: return "menu002"
        case .blood: return "menu0031"
        case .bloodsugar: return "menu0032"
        case .sleep: return "menu004"
        case .medication: return "menu005"
        case .target: return "menu006"
        }
    }
    
    var destination: some View {
        switch self {
        case .food: return AnyView(SelfInputs(selected: "음식"))
        case .exercise: return AnyView(SelfInputs(selected: "운동"))
        case .blood: return AnyView(SelfInputs(selected: "혈압"))
        case .bloodsugar: return AnyView(SelfInputs(selected: "혈당"))
        case .sleep: return AnyView(SelfInputs(selected: "수면흡연"))
        case .medication: return AnyView(SelfInputs(selected: "복약증상"))
        case .target: return AnyView(TargetSetting())
        }
    }
}


struct MenuItem: View {
    let viewModel: PopUpViewModel
    let dimension: CGFloat = 80
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
//                Circle()
//                    .foregroundColor(Color(.systemBlue))
//                    .frame(width: 56, height: 56)
//                    .shadow(radius: 4)
                
                Image(viewModel.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .padding(12)
                    .frame(width: dimension, height: dimension)
                    .foregroundColor(Color(.white))
            }
        }
    }
}

struct PopUpMenu_Previews: PreviewProvider {
    static var previews: some View {
        PopUpMenu()
    }
}
