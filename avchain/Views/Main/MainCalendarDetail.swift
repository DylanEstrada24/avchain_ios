//
//  PHRDetail.swift
//  avchain
//

import SwiftUI

struct MainCalendarDetail: View {
//    @State var dateVisible: Bool = true // 상단의 날짜 선택기능, Binding으로 변경해야할듯
    @State var date: Date = Date() // 파라미터로 값 받아와야함 (선택날짜 값 확인)
    @State private var expandedIndex: Int? = nil
    @State var title: String?
    
    // 샘플값
    // 리스트 불러온 뒤 dict 만들면 될듯?
    private let sections = [
        AccordionItem(title: "보령바이오아스트릭스캡슐100밀리그램(아스피린장용과립)_(0.1g/1캡슐)", number: "1", subTitle: ["처방", "기간", "출처"], content: ["", "2022.06.20 ~ 2022.07.18", "테스트병원"]),
        AccordionItem(title: "트라젠타정(리나글립틴)_(5mg/1정)", number: "1", subTitle: ["처방", "기간", "출처"], content: ["", "2022.06.20 ~ 2022.07.18", "테스트병원"])
    ]
    
    var body: some View {
        VStack {
            DatePicker(selection: $date, displayedComponents: .date) {
                Image("icon_calendar")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Divider()
                .padding(.vertical)
//              Text("Expanded index: \((expandedIndex == nil) ? "none" : "\(expandedIndex!)")") // 인자로 받아온 title 사용하면됨
            Text("처방약")
                .bold()
                .foregroundColor(darkBrown)
                .font(.title2)
            Divider()
            ScrollView {
                AccordionView(
                    expandedIndex: $expandedIndex,
                    sectionCount: sections.count,
                    label: { index in // 통신해서 받아온 값의 제목부분 ex) ALP (코드번호/000병원)
                        HStack {
                            Text(sections[index].title)
                                .bold()
                                .foregroundColor(darkBrown)
                                .font(.headline)
                                .lineLimit(1)
                            Text("\(sections[index].number ?? "")")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(.gray)
                        }
                        
                    },
                    content: { index in
                        Divider()
                        VStack(alignment: .leading) {
                            Text(sections[index].title)
                                .bold()
                                .foregroundColor(darkBrown)
                                .font(.subheadline)
                                .padding(.bottom, 10)
                            HStack {
                                VStack(spacing: 5) {
                                    ForEach(sections[index].subTitle ?? [], id: \.self) { symbol in
                                        Text(symbol)
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                }
                                VStack(spacing: 5) {
                                    ForEach(sections[index].content ?? [], id: \.self) { content in
                                        Text(content)
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)

                        
                    })
            }
            
            Spacer()
        }
        .padding()
    }
}

struct MainCalendarDetail_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendarDetail()
    }
}
