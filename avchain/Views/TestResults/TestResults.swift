//
//  TestResults.swift
//  avchain
//

import SwiftUI
import DGCharts



//미사용페이지

struct TestResults: View {
    @State var category = ["검사결과", "오늘건강"]
    @State var selected = "검사결과"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    func getData() {
        
        
    }
    
    var body: some View {
        VStack {
            // 카테고리 시작
            Group {
                HStack {
                    ForEach(category, id: \.self) { str in
                        Spacer()
                        VStack {
                            Button(str) {
                                print(str)
                                self.selected = str
                            }
                                .foregroundColor(.brown)
                        }
                        .padding(.bottom, 10)
                        .overlay(
                            self.selected == str ? Group {
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.yellow)
                                }
                            } : nil
                        )
                    }
                    Spacer()
                    Button("닫기") {
                        self.mode.wrappedValue.dismiss()
                    }
                    .buttonStyle(NormalButtonStyle(labelColor: white, backgroundColor: darkBrown))
                }
                .padding(.vertical)
                .padding(.horizontal)
            }
            // 카테고리 끝
            
            switch(selected) {
                case "검사결과":
                    TestResultsList()
                case "오늘건강":
                    TodaysHealth()
                default:
                    emptySpace()
            }
            
            Spacer()
        }
    }
}

struct TestResultsList: View {
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    Text("검사수치로 보는 식단 관리")
                        .bold()
                        .foregroundColor(darkBrown)
                        .font(.title3)
                    VStack {
                        HStack {
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "칼륨")])
                                .frame(height: 200)
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "인  ")])
                                .frame(height: 200)
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "빈혈")])
                                .frame(height: 200)
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "칼슘")])
                                .frame(height: 200)
                        }
                        HStack {
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "요산")])
                                .frame(height: 200)
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "부갑상선호르몬")])
                                .frame(height: 200)
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "투석간체중증가")])
                                .frame(height: 200)
                        }
                    }
                    .padding()
                    .border(Color(white: 0.8))
                    .background(Color.white
                        .shadow(radius: 2)
                    )
                    
                    DashedLine()
                       .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                       .frame(height: 1)
                       .foregroundColor(.yellow)
                       .padding(.vertical)
                }
                // 그래프별 값 및 주의점들 시작 - ForEach? 하나씩 노가다?
                Group {
                    VStack {
                        Text("칼륨")
                            .bold()
                            .foregroundColor(darkBrown)
                            .font(.body)
                        Text("2022-01-01")
                            .bold()
                            .font(.caption)
                        HStack(alignment: .center) {
                            Text("4.5 > ") // value 넣어야할듯
                                .bold()
                                .font(.caption)
                                .foregroundColor(.green)
                                .frame(width: 80)
                            PieChart(entries: [PieChartDataEntry(value: 10.0, label: "칼륨")])
                                .frame(height: 150)
                                .foregroundColor(.black)
                            VStack {
                                Text("정상범위")
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text("3.5 ~ 5.5") // 값 바꿔야함
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .frame(width: 80)
                        }
                        
                        DashedLine()
                           .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                           .frame(height: 1)
                           .foregroundColor(.yellow)
                           .padding(.vertical)
                        
                        Text("")
                        
                    }
                    .padding()
                    .border(Color(white: 0.8))
                    .background(Color.white
                        .shadow(radius: 2)
                    )
                }
                // 그래프별 값 및 주의점들 끝
            }
            .padding(.horizontal)
        }
    }
}

struct TodaysHealth: View {
    
    // 그래프 용, 일반 사용자는 노출안됨
    @State var potassium = 4.5 // 칼륨
    @State var phosphorus = 4.5 // 인
    @State var anemia = 4.5 // 빈혈
    @State var calcium = 4.5 // 칼슘
    @State var sodium = 1.4 // 나트륨
    // 테스트용, 화면 그리기 및 확인 용도
    @State var temp = 0 // 0 = 일반사용자, 1 = 병원에서 데이터 받기 전, 2 = 데이터 받은 후
    
    // 그래프 그리는용도, 값 바꿔야함 ... JY
    var entries = [
        PieChartDataEntry(value: 10.0, label: "단백질(제시목표)"),
        PieChartDataEntry(value: 65.0, label: "탄수화물(제시목표)"),
        PieChartDataEntry(value: 25.0, label: "지방(제시목표)")
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    VStack (alignment: .leading) {
                        Text("음식")
                            .font(.system(size: 20))
                            .foregroundColor(.brown)
                            .fontWeight(.bold)
                        Text("489 kcal")
                            .font(.system(size: 20))
                            .foregroundColor(.brown)
                            .fontWeight(.bold)
                        HStack {
                            Spacer()
                            Button("+목표") {
                                // Selfinputs로 이동?? ... JY
                            }
                                .buttonStyle(NormalButtonStyle(labelColor: darkBrown, backgroundColor: lightYellow))
                            Button("음식추가") {
                                // Selfinputs로 이동?? ... JY
                            }
                                .buttonStyle(NormalButtonStyle(labelColor: darkBrown, backgroundColor: lightYellow))
                        }
                        
                        Text("3대영양소")
                            .font(.system(size: 20))
                            .foregroundColor(.brown)
                            .fontWeight(.bold)
                        PieChart(entries: entries)
                            .frame(height: 200)
                        Group {
                            VStack(alignment: .leading) {
                                Text("칼륨")
                                    .foregroundColor(.brown)
                                    .fontWeight(.bold)
                                HStack {
                                    Text("0 mg")
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    Text("+목표")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("%")
                                }
                                // 칼륨 200% 일때의 값 구해야함! -> total 값 변경
                                ProgressView(value: potassium, total: 100) {
                                    Text("")
                                }
                                HStack(alignment: .top) {
                                    Spacer()
                                    Text("100% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    Spacer()
                                    Text("200% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                        }
                        Group {
                            VStack(alignment: .leading) {
                                Text("나트륨")
                                    .foregroundColor(.brown)
                                    .fontWeight(.bold)
                                HStack {
                                    Text("0 mg")
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    Text("+목표")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("%")
                                }
                                // 나트륨 200% 일때의 값 구해야함! -> total 값 변경
                                ProgressView(value: sodium, total: 100) {
                                    Text("")
                                }
                                HStack(alignment: .top) {
                                    Spacer()
                                    Text("100% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    Spacer()
                                    Text("200% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                        }
                        Group {
                            VStack(alignment: .leading) {
                                Text("인")
                                    .foregroundColor(.brown)
                                    .fontWeight(.bold)
                                HStack {
                                    Text("0 mg")
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    Text("+목표")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("%")
                                }
                                // 인 200% 일때의 값 구해야함! -> total 값 변경
                                ProgressView(value: phosphorus, total: 100) {
                                    Text("")
                                }
                                HStack(alignment: .top) {
                                    Spacer()
                                    Text("100% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    Spacer()
                                    Text("200% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                        }
                        Group {
                            VStack(alignment: .leading) {
                                Text("칼슘")
                                    .foregroundColor(.brown)
                                    .fontWeight(.bold)
                                HStack {
                                    Text("0 mg")
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    Text("+목표")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("%")
                                }
                                // 칼슘 200% 일때의 값 구해야함! -> total 값 변경
                                ProgressView(value: calcium, total: 100) {
                                    Text("")
                                }
                                HStack(alignment: .top) {
                                    Spacer()
                                    Text("100% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    Spacer()
                                    Text("200% |")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color(white: 0.8))
                    .background(Color.white
                        .shadow(radius: 2)
                    )
                }
                // 하단에 어떤 항목이 더 있는지 모르겟음!!!
            }
            .padding(.horizontal)
        }
    }
}

struct TestResults_Previews: PreviewProvider {
    static var previews: some View {
        TestResults()
    }
}
