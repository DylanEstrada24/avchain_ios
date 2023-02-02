//
//  TabBarViewModel.swift
//  avchain
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentItem: TabBarViewModel = .home
    
    var view: some View { return currentItem.view }
}

enum TabBarViewModel: Int, CaseIterable {
    case home
    case phr
    case helper
    case news
    
    var imageName: String {
        switch self {
        case .home: return "noselect_home"
        case .phr: return "noselect_health_record"
        case .helper: return "noselect_agent"
        case .news: return "noselect_health_info"
        }
    }
    
    var view: some View {
        switch self {
        case .home:
            return AnyView(Home())
        case .phr:
            return AnyView(PHR())
        case .helper:
            return AnyView(Helper())
        case .news:
            return AnyView(News())
        }
    }
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .phr: return "PHR"
        case .helper: return "도우미"
        case .news: return "콩팥뉴스"
        }
    }
}

