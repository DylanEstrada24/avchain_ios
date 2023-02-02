//
//  TargetSetting.swift
//  avchain
//

import SwiftUI

struct TargetSetting: View {
    @State var toggle1On = false // 알람 toggle
    @State var saveBtn = false // 저장버튼 toggle
    @State var time = Date() // 8주 코칭 시간
    @State var high = "" // 혈압 수축기
    @State var low = "" // 혈압 이완기
    @State var weight = "" // 체중
    @State var bloodsugar = "" // 혈당
    @State var calorie = "" // 하루 섭취 칼로리
    @State var protein = "" // 단백질
    @State var carbohydrate = "" // 탄수화물
    @State var fat = "" // 지방
    @State var potassium = "" // 칼륨
    @State var phosphorus = "" // 인
    @State var calcium = "" // 칼슘
    @State var sodium = "" // 나트륨
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    
    let userNotification = UNUserNotificationCenter.current()
    
    // 저장 및 복양알람 설정 기능 빠져있음 ... JY
    
    private func getData() {
        // 목표 조회
        do {
            let data = ABSQLite.select(" * ", table: " SelfGoal ")
            
            if data.count > 0 {
                var category = ""

                for item in data {
                    category = item["category"]! as! String
                    var v = item["target"]! as! Int32
                    switch(category) {
                        case "혈압H": self.high = "\(v)"
                        case "혈압L": self.low = "\(v)"
                        case "지방": self.fat = "\(v)"
                        case "체중": self.weight = "\(v)"
                        case "탄수화물": self.carbohydrate = "\(v)"
                        case "칼륨": self.potassium = "\(v)"
                        case "칼슘": self.calcium = "\(v)"
                        case "인": self.phosphorus = "\(v)"
                        case "나트륨": self.sodium = "\(v)"
                        case "단백질": self.protein = "\(v)"
                        case "혈당": self.bloodsugar = "\(v)"
                        case "하루열량": self.calorie = "\(v)"
                        default: print("default")
                    }
                    
                }
            }
            
        } catch {
            print("자가입력 목표 조회 실패")
        }
        
        // 알람 조회
        do {
            let data = ABSQLite.select(" * ", table: " weekAlarm ")
            
            if data.count > 0 {
                self.toggle1On = data[0]["flag"]! as! String == "true" ? true : false
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                let temp = dateFormatter.date(from: "31/12/2023 " + (data[0]["hhmm"]! as! String))!
                self.time = temp
            }
            
        } catch {
            print("자가입력 목표 조회 실패")
        }
        
    }
    
    private func submit() {
        guard high.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard low.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard weight.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard bloodsugar.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard calorie.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard protein.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard carbohydrate.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard fat.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard potassium.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard phosphorus.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard calcium.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        guard sodium.isEmpty == false else { return toggleAlert(msg: "필드가 비었습니다.") }
        
        do {
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('혈압L', \(low))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('혈압H', \(high))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('체중', \(weight))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('혈당', \(bloodsugar))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('하루열량', \(calorie))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('단백질', \(protein))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('탄수화물', \(carbohydrate))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('지방', \(fat))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('칼륨', \(potassium))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('인', \(phosphorus))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('칼슘', \(calcium))")
            ABSQLite.insert("insert or replace into SelfGoal(category, target) values ('나트륨', \(sodium))")

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let time = dateFormatter.string(from: self.time)
            let flag = self.toggle1On ? "true" : "false"

            ABSQLite.insert("insert or replace into weekAlarm(week_alarm_id, hhmm, flag) values (1, '\(time)', '\(flag)')")

            addNoti()

            toggleAlert(msg: "목표를 설정했습니다.")
            
        } catch {
            toggleAlert(msg: "설정 실패")
        }
        
    }
    
    private func toggleAlert(msg: String) {
        self.showAlert = true
        self.alertMsg = msg
    }
    
    private func addNoti() {
        let content = UNMutableNotificationContent()
        content.title = "아바타빈즈"
        content.subtitle = "8주 코칭 작성알림"
        content.sound = UNNotificationSound.default
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: "weekAlarm", content: content, trigger: trigger)
        
        userNotification.removeDeliveredNotifications(withIdentifiers: ["weekAlarm"])
        userNotification.removePendingNotificationRequests(withIdentifiers: ["weekAlarm"])
        
        userNotification.add(request)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 상단 텍스트
                Group {
                    Text("만성콩팥병의 일반적인 자기관리 목표입니다.")
                        .bold()
                        .foregroundColor(darkBrown)
                        .multilineTextAlignment(.leading)
                    Text("병원 의료진이 권고한 사항에 맞추어 수정해주세요.")
                        .bold()
                        .foregroundColor(darkBrown)
                        .multilineTextAlignment(.leading)
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(height: 1)
                        .foregroundColor(.yellow)
                }
                // 상단 텍스트 끝
                Group {
                    
                    
                    Group {
                        VStack(alignment: .leading) {
                            Text("혈압 목표치 (단위 : mmHg)")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("수축기")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $high)
                                        .keyboardType(.numberPad)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("이완기")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $low)
                                        .keyboardType(.numberPad)
                                }
                            }
                            Divider()
                        }
                    }
                    
                    Group {
                        VStack(alignment: .leading) {
                            Text("체중 목표치 (단위 : kg)")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("체중")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $weight)
                                        .keyboardType(.numberPad)
                                }
                            }
                            Divider()
                        }
                    }
                    
                    Group {
                        VStack(alignment: .leading) {
                            Text("혈당 목표치 (단위 : mg/dl)")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("혈당")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $bloodsugar)
                                        .keyboardType(.numberPad)
                                }
                            }
                            Divider()
                        }
                    }
                    
                    Group {
                        VStack(alignment: .leading) {
                            Text("하루열량 목표치 (단위 : kcal)")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("하루 섭취 칼로리")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $calorie)
                                        .keyboardType(.numberPad)
                                }
                            }
                            Divider()
                        }
                    }
                    
                }
                
                Group {
                    
                    Group {
                        VStack(alignment: .leading) {
                            Text("3대영양소 균형 목표치 (단위 : %)")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("단백질")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $protein)
                                        .keyboardType(.numberPad)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("탄수화물")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $carbohydrate)
                                        .keyboardType(.numberPad)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("지방")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                        .multilineTextAlignment(.leading)
                                    TextField("입력", text: $fat)
                                        .keyboardType(.numberPad)
                                }
                            }
                        }
                        Divider()
                    }
                    
                    
                    // 섭취량 시작
                    Group {
                        VStack(alignment: .leading) {
                            Text("무기질 - 전해질 하루 섭취량 (단위 : mg)")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("칼륨")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $potassium)
                                        .keyboardType(.numberPad)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("인")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $phosphorus)
                                        .keyboardType(.numberPad)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("칼슘")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                        .multilineTextAlignment(.leading)
                                    TextField("입력", text: $calcium)
                                        .keyboardType(.numberPad)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("나트륨")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    TextField("입력", text: $sodium)
                                        .keyboardType(.numberPad)
                                }
                            }
                        }
                        Divider()
                    }
                    // 섭취량 끝
                    
                    Divider().background(Color.black)
                    
                    // 알람 시작
                    Group {
                        HStack(alignment: .firstTextBaseline) {
                            Toggle(isOn: self.$toggle1On) {
                                VStack(alignment: .leading) {
                                    Text("8주 코칭 알람")
                                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                            }
                        }
                        Divider()
                    }
                    // 알람 끝
                    Divider().background(Color.black)
                    
                }
                
                
                // 버튼부분 시작
                Group {
                    VStack(alignment: .leading) {
                        Text("복약 알람을 설정하실 수 있습니다.")
                        NavigationLink(destination: MedicationAlarm()) {
                            Text("복약알람 설정")
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth:.infinity, maxHeight: .none)
                                .background(
                                    Color(red: 223/255, green: 223/255, blue: 223/255)
                                )
                                .cornerRadius(25)
                        }
                        
                        DashedLine()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .frame(height: 1)
                            .foregroundColor(.yellow)
                            .padding(.bottom)
                    }
                }
                // 버튼부분 끝
                
                Group {
                    Text("저장하기")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth:.infinity, maxHeight: .none)
                        .background(
                            Color.yellow
                        )
                        .cornerRadius(25)
                        .font(.system(size: 20, weight: .bold))
                        .onTapGesture {
                            submit()
                        }
                        .padding(.bottom,10)
                }
                
                Spacer()
            }
            .padding(.horizontal, 10.0)
            
        }
        .onAppear {
            getData()
        }
        
    }
}


struct TargetSetting_Previews: PreviewProvider {
    static var previews: some View {
        TargetSetting()
    }
}
