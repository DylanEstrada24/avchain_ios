//
//  MainCalendar.swift
//  avchain
//

import SwiftUI

struct MainCalendar: View {
    
    @State var cm = CalendarManager(mode: .Month,
                                    startDate: .startDefault,
                                    endDate: .endDefault,
                                    startPoint: .current)
    
    @State var allSelected: Bool = false // 모두 선택 (필터)
    @State var treatment: Bool = false // 진료일
    @State var testResult: Bool = false // 검사결과
    @State var cause: Bool = false // 원인/동반질환
    @State var weight: Bool = false // 체중/혈압/혈당
    @State var rehabilitation: Bool = false // 재활프로그램
    @State var medication: Bool = false // 복용약물
    @State var rehabilitationHistory: Bool = false // 재활이력
    @State var symptom: Bool = false // 증상
    @State var visitHistory: Bool = false // 의료기관방문기록
    
    
    var body : some View {
        VStack {
            ScrollView{
                HStack {
                    Button("오늘") {
                        cm = CalendarManager(mode: .Month,
                                             startDate: .startDefault,
                                             endDate: .endDefault,
                                             startPoint: .current)
                    }
                    .buttonStyle(NormalButtonStyle(labelColor: .black, backgroundColor: lightYellow))
    //                .border(.gray)
                    .background(lightYellow.shadow(radius: 2))
                    
                    Spacer()
                }
                .navigationBarHidden(true)
                .padding(.top, 10)
                JHCalendar(cellHeight:60){ component in
                    DefaultCalendarCell(component: component)
                }
                .customWeekdaySymbols(symbols: ["일", "월", "화", "수", "목", "금", "토"])
                .showTitle(show: true)
                .showWeekBar(show: true)
                .environmentObject(cm)
                
                HStack {
                    Toggle("", isOn: $allSelected)
                        .toggleStyle(ToggleSquareCheckbox(color: .blue))
                        .font(.title)
                    Text("모두 선택 (필터)")
                        .font(.caption)
                        .onTapGesture {
                            self.allSelected.toggle()
                        }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .onChange(of: allSelected) { newValue in
                    self.treatment = newValue
                    self.testResult = newValue
                    self.cause = newValue
                    self.weight = newValue
                    self.rehabilitation = newValue
                    self.rehabilitationHistory = newValue
                    self.medication = newValue
                    self.symptom = newValue
                    self.visitHistory = newValue
                }
                Divider()
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        Toggle("", isOn: $treatment)
                            .toggleStyle(ToggleSquareCheckbox(color: .mint))
                            .font(.title)
                        Text("진료일")
                            .font(.caption)
                            .onTapGesture {
                                self.treatment.toggle()
                            }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $testResult)
                                    .toggleStyle(ToggleSquareCheckbox(color: .brown))
                                    .font(.title)
                                Text("검사결과")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.testResult.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $cause)
                                    .toggleStyle(ToggleSquareCheckbox(color: .red))
                                    .font(.title)
                                Text("원인/동반질환")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.cause.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $weight)
                                    .toggleStyle(ToggleSquareCheckbox(color: .yellow))
                                    .font(.title)
                                Text("체중/혈압/혈당")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.weight.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $rehabilitation)
                                    .toggleStyle(ToggleSquareCheckbox(color: .cyan))
                                    .font(.title)
                                Text("재활프로그램")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.rehabilitation.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $medication)
                                    .toggleStyle(ToggleSquareCheckbox(color: .green))
                                    .font(.title)
                                Text("복용약물")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.medication.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $rehabilitationHistory)
                                    .toggleStyle(ToggleSquareCheckbox(color: .orange))
                                    .font(.title)
                                Text("재활이력")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.rehabilitationHistory.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $symptom)
                                    .toggleStyle(ToggleSquareCheckbox(color: .purple))
                                    .font(.title)
                                Text("증상")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.symptom.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("", isOn: $visitHistory)
                                    .toggleStyle(ToggleSquareCheckbox(color: .gray))
                                    .font(.title)
                                Text("의료기관방문기록")
                                    .font(.caption)
                                    .onTapGesture {
                                        self.visitHistory.toggle()
                                    }
                                Spacer()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .padding(.horizontal,5)
        .padding(.bottom,25)
        Spacer()
    }
}

struct MainCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendar()
    }
}
