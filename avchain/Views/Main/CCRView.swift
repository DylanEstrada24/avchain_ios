//
//  CCR.swift
//  avchain
//

import SwiftUI

//의료진 테마에서 동작하는 화면인것으로 보임...
struct CCRView: View {
    @State var cnt = 0
    
    struct CCRItem: Hashable {
        let title: String
        let date: String // YYYY-MM-DD
    }
    
    let CCRItems: [CCRItem] = [
        CCRItem(title: "테스트병원/신장내과 - 건강정보(1건)가 전달되었습니다", date: "2022-06-29"),
        CCRItem(title: "테스트병원/신장내과 - 건강정보(1건)가 전달되었습니다", date: "2022-06-29"),
        CCRItem(title: "테스트병원/신장내과 - 건강정보(1건)가 전달되었습니다", date: "2022-06-29"),
        CCRItem(title: "테스트병원/신장내과 - 건강정보(1건)가 전달되었습니다", date: "2022-06-29")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("설문처방 작성요청대기 건수 : \(self.cnt)개")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.white)
                }
                .frame(width: .infinity, height: 50)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(darkBrown)
                .cornerRadius(5)
                .padding(.bottom)
                
                ForEach(CCRItems, id: \.self) { item in
                    VStack(alignment: .leading) {
                        HStack(spacing: 2) {
                            // 읽지않음 처리해야할듯 ?
                            Image(systemName: "n.square.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.yellow)
                                
                            Text(item.title)
                                .bold()
                                .font(.caption)
                        }
                        Text(item.date)
                            .bold()
                            .font(.caption)
                            .foregroundColor(.gray)
                        Divider()
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }

    }
}

struct CCR_Previews: PreviewProvider {
    static var previews: some View {
        CCRView()
    }
}
