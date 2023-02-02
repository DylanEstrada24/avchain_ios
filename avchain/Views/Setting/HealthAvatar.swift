//
//  HealthAvatar.swift
//  avchain
//

import SwiftUI

struct HealthAvatar: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "multiply")
                    .font(.title)
                    .onTapGesture {
                        self.mode.wrappedValue.dismiss()
                    }
            }
            ScrollView {
                VStack(spacing: 20) {
                    HStack(alignment: .center) {
                        Text("헬스아바타")
                            .bold()
                            .foregroundColor(darkBrown)
                            .font(.title2)
                        Text("는 어떤 서비스 인가요?")
                            .bold()
                            .foregroundColor(darkBrown)
                            .font(.title3)
                    }
                    Image("about_health_avatar1")
                        .resizable()
                        .frame(width: 250, height: 250)
                    Text("헬스아바타는 여러 병원에 흩어져있는 내 진료기록을 내 스마트폰에 저장하여, 인공지능 앱이 관리 할 수 있도록 돕습니다.")
                        .bold()
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 50)
                
                
                VStack(spacing: 20) {
                    HStack(alignment: .center) {
                        Text("콩팥콩팥")
                            .bold()
                            .foregroundColor(darkBrown)
                            .font(.title2)
                        Text("은 어떤 서비스 인가요?")
                            .bold()
                            .foregroundColor(darkBrown)
                            .font(.title3)
                    }
                    Image("about_health_avatar2")
                        .resizable()
                        .frame(width: 250, height: 110)
                    Text("아바타빈즈는 재활치료 환자의 건강관리를 돕는 헬스아바타의 두 번째 서비스입니다. \n재활치료에 중요한 지표와 건강기록들을 체계적으로 관리하고, 내상황에 맞는 맞춤형 서비스를 제공받는 재활 특화 에이전트를 사용해보실 수 있습니다.")
                        .bold()
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
    }
}

struct HealthAvatar_Previews: PreviewProvider {
    static var previews: some View {
        HealthAvatar()
    }
}
