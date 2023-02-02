//
//  MainSelfInput.swift
//  avchain
//

import SwiftUI
import SwiftUIDatePickerDialog
import DGCharts
import Alamofire
import SwiftyJSON

struct SelfInputs: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var category = ["음식", "운동", "혈압", "혈당", "수면흡연", "복약증상"]
    @State var selected: String?
    
    @StateObject var cm = CalendarManager(mode: .Week,
                                    startDate: .startDefault,
                                    endDate: .endDefault,
                                    startPoint: .current)
    
    @State var list: [Dictionary<AnyHashable, Any>] = []
    
    @State var hlEntry: LineChartData = []
    @State var hlCpations: [String] = []
    @State var bsEntry: LineChartData = []
    @State var bsCpations: [String] = []
    
    @State var drugList: [Drug] = []
    
    @State var updated: Bool = false
    
    private func getData(cc: CalendarComponents) {
        
        guard selected != "음식" else { return }
        
        self.list = []
        self.drugList = []
        
        var table = ""
        
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        
        let date = "\(cc.year)-" + month + "-" + day
        let created = "\(cc.year)" + month + day + "%"
        
        var option = ""
        
        switch(selected) {
            case "운동": table = "walk_count', 'walk_time', 'walk_distance', 'walk_kcal', '체중', 'walking_goal', 'exercise_work"; option = " limit 0, 7"
            case "혈압": table = "혈압H', '혈압L"; option = " limit 0, 2"
            case "수면흡연": table = "sleep_time', 'sleep_status', 'smoking', 'drinking', 'drink_amount', 'drink_kind"; option = " limit 0, 6"
            case "복약증상": table = "edema', 'breath', 'urine', 'constipation', 'stress', 'pain_status', 'pain "; option = " limit 0, 7"
            case "혈 당": table = selected!; option = " limit 0, 1"
            default: table = selected!
        }
        
        let t: String = " (select * from SelfInput where category in ('\(table)') and created like '\(created)' order by created desc) " + option
        
        
        do {
            
            self.list = ABSQLite.select(" * ", table: t)
            
            if selected == "혈당" {
                let bs: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈당' order by created desc limit 0, 7 ")
                
                var captions: [String] = []
                
                let entries: [ChartDataEntry] = (0 ..< bs.count).map { (i) -> ChartDataEntry in 
                    let v = bs[bs.count - i - 1]["input"]! as! Int32
                    let tempv = Double(v)
                    let caption = (bs[bs.count - i - 1]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "/" + (bs[bs.count - i - 1]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                    captions.append(String(caption))
                    return ChartDataEntry(x: Double(bs.count - i - 1), y: tempv)
                }
                
                let dataSet = LineChartDataSet(entries: entries)
                dataSet.setColor(.systemBlue)
                dataSet.label = "혈당"
                let lineChartData = LineChartData(dataSet: dataSet)
                
                self.bsEntry = lineChartData
                self.bsCpations = captions
                
            } else if selected == "혈압" {
                
                let high: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈압H' order by created desc limit 0, 7 ")
                let low: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈압L' order by created desc limit 0, 7 ")
                
                var captions: [String] = []
                
                let highEntries: [ChartDataEntry] = (0 ..< high.count).map { (i) -> ChartDataEntry in
                    let v = high[high.count - i - 1]["input"]! as! Int32
                    let tempv = Double(v)
                    let caption = (high[high.count - i - 1]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "/" + (high[high.count - i - 1]["created"]! as! String).suffix(8).prefix(4).suffix(2)
                    captions.append(String(caption))
                    return ChartDataEntry(x: Double(high.count - i - 1), y: tempv)
                }
                
                let lowEntries: [ChartDataEntry] = (0 ..< low.count).map { (i) -> ChartDataEntry in
                    let v = low[high.count - i - 1]["input"]! as! Int32
                    let tempv = Double(v)
                    return ChartDataEntry(x: Double(low.count - i - 1), y: tempv)
                }
                
                
                
                let highDataSet = LineChartDataSet(entries: highEntries)
                highDataSet.setColor(.red)
                highDataSet.label = "수축기(자가)"
//                let highLineChartData = LineChartData(dataSet: highDataSet)
                
                let lowDataSet = LineChartDataSet(entries: lowEntries)
                lowDataSet.setColor(.systemBlue)
                lowDataSet.label = "이완기(자가)"
//                let lowLineChartData = LineChartData(dataSet: lowDataSet)
                
                self.hlEntry = [highDataSet, lowDataSet]
                self.hlCpations = captions
                
            } else if selected == "복약증상" {
                var dl: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " drugAlarmLog where yyyymmdd = '\(date)' order by alarm_id asc ")
                if dl.count > 0 {
                    var ampm = ""
                    var flag: Bool = false
                    for i in dl {
                        ampm = i["ampm"] as! String == "AM" ? "오전" : "오후"
                        flag = i["flag"] as! String == "true" ? true : false
                        drugList.append(Drug(flag: flag, name: i["drug_name"] as! String, ampm: ampm, hhmm: i["hhmm"] as! String, week: i["week"] as! String, lastUpdate: i["last_update"] as! String))
                    }
                }
            }
            
            self.updated = true
            
        } catch {
            print("db Error...")
        }
        
        
    }
    
    var body: some View {
        VStack {
            // X 버튼
            Group {
                HStack {
                    Spacer()
                    Image(systemName: "multiply")
                        .font(.title)
                        .onTapGesture {
                        self.mode.wrappedValue.dismiss()
                    }
                    .padding(.horizontal)
                    .font(.system(size:24))
                }
            }
            // 카테고리 시작
            Group {
                HStack {
                    ForEach(category, id: \.self) { str in
                        Spacer()
                        VStack {
                            Button(str) {
                                print(str)
                                self.selected = str
                                getData(cc: self.cm.selectedComponent)
                            }
                                .foregroundColor(.brown)
                        }
                        .padding(.bottom, 10)
                        .overlay(
                            selected == str ? Group {
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
                }
                .padding(.vertical)
            }
            // 카테고리 끝
            if selected != "음식" {
                Group {
                    JHCalendar(cellHeight:60){ component in
                        DefaultCalendarCell(component: component)
                    }
                    .customWeekdaySymbols(symbols: ["일", "월", "화", "수", "목", "금", "토"])
                    .showTitle(show: true)
                    .showWeekBar(show: true)
                    .environmentObject(cm)
                    .onChange(of: cm.selectedComponent) {cc  in
                        getData(cc: self.cm.selectedComponent)
                    }
                }
                .background(calendarPurple)
            }
            
//            Text(String(cm.selectedComponent.day))
            
            switch (selected) {
                case "음식":
                    foodRegist()
                case "운동":
                    exerciseRegist(list: self.$list, cm: cm, updated: self.$updated)
                case "혈압":
                bloodPressureRegist(list: self.$list, cm: cm, updated: self.$updated, hlEntry: self.hlEntry, captions: self.hlCpations)
                case "혈당":
                    bloodSugarRegist(list: self.$list, cm: cm, updated: self.$updated, entry: self.bsEntry, captions: self.bsCpations)
                case "수면흡연":
                    sleepSmokingRegist(list: self.$list, cm: cm, updated: self.$updated)
                case "복약증상":
                    medicineSymptomRegist(list: self.$list, cm: cm, updated: self.$updated, drugList: self.$drugList)
                default:
                    emptySpace()
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            getData(cc: self.cm.selectedComponent)
        }
    }

}

struct foodRegist: View {
    
    enum Field: Hashable {
        case date, time
    }
    
    @State var text = ""
    @State var showAlert = false
    @State var alertMsg = ""
    
    @State var time = "" // 아침/점심/저녁/간식
    
    @State var list: [Dictionary<AnyHashable, Any>] = [] // 음식목록
    @State var selectedList: [Dictionary<AnyHashable, Any>] = [] // 선택한 음식 목록
    @State var selectedHead: [String] = [] // 키워드 입력칸에 보여질거 -> 어떻게 뿌려줄지 ?? ... JY
    
    @FocusState var focusField: Field?
    
    @State var date = Date()
    @State var dialogShowing = false
    
    var times: [String] = ["아침", "점심", "저녁", "간식"]
    let style: DateTimePickerDialog.Style = .compact
    let displayComponents: DatePickerComponents = [.date, .hourAndMinute]
    
    private func getData(str: String) {
        guard str.isEmpty == false else { return }
        
        self.list = []
        
        self.list = ABSQLite.select(" * ", table: " foodNew where food like '%\(str)%'")
        
    }
    
    private func selectItem(item: Dictionary<AnyHashable, Any>) {
        if selectedHead.count > 0 {
            let itemSet = Set(selectedHead)
            
            for i in selectedHead {
                if itemSet.contains(item["food"]! as! String) {
                    return
                }
            }
        }
        
        selectedList.append(item)
        selectedHead.append(item["food"]! as! String)
        
    }
    
    private func addItem() {
        
        let dateParam = KoreanDate.dbDateFormat.string(from: date)
        
         //json encoder 선언
         let encoder = JSONEncoder()
         encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        
         //각 엘레멘트 모델
         let jsonElementFood = SelfdialogElement(category: "음식", created: "yyyy-mm-dd hh:mm:ss", input: "")
         let jsonElementKcal = SelfdialogElement(category: "하루열량", created: "yyyy-mm-dd hh:mm:ss", input: "") // ABCD임
         let jsonElementCarbohydrateG = SelfdialogElement(category: "탄수화물", created: "yyyy-mm-dd hh:mm:ss", input: "") // YN
         let jsonElementProteinG = SelfdialogElement(category: "단백질", created: "yyyy-mm-dd hh:mm:ss", input: "") // YN
         let jsonElementFatG = SelfdialogElement(category: "지방", created: "yyyy-mm-dd hh:mm:ss", input: "")
         let jsonElementCalciumMg = SelfdialogElement(category: "칼슘", created: "yyyy-mm-dd hh:mm:ss", input: "")
         let jsonElementPhosphorusMg = SelfdialogElement(category: "인", created: "yyyy-mm-dd hh:mm:ss", input: "")
         let jsonElementNaMg = SelfdialogElement(category: "나트륨", created: "yyyy-mm-dd hh:mm:ss", input: "")
         let jsonElementPotassiumMg = SelfdialogElement(category: "칼륨", created: "yyyy-mm-dd hh:mm:ss", input: "")
        
        
         //배열로 묶음
         var jsonArrayFoodUserInput = Selfdialog(arrayLiteral: jsonElementFood,
                                                 jsonElementKcal, jsonElementCarbohydrateG, jsonElementProteinG, jsonElementFatG, jsonElementCalciumMg,jsonElementPhosphorusMg, jsonElementNaMg, jsonElementPotassiumMg)

         //인코딩
         let jsonData = try? encoder.encode(jsonArrayFoodUserInput)

         //컨버팅됐으면 alamofire로 발송
         if let jsonData = jsonData,let jsonString = String(data: jsonData, encoding: .utf8){

             print(jsonString) // 값 확인
         }
        
        do {
            for item in selectedList {
                ABSQLite.insert("insert into SelfInput(category, input, created) values('음식', '\(item["food"]! as! String)', '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('하루열량', \(item["kcal"]!), '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('탄수화물', \(item["carbohydrate_p"]!), '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('단백질', \(item["protein_p"]!), '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('지방', \(item["fat_p"]!), '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('칼슘', \(item["calcium"]!), '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('인', \(item["phosphorus"]!), '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('나트륨', \(item["na"]!), '\(dateParam)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('칼륨', \(item["potassium"]!), '\(dateParam)')")
//
                print("저장성공")
                
                
                do {
                    
                    let dateInputParam = KoreanDate.dateInputFormat.string(from: date)
                    
                    let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
                    let token = UserDefaults.standard.string(forKey: "token") ?? ""
                    
                    var list: [[String: Any]] = []
                    
                    list.append(["category" : "음식",  "created" : dateInputParam ,  "input" : item["food"]! as! String])
                    list.append(["category" : "하루열량",  "created" : dateInputParam ,  "input" : item["kcal"]!])
                    list.append(["category" : "탄수화물",  "created" : dateInputParam ,  "input" : item["carbohydrate_p"]!])
                    list.append(["category" : "단백질",  "created" : dateInputParam ,  "input" : item["protein_p"]!])
                    list.append(["category" : "지방",  "created" : dateInputParam ,  "input" : item["fat_p"]!])
                    list.append(["category" : "칼슘",  "created" : dateInputParam ,  "input" : item["calcium"]!])
                    list.append(["category" : "인",  "created" : dateInputParam ,  "input" : item["phosphorus"]!])
                    list.append(["category" : "나트륨",  "created" : dateInputParam ,  "input" : item["na"]!])
                    list.append(["category" : "칼륨",  "created" : dateInputParam ,  "input" : item["potassium"]!])
                    
                    
                    let url = URL(string: "\(URLAddress.INPUT_PLATFORM_ADDRESS)/avatar/selfinput/\(avatarId)/foodUserInput")
                        var request = URLRequest(url: url!)
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                        request.httpMethod = "POST"
                        request.httpBody = try! JSONSerialization.data(withJSONObject: list, options: [])

                        Alamofire.request(request).responseJSON { (response) in
                            print("ressss",response)
                        }
                } catch {
                    print("error")
                }
                
            }
        } catch {
            // db저장 에러
        }
        
        self.dialogShowing = false
    }
    
    private func checkItems() {
        guard selectedHead.count != 0 else { return }
        UIView.setAnimationsEnabled(false)
        self.showAlert.toggle()
    }
    
    var body: some View {
        VStack {
            // 버튼 시작
            Group {
                HStack {
                    Text("오늘 드신 음식을 등록하세요.")
                        .fontWeight(.bold)
                        .foregroundColor(.brown)
                    Text("등록하기")
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(red: 245/255, green: 219/255, blue: 147/255))
                    .cornerRadius(20)
                    .onTapGesture {
                        checkItems()
                        
                    }
                }
                Divider()
            }
            // 버튼 끝
            // 텍스트 인풋 시작
            Group {
                TextField("키워드 입력", text: $text)
                    .padding()
                    .onSubmit {
                        // csv 파일 검색처리 해야함 !!!
                        guard text.isEmpty == false else { return }
                        getData(str: text)
                    }
                Divider()
            }
            Group {
                VStack(alignment: .leading) {
                    HStack {
                        Text("등록할 음식 : ")
                            .bold()
                            .foregroundColor(.black)
                        ForEach(0 ..< $selectedList.count, id: \.self) { i in
                            Text("\(selectedList[i]["food"]! as! String)")
                                .bold()
                                .font(.caption)
                                .foregroundColor(darkBrown)
                        }
                    }
                }
                .padding(.horizontal)
            }
            // 텍스트 인풋 끝
            ScrollView {
                VStack {
                    if list.count > 0 {
                        ForEach(0 ..< list.count, id: \.self) { item in
                            Group {
                                Divider()
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading) {
                                        // 제품이름
                                        Text("\(list[item]["food"]! as! String)" as! String)
                                            .fontWeight(.bold)
                                            .font(.system(size: 16))
                                        // 제품성분 시작
                                        Text("\(Double.parse(from: list[item]["amount_g"]! as! String)) g \(list[item]["kcal"]!) Kcal" as! String)
                                            .font(.system(size: 12))
                                        Text("탄수화물: \(list[item]["carbohydrate_p"]!) 단백질: \(list[item]["protein_p"]!) 지방: \(list[item]["fat_p"]!)" as! String)
                                            .font(.system(size: 12))
                                        Text("칼슘: \(list[item]["calcium"]!) 인: \(list[item]["phosphorus"]!) 나트륨: \(list[item]["na"]!) 칼륨: \(list[item]["potassium"]!)" as! String)
                                            .font(.system(size: 12))
                                    }
                                    .onTapGesture {
                                        selectItem(item: list[item])
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                }
                .alert("시기를 선택하세요", isPresented: $showAlert) {
                    ForEach(times, id: \.self) { item in
                        Button(action: {
                            self.time = item
                            print(item)
                            self.dialogShowing.toggle()
                        }) {
                            Text("\(item)")
                        }
                    }
                }
                .fullScreenCover(isPresented: $dialogShowing) {
                    ZStack {
//                        Button("asd") {
//
//                        }
//    //                    .frame(height: .infinity)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(.red)
                    }
                    .dateTimePickerDialog(
                        isShowing: $dialogShowing,
                        cancelOnTapOutside: false,
                        selection: $date,
                        displayComponents: displayComponents,
                        style: style,
                        buttons: [
                            .custom(label: { Text("확인").bold() }, action: { _ in addItem() }),
                            .cancel(label: "취소")
                        ]
                    )
                    .onAppear {
                        UIView.setAnimationsEnabled(true)
                    }
                    
                }
            }
        }
    }
}

struct exerciseRegist: View {
    
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var weight = ""
    @State var target = ["예", "아니오"]
    @State var didTarget: Int = -1
    @State var didExercise: Int = -1
    @State var walking = ""
    @State var walkingTime = ""
    @State var walkingDistance = ""
    @State var calorie = ""
    
    @Binding var list: [Dictionary<AnyHashable, Any>]
    var cm: CalendarManager
    @Binding var updated: Bool // 날짜 바뀌었을 때 데이터 변경여부 -> true면 값 업데이트
    
    private func submit() {
        guard weight.isEmpty == false else { return } // 체중
        guard didTarget != -1 else { return } // 보행목표
        guard didExercise != -1 else { return } // 운동수행
        guard walking.isEmpty == false else { return } // 보행수
        guard walkingTime.isEmpty == false else { return } // 보행시간
        guard walkingDistance.isEmpty == false else { return } // 보행거리
        guard calorie.isEmpty == false else { return } // 칼로리소모량
        
        let hhmmss = KoreanDate.hhmmssFormat.string(from: Date())
        
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        // 선택한 날짜 (yyyy-mm-dd)
        let today = "\(cm.selectedComponent.year)" + month + day + "\(hhmmss)"
        
        res = today
        
        let t = didTarget == 0 ? "Y" : "N"
        let e = didExercise == 0 ? "Y" : "N"
        
        
        do {
            ABSQLite.insert("insert into SelfInput(category, input, created) values('체중', '\(weight)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('walking_goal', '\(t)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('exercise_work', '\(e)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('walk_count', '\(walking)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('walk_time', '\(walkingTime)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('walk_distance', '\(walkingDistance)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('walk_kcal', '\(calorie)', '\(today)')")
            
            print("저장성공")
            
            do {
                
                let dateInputParam = KoreanDate.dateInputFormat.string(from: Date())
                
                let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
                let token = UserDefaults.standard.string(forKey: "token") ?? ""
                
                var list: [[String: Any]] = []
                
                list.append(["category" : "체중",  "created" : dateInputParam ,  "input" : weight])
                list.append(["category" : "walking_goal",  "created" : dateInputParam , "input" : t])
                list.append(["category" : "exercise_work",  "created" : dateInputParam , "input" : e])
                list.append(["category" : "walk_count",  "created" : dateInputParam , "input" : walking])
                list.append(["category" : "walk_time",  "created" : dateInputParam , "input" : walkingTime])
                list.append(["category" : "walk_distance",  "created" : dateInputParam , "input" : walkingDistance])
                list.append(["category" : "walk_kcal",  "created" : dateInputParam , "input" : calorie])
                
                
                let url = URL(string: "\(URLAddress.INPUT_PLATFORM_ADDRESS)/avatar/selfinput/\(avatarId)/bodyWeight")
                    var request = URLRequest(url: url!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    request.httpBody = try! JSONSerialization.data(withJSONObject: list, options: [])

                    Alamofire.request(request).responseJSON { (response) in
                        print("ressss",response)
                    }
            } catch {
                print("error")
            }
            
        } catch {
            // DB 추가 에러 ... JY
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // 달력
//                Group {
//                    JHCalendar(cellHeight:60){ component in
//                        DefaultCalendarCell(component: component)
//                    }
//                    .customWeekdaySymbols(symbols: ["일", "월", "화", "수", "목", "금", "토"])
//                    .showTitle(show: true)
//                    .showWeekBar(show: true)
//                    .environmentObject(cm)
//                    .onChange(of: cm.selectedComponent) {cc  in
//                        getData(cc: cc)
//                    }
//                }
//                .background(calendarPurple)
                // 체중
                Group {
                    HStack {
                        Text("체중")
                            .frame(width: 100, alignment: .leading)
                        TextField("입력", text: $weight)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding()
                        Text("kg")
                        Spacer()
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
                // 보행 목표
                Group {
                    VStack(alignment: .leading) {
                        Text("오늘 보행 목표에 도달하셨나요?")
                        HStack {
                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                CustomRadioButton(
                                    title: item,
                                    id:idx,
                                    callback: { selected in
                                        self.didTarget = selected
                                        print("\(selected)")
                                    },
                                    selectedID: self.didTarget
                                )
                                .foregroundColor(.white)
                            }
                            Spacer()
                        }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, -3.0)
                            .frame(height: 40)
                    }
                    .padding(.horizontal)
                    
                    DashedLine()
                       .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                       .frame(height: 1)
                       .foregroundColor(.gray)
                       .padding()
                }
                // 운동 수행
                Group {
                    VStack(alignment: .leading) {
                        Text("오늘 운동을 수행하셨나요?")
                        HStack {
                            ForEach(Array(target.enumerated()), id: \.offset) { idx, item in
                                CustomRadioButton(
                                    title: item,
                                    id:idx,
                                    callback: { selected in
                                        self.didExercise = selected
                                        print("\(selected)")
                                    },
                                    selectedID: self.didExercise
                                )
                                .foregroundColor(.white)
                            }
                            Spacer()
                        }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, -3.0)
                            .frame(height: 40)
                    }
                    .padding(.horizontal)
                    
                    DashedLine()
                       .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                       .frame(height: 1)
                       .foregroundColor(.gray)
                       .padding()
                }
                // 보행수
                Group {
                    HStack {
                        Text("보행수")
                            .frame(width: 100, alignment: .leading)
                        TextField("입력", text: $walking)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding()
                        Text("걸음")
                        Spacer()
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
                // 보행시간
                Group {
                    HStack {
                        Text("보행시간")
                            .frame(width: 100, alignment: .leading)
                        TextField("입력", text: $walkingTime)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding()
                        Text("시간")
                        Spacer()
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
                // 보행거리
                Group {
                    HStack {
                        Text("보행거리")
                            .frame(width: 100, alignment: .leading)
                        TextField("입력", text: $walkingDistance)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding()
                        Text("km")
                        Spacer()
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
                // 칼로리 소모량
                Group {
                    HStack {
                        Text("칼로리 소모량")
                            .frame(width: 100, alignment: .leading)
                        TextField("입력", text: $calorie)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding()
                        Text("kcal")
                        Spacer()
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
                
                // 저장하기
                Group {
                    Button("저장하기") {
                        submit()
                        
                        
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
                
                // 그래프?
                Group {
                    Rectangle()
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
            }
            .onChange(of: updated) { newValue in
                if newValue == true {
                    if list.count > 0 {
                        var category: String = ""

                        for item in list {
                            category = item["category"]! as! String
                            switch(category) {
                                case "체중": self.weight = "\(item["input"]!)"
                                case "walking_goal": self.didTarget = (item["input"]! as! String) == "Y" ? 0 : 1
                                case "exercise_work": self.didExercise = (item["input"]! as! String) == "Y" ? 0 : 1
                                case "walk_count": self.walking = "\(item["input"]!)"
                                case "walk_time": self.walkingTime = "\(item["input"]!)"
                                case "walk_distance": self.walkingDistance = "\(item["input"]!)"
                                case "walk_kcal": self.calorie = "\(item["input"]!)"
                                default: print("default")
                            }
                        }
                    } else {
                        self.weight = ""
                        self.didTarget = -1
                        self.didExercise = -1
                        self.walking = ""
                        self.walkingTime = ""
                        self.walkingDistance = ""
                        self.calorie = ""
                    }
                    updated = false
                }
            }
        }
    }
}

struct bloodPressureRegist: View {
    
    @Binding var list: [Dictionary<AnyHashable, Any>]
    
    var cm: CalendarManager
    
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var high = ""
    @State var low = ""
    
    @Binding var updated: Bool // 날짜 바뀌었을 때 데이터 변경여부 -> true면 값 업데이트
    
    var hlEntry: LineChartData = []
    
    var captions: [String]
    
    private func submit() {
        guard high.isEmpty == false else { return } // 수축기
        guard low.isEmpty == false else { return } // 이완기
        
        
        let hhmmss = KoreanDate.hhmmssFormat.string(from: Date())
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        // 선택한 날짜 (yyyy-mm-dd)
        let today = "\(cm.selectedComponent.year)" + month + day + "\(hhmmss)"
        
        res = today

        do {
            ABSQLite.insert("insert into SelfInput(category, input, created) values('혈압H', '\(high)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('혈압L', '\(low)', '\(today)')")
            
            print("저장성공")
            
            do {
                
                let dateInputParam = KoreanDate.dateInputFormat.string(from: Date())
                
                let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
                let token = UserDefaults.standard.string(forKey: "token") ?? ""
                
                var list: [[String: Any]] = []
                
                list.append(["category" : "혈압H",  "created" : dateInputParam ,  "input" : high])
                list.append(["category" : "혈압L",  "created" : dateInputParam , "input" : low])
                
                
                let url = URL(string: "\(URLAddress.INPUT_PLATFORM_ADDRESS)/avatar/selfinput/\(avatarId)/bloodPressure")
                    var request = URLRequest(url: url!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    request.httpBody = try! JSONSerialization.data(withJSONObject: list, options: [])

                    Alamofire.request(request).responseJSON { (response) in
                        print("ressss",response)
                    }
            } catch {
                print("error")
            }
            
        } catch {
            // DB 추가 에러 ... JY
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 달력
//                Group {
//                    JHCalendar(cellHeight:60){ component in
//                        DefaultCalendarCell(component: component)
//                    }
//                    .customWeekdaySymbols(symbols: ["일", "월", "화", "수", "목", "금", "토"])
//                    .showTitle(show: true)
//                    .showWeekBar(show: true)
//                    .environmentObject(cm)
//                }
//                .background(calendarPurple)
                // 혈압
                Group {
                    HStack {
                        Text("혈압")
                            .frame(width: 100, alignment: .leading)
                        TextField("최고", text: $high)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                        .padding(.leading)
                        Text("/")
                        TextField("최저", text: $low)
                            .keyboardType(.numberPad)
                            .frame(width: 40)
                        Text("mmHg")

                    }
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                }
                
                // 저장하기
                Group {
                    Text("저장하기")
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
                    .onTapGesture {
                        submit()
                        
                    }
                }
                .padding(.horizontal)
                
                // 그래프?
                Group {
                    LineChart(data: hlEntry, captions: captions)
                        .frame(height: 400)
                        .padding()
                }
                .padding(.horizontal)
            }
            .onChange(of: updated) { newValue in
                if newValue == true {
                    if list.count > 0 {
                        var category: String = ""

                        for item in list {
                            category = item["category"]! as! String
                            switch(category) {
                                case "혈압H": self.high = "\(item["input"]!)"
                                case "혈압L": self.low = "\(item["input"]!)"
                                default: print("default")
                            }
                        }
                    } else {
                        self.high = ""
                        self.low = ""
                    }
                    updated = false
                }
            }
        }
    }
}

struct bloodSugarRegist: View {
    
    @Binding var list: [Dictionary<AnyHashable, Any>]
    
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var bloodSugar = ""
    
    var cm: CalendarManager
    
    @Binding var updated: Bool // 날짜 바뀌었을 때 데이터 변경여부 -> true면 값 업데이트
    
    var entry: LineChartData = []
    
    var captions: [String]
    
    private func submit() {
        guard bloodSugar.isEmpty == false else { return } // 혈당
        
        let hhmmss = KoreanDate.hhmmssFormat.string(from: Date())
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        // 선택한 날짜 (yyyy-mm-dd)
        let today = "\(cm.selectedComponent.year)" + month + day + "\(hhmmss)"
        
        res = today

        do {
            ABSQLite.insert("insert into SelfInput(category, input, created) values('혈당', '\(bloodSugar)', '\(today)')")
            
            print("저장성공")
            
            do {
                
                let dateInputParam = KoreanDate.dateInputFormat.string(from: Date())
                
                let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
                let token = UserDefaults.standard.string(forKey: "token") ?? ""
                
                var list: [[String: Any]] = []
                
                list.append(["category" : "혈당",  "created" : dateInputParam ,  "input" : bloodSugar])
                
                
                let url = URL(string: "\(URLAddress.INPUT_PLATFORM_ADDRESS)/avatar/selfinput/\(avatarId)/bloodSugar")
                    var request = URLRequest(url: url!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    request.httpBody = try! JSONSerialization.data(withJSONObject: list, options: [])

                    Alamofire.request(request).responseJSON { (response) in
                        print("ressss",response)
                    }
            } catch {
                print("error")
            }
            
        } catch {
            // DB 추가 에러 ... JY
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 달력
//                Group {
//                    JHCalendar(cellHeight:60){ component in
//                        DefaultCalendarCell(component: component)
//                    }
//                    .customWeekdaySymbols(symbols: ["일", "월", "화", "수", "목", "금", "토"])
//                    .showTitle(show: true)
//                    .showWeekBar(show: true)
//                    .environmentObject(cm)
//                }
//                .background(calendarPurple)
                // 혈당
                Group {
                    HStack {
                        Text("혈당")
                            .frame(width: 100, alignment: .leading)
                        TextField("최고", text: $bloodSugar)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                        .padding(.leading)
                        Text("mg/dl")
                        Spacer()
                    }
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                }
                
                // 저장하기
                Group {
                    Text("저장하기")
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
                    .onTapGesture {
                        submit()
                        
                    }
                }
                .padding(.horizontal)
                
                // 그래프?
                Group {
                    LineChart(data: entry, captions: captions)
                        .frame(height: 400)
                        .padding()
                }
                .padding(.horizontal)
            }
            .onChange(of: updated) { newValue in
                if newValue == true {
                    if list.count > 0 {
                        var category: String = ""

                        for item in list {
                            category = item["category"]! as! String
                            switch(category) {
                                case "혈당": self.bloodSugar = "\(item["input"]!)"
                                default: print("default")
                            }
                        }
                    } else {
                        self.bloodSugar = ""
                    }
                    updated = false
                }
            }
        }
    }
}

struct sleepSmokingRegist: View {

    @Binding var list: [Dictionary<AnyHashable, Any>]
    
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var sleepTime = ""
    @State var target = ["예", "아니오"]
    @State var sleepTarget1 :[String] = ["아주 잘 잠","잘 잠","잘 못 잠"]
    @State var sleepTarget2 :[String] = ["거의 못 잠"]
    @State var sleepStatus: Int = -1 // 0부터 3까지 아주 잘 잠 ~ 거의 못 잠
    @State var smoke: Int = -1 // 0 = 예, 1 = 아니오
    @State var drink: Int = -1
    
    @State var drinkAmount = "" // 음주량 -> drink == 0일 시 값 체크
    @State var drinkTarget1: [String] = ["소주", "맥주", "막걸리"]
    @State var drinkTarget2: [String] = ["양주", "와인", "기타"]
    @State var drinkKind: Int = -1 // 주종 -> drinkTarget
    
    var cm: CalendarManager
    
    @Binding var updated: Bool // 날짜 바뀌었을 때 데이터 변경여부 -> true면 값 업데이트
    
    private func submit() {
        guard sleepTime.isEmpty == false else { return } // 수면시간
        guard sleepStatus != -1 else { return } // 수면상태
        guard smoke != -1 else { return } // 흡연
        guard drink != -1 else { return } // 음주
        
        if drink == 0 {
            guard drinkAmount.isEmpty == false else { return }
            guard drinkKind != -1 else { return }
        }
        
        let ss = String(UnicodeScalar(sleepStatus + 65)!)
        let smk = smoke == 0 ? "Y" : "N"
        let drk = drink == 0 ? "Y" : "N"
        let dk = String(UnicodeScalar(drinkKind + 65)!)
        
        // //json encoder 선언
        // let encoder = JSONEncoder()
        // encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        
        // //각 엘레멘트 모델
        // let jsonElementSleepTime = SelfdialogElement(category: "sleep_time", created: "yyyy-mm-dd hh:mm:ss", input: sleepTime)
        // let jsonElementSleepStatus = SelfdialogElement(category: "sleep_status", created: "yyyy-mm-dd hh:mm:ss", input: String(ss)) // ABCD임
        // let jsonElementSmoking = SelfdialogElement(category: "smoking", created: "yyyy-mm-dd hh:mm:ss", input: String(smk)) // YN
        // let jsonElementDrinking = SelfdialogElement(category: "drinking", created: "yyyy-mm-dd hh:mm:ss", input: String(drk)) // YN
        // let jsonElementDrinkAmount = SelfdialogElement(category: "drink_amount", created: "yyyy-mm-dd hh:mm:ss", input: drinkAmount)
        // let jsonElementDrinkKind = SelfdialogElement(category: "drink_kind", created: "yyyy-mm-dd hh:mm:ss", input: String(dk))
        
        
        // //배열로 묶음
        // var jsonArraySmokingDrinking = Selfdialog(arrayLiteral: jsonElementSleepTime,
        //                                           jsonElementSleepStatus, jsonElementSmoking, jsonElementDrinking, jsonElementDrinkAmount, jsonElementDrinkKind)

        // //인코딩
        // let jsonData = try? encoder.encode(jsonArraySmokingDrinking)

        // //컨버팅됐으면 alamofire로 발송
        // if let jsonData = jsonData,let jsonString = String(data: jsonData, encoding: .utf8){

        //     print(jsonString) // 값 확인

        // }
        
        let hhmmss = KoreanDate.hhmmssFormat.string(from: Date())
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        // 선택한 날짜 (yyyy-mm-dd)
        let today = "\(cm.selectedComponent.year)" + month + day + "\(hhmmss)"
        
        res = today
        
        

        do {
            ABSQLite.insert("insert into SelfInput(category, input, created) values('sleep_time', '\(sleepTime)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('sleep_status', '\(ss)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('smoking', '\(smk)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('drinking', '\(drk)', '\(today)')")
            if drink == 0 {
                ABSQLite.insert("insert into SelfInput(category, input, created) values('drink_amount', '\(drinkAmount)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('drink_kind', '\(dk)', '\(today)')")
            }
            
            print("저장성공")
            
            do {
                
                let dateInputParam = KoreanDate.dateInputFormat.string(from: Date())
                
                let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
                let token = UserDefaults.standard.string(forKey: "token") ?? ""
                
                var list: [[String: Any]] = []
                
                list.append(["category" : "sleep_time",  "created" : dateInputParam ,  "input" : sleepTime])
                list.append(["category" : "sleep_status",  "created" : dateInputParam ,  "input" : ss])
                list.append(["category" : "smoking",  "created" : dateInputParam ,  "input" : smk])
                list.append(["category" : "drinking",  "created" : dateInputParam ,  "input" : drk])
                if(drink == 0){
                    list.append(["category" : "drink_amount",  "created" : dateInputParam ,  "input" : drinkAmount])
                    list.append(["category" : "drink_kind",  "created" : dateInputParam ,  "input" : dk])
                }
                
                
                let url = URL(string: "\(URLAddress.INPUT_PLATFORM_ADDRESS)/avatar/selfinput/\(avatarId)/smokingDrinking")
                    var request = URLRequest(url: url!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    request.httpBody = try! JSONSerialization.data(withJSONObject: list, options: [])

                    Alamofire.request(request).responseJSON { (response) in
                        print("ressss",response)
                    }
            } catch {
                print("error")
            }
            
        } catch {
            // DB 추가 에러 ... JY
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 달력
//                Group {
//                    JHCalendar(cellHeight:60){ component in
//                        DefaultCalendarCell(component: component)
//                    }
//                    .customWeekdaySymbols(symbols: ["일", "월", "화", "수", "목", "금", "토"])
//                    .showTitle(show: true)
//                    .showWeekBar(show: true)
//                    .environmentObject(cm)
//                }
//                .background(calendarPurple)
                // 수면상태
                Group {
                    Group {
                        HStack {
                            Text("수면상태")
                                .frame(width: 100, alignment: .leading)
                            TextField("입력", text: $sleepTime)
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                            .padding(.leading)
                            Text("시간")
                            Spacer()
                        }
                            .padding(.horizontal)
                            .padding(.vertical, -3.0)
                            .frame(height: 40)
                        
                        HStack {
                            Spacer()
                                .frame(width: 100)
                            VStack(alignment: .leading) {
                                HStack {
                                    ForEach(Array(sleepTarget1.enumerated()), id: \.offset) { idx, item in
                                        CustomRadioButton(
                                            title: item,
                                            id:idx,
                                            callback: { selected in
                                                self.sleepStatus = selected
                                                print("\(selected)")
                                            },
                                            selectedID: self.sleepStatus
                                        )
                                    }
                                }
                                HStack {
                                    ForEach(Array(sleepTarget2.enumerated()), id: \.offset) { idx, item in
                                        CustomRadioButton(
                                            title: item,
                                            id:idx + 3,
                                            callback: { selected in
                                                self.sleepStatus = selected
                                                print("\(selected)")
                                            },
                                            selectedID: self.sleepStatus
                                        )
                                    }
                                }
                            }
                        }
                        
                        DashedLine()
                           .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                           .frame(height: 1)
                           .foregroundColor(.gray)
                           .padding()
                    }
                    
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
                            .padding(.horizontal)
                            .padding(.vertical, -3.0)
                            .frame(height: 40)
                        
                        if (drink == 0) {
                            
                            HStack {
                                Text("음주량")
                                    .frame(width: 100, alignment: .leading)
                                TextField("입력", text: $drinkAmount)
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                .padding(.leading)
                                Text("잔")
                                Spacer()
                            }
                                .padding(.horizontal)
                                .padding(.vertical)
                                .frame(height: 60)
                            
                            HStack {
                                Text("주종")
                                    .frame(width: 100, alignment: .leading)
                                VStack(alignment: .leading) {
                                    HStack {
                                        ForEach(Array(drinkTarget1.enumerated()), id: \.offset) { idx, item in
                                            CustomRadioButton(
                                                title: item,
                                                id:idx,
                                                callback: { selected in
                                                    self.drinkKind = selected
                                                    print("\(selected)")
                                                },
                                                selectedID: self.drinkKind
                                            )
                                        }
                                    }
                                    HStack {
                                        ForEach(Array(drinkTarget2.enumerated()), id: \.offset) { idx, item in
                                            CustomRadioButton(
                                                title: item,
                                                id:idx + 3,
                                                callback: { selected in
                                                    self.drinkKind = selected
                                                    print("\(selected)")
                                                },
                                                selectedID: self.drinkKind
                                            )
                                        }
                                    }
                                }
                            }
                                .padding(.horizontal)
                                .padding(.vertical)
                        }
                    }
                }
                
                // 저장하기
                Group {
                    Text("저장하기")
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
                    .onTapGesture {
                        submit()
                        
                    }
                }
                .padding(.horizontal)
                
            }
        }
        .onChange(of: updated) { newValue in
            if newValue == true {
                
                self.drinkKind = -1
                self.drinkAmount = ""
                
                if list.count > 0 {
                    var category: String = ""

                    for item in list {
                        category = item["category"]! as! String
                        switch(category) {
                            case "sleep_time": self.sleepTime = "\(item["input"]!)"
                            case "sleep_status": self.sleepStatus = Int(UnicodeScalar(item["input"]! as! String)!.value - 65)
                            case "smoking": self.smoke = item["input"]! as! String == "Y" ? 0 : 1
                            case "drinking": self.drink = item["input"]! as! String == "Y" ? 0 : 1
                            case "drink_amount": self.drinkAmount = "\(item["input"]!)"
                            case "drink_kind": self.drinkKind = Int(UnicodeScalar(item["input"]! as! String)!.value - 65)
                            default: print("default")
                        }
                    }
                } else {
                    self.sleepTime = ""
                    self.sleepStatus = -1
                    self.drink = -1
                    self.smoke = -1
                    self.drinkKind = -1
                    self.drinkAmount = ""
                }
                updated = false
            }
        }
    }
}

struct medicineSymptomRegist: View {
    
    @Binding var list: [Dictionary<AnyHashable, Any>]
    
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var target = ["예", "아니오"]
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
    @State var part: Int = -1 // 통증부위
    var partTarget1: [String] = ["턱", "목", "머리", "팔", "어깨"]
    var partTarget2: [String] = ["가슴", "배", "등", "허리", "엉덩이"]
    var partTarget3: [String] = ["무릎", "다리"]
    
    
    var cm: CalendarManager
    
    @Binding var updated: Bool // 날짜 바뀌었을 때 데이터 변경여부 -> true면 값 업데이트
    
    @Binding var drugList: [Drug]
    
    private func submit() {
        guard edema != -1 else { return } // 부종
        guard dyspnoea != -1 else { return } // 호흡곤란
        guard foamyUrine != -1 else { return } // 거품뇨
        guard constipation != -1 else { return } // 변비
        guard stress != -1 else { return } // 스트레스
        guard pain != -1 else { return } // 아픈정도
        if pain > 0 {
            guard part != -1 else { return } // 통증부위
        }
        
        // //json encoder 선언
        // let encoder = JSONEncoder()
        // encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        let edm = edema == 0 ? "Y" : "N"
        let dspn = dyspnoea == 0 ? "Y" : "N"
        let fmrn = foamyUrine == 0 ? "Y" : "N"
        let cnstpt = constipation == 0 ? "Y" : "N"
        let strs = String(UnicodeScalar(stress + 65)!)
        let pn = String(UnicodeScalar(pain + 65)!)
        var pt = ""
        if pain > 0 {
            pt = String(UnicodeScalar(part + 65)!)
        }
        
        
        
        let hhmmss = KoreanDate.hhmmssFormat.string(from: Date())
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        // 선택한 날짜 (yyyy-mm-dd)
        let today = "\(cm.selectedComponent.year)" + month + day + "\(hhmmss)"
        
        res = today

        do {
            ABSQLite.insert("insert into SelfInput(category, input, created) values('edema', '\(edm)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('breath', '\(dspn)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('urine', '\(fmrn)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('constipation', '\(cnstpt)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('stress', '\(strs)', '\(today)')")
            ABSQLite.insert("insert into SelfInput(category, input, created) values('pain_status', '\(pn)', '\(today)')")
            if pain > 0 {
                ABSQLite.insert("insert into SelfInput(category, input, created) values('pain', '\(pt)', '\(today)')")
            }
            
            print("저장성공")
            
            do {
                
                let dateInputParam = KoreanDate.dateInputFormat.string(from: Date())
                
                let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
                let token = UserDefaults.standard.string(forKey: "token") ?? ""
                
                var list: [[String: Any]] = []
                
                list.append(["category" : "edema",  "created" : dateInputParam ,  "input" : edm])
                list.append(["category" : "breath",  "created" : dateInputParam ,  "input" : dspn])
                list.append(["category" : "urine",  "created" : dateInputParam ,  "input" : fmrn])
                list.append(["category" : "constipation",  "created" : dateInputParam ,  "input" : cnstpt])
                list.append(["category" : "stress",  "created" : dateInputParam ,  "input" : strs])
                list.append(["category" : "pain_status",  "created" : dateInputParam ,  "input" : pn])
                if(pain > 0){
                    list.append(["category" : "pain",  "created" : dateInputParam ,  "input" : pt])
                }
                
                
                let url = URL(string: "\(URLAddress.INPUT_PLATFORM_ADDRESS)/avatar/selfinput/\(avatarId)/symptomUserInput")
                    var request = URLRequest(url: url!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    request.httpBody = try! JSONSerialization.data(withJSONObject: list, options: [])

                    Alamofire.request(request).responseJSON { (response) in
                        print("ressss",response)
                    }
            } catch {
                print("error")
            }
        } catch {
            // DB 추가 에러 ... JY
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    if drugList.count > 0 {
                        Text("복약여부")
                        Drugs(list: drugList)
                    }
                }
                .padding(.horizontal)
                
                Text("증상입력")
                    .bold()
                    .font(.title2)
                    .padding(.horizontal)
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
                                            id:idx + 3,
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
                        
                        if pain > 0 {
                            HStack {
                                Text("통증부위")
                                    .frame(width: 100, alignment: .leading)
                                VStack(alignment: .leading) {
                                    HStack {
                                        ForEach(Array(partTarget1.enumerated()), id: \.offset) { idx, item in
                                            CustomRadioButton(
                                                title: item,
                                                id:idx,
                                                callback: { selected in
                                                    self.part = selected
                                                    print("\(selected)")
                                                },
                                                selectedID: self.part
                                            )
                                        }
                                    }
                                    HStack {
                                        ForEach(Array(partTarget2.enumerated()), id: \.offset) { idx, item in
                                            CustomRadioButton(
                                                title: item,
                                                id:idx + 5,
                                                callback: { selected in
                                                    self.part = selected
                                                    print("\(selected)")
                                                },
                                                selectedID: self.part
                                            )
                                        }
                                    }
                                    HStack {
                                        ForEach(Array(partTarget3.enumerated()), id: \.offset) { idx, item in
                                            CustomRadioButton(
                                                title: item,
                                                id:idx + 10,
                                                callback: { selected in
                                                    self.part = selected
                                                    print("\(selected)")
                                                },
                                                selectedID: self.part
                                            )
                                        }
                                    }
                                }
                            }
                                .padding(.horizontal)
                                .padding(.vertical)
                        }
                        
                    }
                }
                
                // 저장하기
                Group {
                    Text("저장하기")
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
                    .onTapGesture {
                        submit()
                        
                    }
                }
                .padding(.horizontal)
                
            }
        }
        .onChange(of: updated) { newValue in
            if newValue == true {
                
                if list.count > 0 {
                    var category: String = ""

                    for item in list {
                        category = item["category"]! as! String
                        switch(category) {
                            case "edema": self.edema = item["input"]! as! String == "Y" ? 0 : 1
                            case "breath": self.dyspnoea = item["input"]! as! String == "Y" ? 0 : 1
                            case "urine": self.foamyUrine = item["input"]! as! String == "Y" ? 0 : 1
                            case "constipation": self.constipation = item["input"]! as! String == "Y" ? 0 : 1
                            case "stress": self.stress = Int(UnicodeScalar(item["input"]! as! String)!.value - 65)
                            case "pain": self.part = Int(UnicodeScalar(item["input"]! as! String)!.value - 65)
                            case "pain_status": self.pain = Int(UnicodeScalar(item["input"]! as! String)!.value - 65)
                            default: print("default")
                        }
                    }
                } else {
                    self.edema = -1
                    self.dyspnoea = -1
                    self.foamyUrine = -1
                    self.constipation = -1
                    self.stress = -1
                    self.pain = -1
                    self.part = -1
                }
                updated = false
            }
        }
    }
    
    struct Drugs: View {
        var list: [Drug]
        var body: some View {
            VStack {
//                ForEach(list, id: \.self) { item in
//                    AnyView(item)
//                }
                ForEach(0 ..< list.count, id: \.self) { i in
                    AnyView(list[i])
                }
            }
        }
    }
    
}

struct SelfInputs_Previews: PreviewProvider {
    static var previews: some View {
        SelfInputs(selected: "음식")
    }
}
