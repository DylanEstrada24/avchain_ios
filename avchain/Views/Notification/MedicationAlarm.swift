//
//  MedicationAlarm.swift
//  avchain
//

import SwiftUI
import UserNotifications

struct MedicationAlarm: View {
    @State var category = ["복약알람", "복약여부"]
    @State var selected = "복약알람"
    @State var showing = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
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
                    Button("추가") {
                        self.showing = true
                    }
                    .buttonStyle(NormalButtonStyle(labelColor: white, backgroundColor: darkBrown))
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
                case "복약알람":
                    MedicationAlarmList(showing: $showing)
                case "복약여부":
                    MedicationCheck(showing: $showing)
                default:
                    emptySpace()
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct MedicationAlarmList: View {
    
    // 알람 리스트 -> DB에서 가져옴
    // drugAlarm = alarm_id, notification_id, drug_name, week, yyyymmdd, ampm, hhmm, flag
    @State var list: [Dictionary<AnyHashable, Any>] = []
    @Binding var showing: Bool // 추가버튼 시 보일것들
    var days = ["일", "월", "화", "수", "목", "금", "토"]
    var week = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    @State var selected: [String] = []
    @State var pickerSelected = AlarmTime(ampm: .AM, time: "05:00", label: "오전 5시")
    @State var mediName = ""
    
//    @Published var isToggleOn: Bool = UserDefaults.standard.bool(forKey: "hasUserAgreedNoti") {
//        didSet {
//            if isToggleOn {
//                UserDefaults.standard.set(true, forKey: "hasUserAgreedNoti")
//                requestNotiAuthorization()
//            } else {
//                UserDefaults.standard.set(false, forKey: "hasUserAgreedNoti")
//                removeAllNotification()
//            }
//        }
//    }
    
    private func getData() {
        
        self.list = []
        
        do {
            let list = ABSQLite.select(" * ", table: " drugAlarm order by alarm_id desc ")
            
            if list.count > 0 {
                self.list = list
            }
            
        } catch {
            print("알람 정보 조회 실패")
        }
    }
    
    private func daySelect(day: String) {
        var flag = false
        self.selected.map {
            if $0 == day {
                flag = true
            }
        }
        
        if flag {
            self.selected = self.selected.filter {
                $0 != day
            }
        } else {
            self.selected.append(day)
        }
    }
    
    private func addAlarm() {
        guard selected.count != 0 else { return }
        guard !mediName.isEmpty else { return }
        
        do {
            
            let date = Date()
            
            let notificationId = KoreanDate.dbDateFormat.string(from: date)
            let yyyymmdd = KoreanDate.dateParamFormat.string(from: date)
            let week = selected.joined(separator: ",")
            
            ABSQLite.insert("insert into drugAlarm(notification_id, drug_name, week, yyyymmdd, ampm, hhmm, flag) values('\(notificationId)', '\(mediName)', '\(week)', '\(yyyymmdd)', '\(pickerSelected.ampm)', '\(pickerSelected.time)', 'true')")
            
            print("알람 추가 성공 !!")
            
            self.getData() // -> append하면 alarm_id를 못가져옴, 로컬db 한번더 통신하는걸로
            
            self.selected = []
            self.mediName = ""
            self.showing = false
            
        } catch {
            print("알람 추가 실패")
        }
        
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if showing {
                    HStack {
                        ForEach(0 ..< 4) { item in
                            Button("\(days[item])") {
                                daySelect(day: week[item])
                            }
                            .buttonStyle(NormalButtonStyle(labelColor: .black, backgroundColor: selected.contains(week[item]) ? .green : gray))
                        }
                    }
                    HStack {
                        ForEach(4 ..< 7) { item in
                            Button("\(days[item])") {
                                daySelect(day: week[item])
                            }
                            .buttonStyle(NormalButtonStyle(labelColor: .black, backgroundColor: selected.contains(week[item]) ? .green : gray))
                        }
                    }
                    Picker("시간 선택", selection: $pickerSelected) {
                        ForEach(AlarmTime.allAlarmTime, id: \.self) { item in
                            Text(item.label)
                        }
                    }
                    
                    HStack {
                        TextField("약품명", text: $mediName)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                    Divider()
                    
                    
                    HStack {
                        Text("취소하기")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth:.infinity, maxHeight: .none)
                            .background(
                                Color.yellow
                            )
                            .cornerRadius(25)
                            .font(.system(size: 20, weight: .bold))
                            .onTapGesture {
                                self.showing = false
                                self.selected = []
                                self.mediName = ""
                            }
                        
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
                                addAlarm()
                            }
                    }
                    
                    DashedLine()
                       .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                       .frame(height: 1)
                       .foregroundColor(.yellow)
                       .padding(.vertical)
                }
                if (self.list.isEmpty) {
                    HStack {
                        Image("icon_problem_list")
                            .resizable()
                            .frame(width: 25, height: 40)
                        Text("자료가 없습니다.")
                            .bold()
                            .font(.body)
                        Spacer()
                    }
                    Divider()
                } else {
                    ForEach(0 ..< list.count ) { i in
                        NavigationLink(destination: MedicationAlarmDetail(
                            id: list[i]["alarm_id"]! as! Int32,
                            dbWeek: list[i]["week"]! as! String,
                            pickerSelected:
                                AlarmTime(
                                    ampm: AlarmTime.ampm(rawValue: list[i]["ampm"]! as! String) ?? .AM,
                                    time: list[i]["hhmm"]! as! String,
                                    label: "\(list[i]["ampm"]! as! String == "AM" ? "오전" : "오후") \(list[i]["hhmm"]! as! String)"
                                ),
                            mediName: list[i]["drug_name"]! as! String)
                        ) {
                            MedicationAlarmItems(
                                id: list[i]["alarm_id"]! as! Int32,
                                name: list[i]["drug_name"]! as! String,
                                ampm: list[i]["ampm"]! as! String,
                                hhmm: list[i]["hhmm"]! as! String,
                                weeks: list[i]["week"]! as! String,
                                flag: list[i]["flag"]! as! String
                            )
                        }
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                getData()
            }
        }
    }
}

struct MedicationAlarmItems: View {
    
    var id: Int32
    var name: String
    var ampm: String
    var hhmm: String
    var weeks: String
    var flag: String
    
    @State var popupWipe = false // 테스트값, drugAlarm - flag 값으로 써야함
    var days = [["일", "sun"], ["월", "mon"], ["화", "tue"], ["수", "wed"], ["목", "thu"], ["금", "fri"], ["토", "sat"]]
//    var week = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    
    private func updateToggle() {
        self.popupWipe = flag == "true" ? true : false
    }
    
    private func updateAlarm() {
        
        let flag = popupWipe ? "true" : "false"
        
        do {
            ABSQLite.update("update drugAlarm set flag = '\(flag)' where alarm_id = \(id)")
            
            print("success")
            
        } catch {
            print("알림 토글전환 실패, alarm_id ::: \(id)")
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("icon_medic")
                    .resizable()
                    .frame(width: 25, height: 40, alignment: .leading)
                VStack(alignment: .leading) {
                    Text(name) // drug_name
                        .bold()
                        .foregroundColor(.black)
                        .font(.body)
                    HStack {
                        Text("\(ampm == "AM" ? "오전" : "오후") \(hhmm)") // ampm, hhmm
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(darkBrown)
                        ForEach(days, id: \.self) { day in
                            Text(day[0])
                                .font(.system(size: 10))
                                .foregroundColor(weeks.contains(day[1]) ? .purple : .black)
                        }
                    }
                }
                Spacer()
                Toggle("", isOn: $popupWipe)
                    .frame(width: 60)
                    .onChange(of: popupWipe) { newValue in
                        updateAlarm()
                    }
            }
            Divider()
        }
        .onAppear {
            updateToggle()
        }
    }
}

struct MedicationCheck: View {
    @StateObject var cm = CalendarManager(mode: .Week,
                                    startDate: .startDefault,
                                    endDate: .endDefault,
                                    startPoint: .current)
    @State var list: [Dictionary<AnyHashable, Any>] = []
    @State var popupWipe = false // 테스트값, drugAlarm - flag 값으로 써야함
    @Binding var showing: Bool // 추가버튼 시 보일것들
    @State var selected: [String] = []
    @State var pickerSelected = AlarmTime(ampm: .AM, time: "05:00", label: "오전 5시")
    @State var mediName = ""
    var days = ["일", "월", "화", "수", "목", "금", "토"]
    
    func daySelect(day: String) {
        var flag = false
        self.selected.map {
            if $0 == day {
                flag = true
            }
        }
        
        if flag {
            self.selected = self.selected.filter {
                $0 != day
            }
        } else {
            self.selected.append(day)
        }
    }
    
    private func getData(cc: CalendarComponents) {
        
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        
        let date = "\(cc.year)-" + month + "-" + day
        let created = "\(cc.year)" + month + day + "%"
        
        do {
            let data = ABSQLite.select(" * ", table: " drugAlarmLog where yyyymmdd = '\(date)' order by alarm_log_id ")
            
            if data.count > 0 {
                print("알람로그 조회 성공")
                self.list = data
            }
        } catch {
            print("알람로그 조회 실패")
        }
    }
    
    var body: some View {
        VStack {
            // 달력
            Group {
                JHCalendar(cellHeight:60){ component in
                    DefaultCalendarCell(component: component)
                }
                .customWeekdaySymbols(symbols: ["일", "월", "화", "수", "목", "금", "토"])
                .showTitle(show: true)
                .showWeekBar(show: true)
                .environmentObject(cm)
                .onChange(of: cm.selectedComponent) {cc  in
                    self.list = []
                    getData(cc: self.cm.selectedComponent)
                }
            }
            .background(calendarPurple)
            ScrollView {
                VStack {
                    if showing {
                        HStack {
                            ForEach(0 ..< 4) { item in
                                Button("\(days[item])") {
                                    daySelect(day: days[item])
                                }
                                .buttonStyle(NormalButtonStyle(labelColor: .black, backgroundColor: selected.contains(days[item]) ? .green : gray))
                            }
                        }
                        HStack {
                            ForEach(4 ..< 7) { item in
                                Button("\(days[item])") {
                                    daySelect(day: days[item])
                                }
                                .buttonStyle(NormalButtonStyle(labelColor: .black, backgroundColor: selected.contains(days[item]) ? .green : gray))
                            }
                        }
                        Picker("시간 선택", selection: $pickerSelected) {
                            ForEach(AlarmTime.allAlarmTime, id: \.self) { item in
                                Text(item.label)
                            }
                        }
                        
                        HStack {
                            TextField("약품명", text: $mediName)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                        Divider()
                        
                        
                        HStack {
                            Text("취소하기")
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth:.infinity, maxHeight: .none)
                                .background(
                                    Color.yellow
                                )
                                .cornerRadius(25)
                                .font(.system(size: 20, weight: .bold))
                                .onTapGesture {
                                    self.showing = false
                                    self.selected = []
                                    self.mediName = ""
                                }
                            
                            Text("저장하기")
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth:.infinity, maxHeight: .none)
                                .background(
                                    Color.yellow
                                )
                                .cornerRadius(25)
                                .font(.system(size: 20, weight: .bold))
                        }
                        
                        DashedLine()
                           .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                           .frame(height: 1)
                           .foregroundColor(.yellow)
                           .padding(.vertical)
                    }
                    if (self.list.isEmpty) {
                        HStack {
                            Image("icon_problem_list")
                                .resizable()
                                .frame(width: 25, height: 40)
                            Text("자료가 없습니다.")
                                .bold()
                                .font(.body)
                            Spacer()
                        }
                        Divider()
                    } else {
                        ForEach(0 ..< list.count) { item in
                            MedicationCheckItem(
                                id: list[item]["alarm_log_id"]! as! Int32,
                                alarmId: list[item]["alarm_id"]! as! Int32,
                                name: list[item]["drug_name"]! as! String,
                                week: list[item]["week"]! as! String,
                                ampm: list[item]["ampm"]! as! String,
                                hhmm: list[item]["hhmm"]! as! String,
                                lastUpdate: list[item]["last_update"]! as! String,
                                flag: list[item]["flag"]! as! String
                            )
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct MedicationCheckItem: View {
    
    
    var id: Int32
    var alarmId: Int32
    var name: String
    var week: String
    var ampm: String
    var hhmm: String
    var lastUpdate: String
    var flag: String
    
    @State var popupWipe = false
    
    private func updateToggle() {
        self.popupWipe = flag == "true" ? true : false
    }
    
    private func updateCheck() {
        
        let flag = popupWipe ? "true" : "false"
        
        do {
            ABSQLite.update("update drugAlarmLog set flag = '\(flag)' where alarm_log_id = \(id)")
            
            print("success")
            
        } catch {
            print("복약여부 토글전환 실패, alarm_log_id ::: \(id)")
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("icon_medic")
                    .resizable()
                    .frame(width: 25, height: 40, alignment: .leading)
                    .opacity(0.2)
                VStack(alignment: .leading) {
                    Text(name) // drug_name
                        .fontWeight(.bold)
                        .font(.body)
                    HStack {
                        Text("\(ampm == "AM" ? "오전" : "오후") \(hhmm)") // ampm, hhmm
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(darkBrown)
                        Text("\(week) \(lastUpdate)")
                            .font(.system(size: 10))
                    }
                }
                Spacer()
                Toggle("", isOn: $popupWipe)
                    .frame(width: 60)
                    .onChange(of: popupWipe) { newValue in
                        updateCheck()
                    }
            }
            Divider()
        }
        .onAppear {
            updateToggle()
        }
    }
}

struct MedicationAlarm_Previews: PreviewProvider {
    static var previews: some View {
        MedicationAlarm()
    }
}
