//
//  Attendance.swift
//  avchain
//

import SwiftUI

struct Attendance: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var settings: UserSettings
    
    @State var date = Date() // 현재날짜 -> AttendanceItem2 에만 들어감
    
    @State var score: Int = 0
    
    @State var attendanceList: [String] = []
    @State var scoreList: [String] = []
    
    // 중요!! 출첵 로직 짜야함!!!!! ... JY
    
    @State var todayCheck = ""
    
    private func setData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d(E)"
        
        for i in 0 ..< 7 {
            let d = Calendar.current.date(byAdding: .day, value: (i - 6), to: self.date)
            print(d)
            
            let param = KoreanDate.dateParamFormat.string(from: d!)
            attendanceList.append(formatter.string(from: d!))
            do {
                let data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " myPoint where yyyymmdd = '\(param)' ")
                
                if data.count > 0 {
                    let sc: Int = Int(data[0]["flag"]! as! String) ?? 0
                    scoreList.append(String(sc))
                    self.score = self.score + sc
                } else {
                    scoreList.append("0")
                }
            } catch {
                print("포인트 조회 실패")
            }
            
        }
        
        self.todayCheck = scoreList[6]
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView{
                Group {
                    Text("출첵하고 건강포인트 1점 받자!")
                        .bold()
                        .foregroundColor(darkBrown)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    
                    if attendanceList.count > 0 && scoreList.count > 0 {
                        Group {
                            HStack {
                                AttendanceItem(date: attendanceList[0], number: scoreList[0])
                                AttendanceItem(date: attendanceList[1], number: scoreList[1])
                                AttendanceItem(date: attendanceList[2], number: scoreList[2])
                            }
                            HStack {
                                AttendanceItem(date: attendanceList[3], number: scoreList[3])
                                AttendanceItem(date: attendanceList[4], number: scoreList[4])
                                AttendanceItem(date: attendanceList[5], number: scoreList[5])
                            }
                            HStack {
                                AttendanceItem2(date: attendanceList[6], number: scoreList[6])
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("GO!")
                                            .font(.largeTitle)
                                            .bold()
                                            .foregroundColor(darkBrown)
                                        Spacer()
                                    }
                                }
                                .frame(width: .infinity, height: 160)
                                .padding()
                                .border(Color(white: 0.8))
                                .background(Color(red: 117 / 255, green: 251 / 255, blue: 253 / 255)
                                    .shadow(radius: 2))
                                .onTapGesture {
                                    // 일일작성 화면으로 이동!
                                    settings.screen = AnyView(DailyHealthInput(todayCheck: self.todayCheck))
                                }
                            }
                        }
    //                    Text("\(str)")
                        Text("나의 현재 출첵점수 : \(score)점")
                            .bold()
                            .font(.title2)
                            .foregroundColor(darkBrown)
                        
                        Text("간단한 자가입력 기입을 하면 건강포인트 1점을 드립니다.")
                            .font(.title3)
                            .foregroundColor(darkBrown)
                        
                        Text("취소")
                            .frame(maxWidth: .infinity)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .background(.yellow)
                            .cornerRadius(100)
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical)
                            .onTapGesture {
//                                self.mode.wrappedValue.dismiss()
                                UserDefaults.standard.setValue("true", forKey: "isShowDailyCheck")
                                settings.screen = AnyView(EightWeeksMain())
                            }
                    }
                }
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .onAppear {
            setData()
        }
    }
}

struct AttendanceItem: View {
    var date: String // 6/3(금) 형태로
    var number: String // 빨간배경 숫자
    var body: some View {
        VStack {
            HStack {
                Text(date)
                    .bold()
                    .font(.title3)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Text(number) // 점수?
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                    .background(.red)
                    .cornerRadius(5)
                    .foregroundColor(.white)
                    
            }
        }
        .frame(width: .infinity, height: 80)
        .padding()
        .border(Color(white: 0.8))
        .background(Color.white
            .shadow(radius: 2))
    }
}

struct AttendanceItem2: View { // 최하단에 들어가는 큰 박스
    var date: String // 6/3(금) 형태로
    var number: String // 빨간배경 숫자
    var body: some View {
        VStack {
            HStack {
                Text(date)
                    .bold()
                    .font(.title3)
                Spacer()
            }
            HStack {
                Image("trophy")
                    .resizable()
                    .frame(width: 70.0, height: 70.0)
                    .padding(.leading)
                Spacer()
            }
            HStack(alignment: .bottom) {
                Spacer()
                Text(number) // 점수?
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                    .background(.red)
                    .cornerRadius(5)
                    .foregroundColor(.white)
                    
            }
        }
        .frame(width: .infinity, height: 160)
        .padding()
        .border(Color(white: 0.8))
        .background(Color.yellow
            .shadow(radius: 2))
    }
}


struct Attendance_Previews: PreviewProvider {
    static var previews: some View {
        Attendance()
    }
}
