//
//  MedicationAlarmDetail.swift
//  avchain
//

import SwiftUI

struct MedicationAlarmDetail: View {
    
    var days = ["일", "월", "화", "수", "목", "금", "토"]
    var week = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    var id: Int32
    @State var selected: [String] = []
    var dbWeek: String  // sat,mon, <- 같은 형식으로 옴
    @State var pickerSelected: AlarmTime
    @State var mediName: String
    
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
    
    private func updateAlarm() {
        guard selected.count != 0 else { return }
        guard !mediName.isEmpty else { return }
        
        do {
            
            let date = Date()
            
            let notificationId = KoreanDate.dbDateFormat.string(from: date)
            let yyyymmdd = KoreanDate.dateParamFormat.string(from: date)
            let week = selected.joined(separator: ",")
            
            ABSQLite.update("update drugAlarm set notification_id = '\(notificationId)', drug_name = '\(mediName)', week = '\(week)', yyyymmdd = '\(yyyymmdd)', ampm = '\(pickerSelected.ampm)', hhmm = '\(pickerSelected.time)', flag = 'true' where alarm_id = \(id)")
            
            print("알람 수정 성공 !!")
            
            self.mode.wrappedValue.dismiss()
            
        } catch {
            print("알람 추가 실패")
        }
        
    }
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    VStack {
                        Text("복약알람을 설정하세요.")
                            .bold()
                            .foregroundColor(.brown)
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
                Text("수정하기")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth:.infinity, maxHeight: .none)
                    .background(
                        Color.yellow
                    )
                    .cornerRadius(25)
                    .font(.system(size: 20, weight: .bold))
                    .onTapGesture {
                        updateAlarm()
                    }
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .padding(.vertical, 20)
        .onAppear {
            self.selected = dbWeek.components(separatedBy: ",")
        }
    }
}

struct MedicationAlarmDetail_Previews: PreviewProvider {
    static var previews: some View {
        MedicationAlarmDetail(id: 1, dbWeek: "sat,mon,", pickerSelected: AlarmTime(ampm: .AM, time: "05:30", label: "오전 5시 30분"), mediName: "test")
    }
}
