//
//  EightWeeksDaily.swift
//  avchain
//

import SwiftUI

struct EightWeeksDaily: View {
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var weight = "" // 체중
    @State var high = "" // 최고혈압
    @State var low = "" // 최저혈압
    @State var time = "" // 수면시간
    @State var selected: Int = -1 // 수면상태 설정
    @State var smoke: Int = -1 // 흡연
    @State var drink: Int = -1 // 음주
    @State var items1 :[String] = ["아주 잘 잠","잘 잠","잘 못 잠"]
    @State var items2 :[String] = ["거의 못 잠"]
    @State var target: [String] = ["예","아니오"]
    @State var stressTarget1 :[String] = ["1","2","3","4"]
    @State var stressTarget2 :[String] = ["5(심함)"]
    @State var painTarget1 :[String] = ["무통증","가벼운 통증","많이 아픔"]
    @State var painTarget2 :[String] = ["도저히 못 견디게 아픔"]
    @State var edema: Int = -1 // 부종
    @State var dyspnoea: Int = -1 // 호흡곤란
    @State var foamyUrine: Int = -1 // 거품뇨
    @State var constipation: Int = -1 // 변비
    @State var stress: Int = -1 // 스트레스
    @State var pain: Int = -1 // 아픈정도
    
    private func submit() {
        // 저장
    }
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                // 상단 텍스트
                Group {
                    Text("안녕하세요~")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                        .frame(width: nil)
                    Text("오늘은 6월 9(+1)일입니다.")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                    Text("출석체크로 어제 6월 8일 '나의 건강' 수치를 입력해주세요.")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                    
                    Text("어제 6월 8일(수) 나의 건강")
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                    Text("(어제날짜에 입력값이 있으면 표시합니다.)")
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                    
                    DashedLine()
                       .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                       .frame(height: 1)
                       .foregroundColor(.yellow)
                }
                // 상단 텍스트 끝
                ScrollView {
                    
                    
                    VStack(alignment: .leading) {
                        
                        
                        // 입력 영역
                        Group {
                            Group {
                                // 체중 시작
                                Group {
                                    HStack {
                                        Text("체중")
                                            .frame(width: 100, alignment: .leading)
                                        VStack(alignment: .leading) {
                                            Text("입력")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                            Group {
                                                TextField("체중", text: $weight)
                                                    .frame(width: 60)
                                                Divider()
                                                    .frame(width: 60)
                                            }
                                            .offset(y: -5)
                                        }
                                        Text("kg")
                                    }
                                    .padding(.horizontal)
                                    
                                    DashedLine()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .frame(height: 1)
                                        .foregroundColor(.yellow)
                                }
                                // 체중 끝
                                
                                // 혈압 시작
                                Group {
                                    HStack {
                                        Text("혈압")
                                            .frame(width: 100, alignment: .leading)
                                        VStack(alignment: .leading) {
                                            Text("120")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                            Group {
                                                TextField("최고", text: $high)
                                                    .frame(width: 60)
                                                Divider()
                                                    .frame(width: 60)
                                            }
                                            .offset(y: -5)
                                        }
                                        Text("/")
                                        VStack(alignment: .leading) {
                                            Text("80")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                            Group {
                                                TextField("최저", text: $low)
                                                    .frame(width: 40)
                                                Divider()
                                                    .frame(width: 40)
                                            }
                                            .offset(y: -5)
                                        }
                                        Text("mmHg")
                                        
                                    }
                                    .padding(.horizontal)
                                    
                                    DashedLine()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .frame(height: 1)
                                        .foregroundColor(.yellow)
                                }
                                // 혈압 끝
                                
                                // 수면상태 시작
                                Group {
                                    HStack {
                                        Text("수면상태")
                                            .frame(width: 100, alignment: .leading)
                                        VStack(alignment: .leading) {
                                            Text("입력")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                            Group {
                                                TextField("시간", text: $time)
                                                    .frame(width: 60)
                                                Divider()
                                                    .frame(width: 60)
                                            }
                                            .offset(y: -5)
                                        }
                                        Text("시간")
                                    }
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Spacer()
                                            .frame(width: 100)
                                        VStack(alignment: .leading) {
                                            HStack {
                                                ForEach(Array(items1.enumerated()), id: \.offset) { idx, item in
                                                    CustomRadioButton(
                                                        title: item,
                                                        id:idx,
                                                        callback: { selected in
                                                            self.selected = selected
                                                            print("\(selected)")
                                                        },
                                                        selectedID: self.selected
                                                    )
                                                    
                                                    //버튼 설정
                                                }
                                            }
                                            HStack {
                                                ForEach(Array(items2.enumerated()), id: \.offset) { idx, item in
                                                    CustomRadioButton(
                                                        title: item,
                                                        id:idx + 3,
                                                        callback: { selected in
                                                            self.selected = selected
                                                            print("\(selected)")
                                                        },
                                                        selectedID: self.selected
                                                    )
                                                    
                                                    //버튼 설정
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                    DashedLine()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .frame(height: 1)
                                        .foregroundColor(.yellow)
                                }
                                // 수면상태 끝
                                
                                Group {
                                    HStack {
                                        Text("흡연")
                                            .frame(width: 100, alignment: .leading)
                                        HStack {
                                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                                CustomRadioButton(
                                                    title: item,
                                                    id:idx,
                                                    callback: { selected in
                                                        self.smoke = selected
                                                        print("\(selected)")
                                                    },
                                                    selectedID: self.smoke
                                                )
                                            }
                                        }
                                    }
                                    .padding()
                                    
                                    DashedLine()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .frame(height: 1)
                                        .foregroundColor(.yellow)
                                }
                                
                                Group {
                                    HStack {
                                        Text("음주")
                                            .frame(width: 100, alignment: .leading)
                                        HStack {
                                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                                CustomRadioButton(
                                                    title: item,
                                                    id:idx,
                                                    callback: { selected in
                                                        self.drink = selected
                                                        print("\(selected)")
                                                    },
                                                    selectedID: self.drink
                                                )
                                            }
                                        }
                                    }
                                    .padding()
                                    
                                    DashedLine()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .frame(height: 1)
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            inputArea
                            
                            // 저장하기
                            Group {
                                Button("저장하기") {
                                    //                        next()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .background(.yellow)
                                .cornerRadius(100)
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold))
                                .padding(.vertical)
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text(alertMsg), dismissButton: .default(Text("확인")))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
            }
            .padding(.horizontal, 10.0)
        }
        
        
    }
    
    var inputArea: some View {
        Group {
            Text("증상입력")
                .bold()
                .font(.title)
            // 수면상태
            Group {
                
                Group {
                    HStack {
                        Text("부종")
                            .frame(width: 100, alignment: .leading)
                        HStack {
                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                CustomRadioButton(
                                    title: item,
                                    id:idx,
                                    callback: { selected in
                                        self.edema = selected
                                        print("\(selected)")
                                    },
                                    selectedID: self.edema
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding()
                    
                }
                
                Group {
                    HStack {
                        Text("호흡곤란")
                            .frame(width: 100, alignment: .leading)
                        HStack {
                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                CustomRadioButton(
                                    title: item,
                                    id:idx,
                                    callback: { selected in
                                        self.dyspnoea = selected
                                        print("\(selected)")
                                    },
                                    selectedID: self.dyspnoea
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding()
                    
                }
                
            }
            Group {
                
                Group {
                    HStack {
                        Text("거품뇨")
                            .frame(width: 100, alignment: .leading)
                        HStack {
                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                CustomRadioButton(
                                    title: item,
                                    id:idx,
                                    callback: { selected in
                                        self.foamyUrine = selected
                                        print("\(selected)")
                                    },
                                    selectedID: self.foamyUrine
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding()
                    
                }
                
                Group {
                    HStack {
                        Text("변비")
                            .frame(width: 100, alignment: .leading)
                        HStack {
                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                CustomRadioButton(
                                    title: item,
                                    id:idx,
                                    callback: { selected in
                                        self.constipation = selected
                                        print("\(selected)")
                                    },
                                    selectedID: self.constipation
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding()
                    
                }
                
            }
            
            Group {
                
                Group {
                    HStack {
                        Text("스트레스")
                            .frame(width: 100, alignment: .leading)
                        VStack(alignment: .leading) {
                            HStack {
                                ForEach(Array(stressTarget1.enumerated()), id: \.offset) { idx, item in
                                    CustomRadioButton(
                                        title: item,
                                        id:idx,
                                        callback: { selected in
                                            self.stress = selected
                                            print("\(selected)")
                                        },
                                        selectedID: self.stress
                                    )
                                }
                            }
                            HStack {
                                ForEach(Array(stressTarget2.enumerated()), id: \.offset) { idx, item in
                                    CustomRadioButton(
                                        title: item,
                                        id:idx + 4,
                                        callback: { selected in
                                            self.stress = selected
                                            print("\(selected)")
                                        },
                                        selectedID: self.stress
                                    )
                                }
                            }
                        }
                        
                    }
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                    
                    DashedLine()
                       .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                       .frame(height: 1)
                       .foregroundColor(.gray)
                       .padding()
                    
                }
                
                Group {
                    HStack {
                        Text("아픈정도")
                            .frame(width: 100, alignment: .leading)
                        VStack(alignment: .leading) {
                            HStack {
                                ForEach(Array(painTarget1.enumerated()), id: \.offset) { idx, item in
                                    CustomRadioButton(
                                        title: item,
                                        id:idx,
                                        callback: { selected in
                                            self.pain = selected
                                            print("\(selected)")
                                        },
                                        selectedID: self.pain
                                    )
                                }
                            }
                            HStack {
                                ForEach(Array(painTarget2.enumerated()), id: \.offset) { idx, item in
                                    CustomRadioButton(
                                        title: item,
                                        id:idx + 4,
                                        callback: { selected in
                                            self.pain = selected
                                            print("\(selected)")
                                        },
                                        selectedID: self.pain
                                    )
                                }
                            }
                        }
                    }
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                    
                    DashedLine()
                       .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                       .frame(height: 1)
                       .foregroundColor(.gray)
                       .padding()
                    
                }
            }
        }
    }
}

struct EightWeeksDaily_Previews: PreviewProvider {
    static var previews: some View {
        EightWeeksDaily()
    }
}
