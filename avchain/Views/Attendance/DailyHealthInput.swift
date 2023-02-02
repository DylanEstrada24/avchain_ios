//
//  DailyHealthInput.swift
//  avchain
//

import SwiftUI

struct DailyHealthInput: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var settings: UserSettings
    
    @State var date: Date = Date()
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var weight = "" // 체중
    @State var high = "" // 혈압 수축기 - 최고
    @State var low = "" // 혈압 이완기 - 최저
    @State var sleepTime = "" // 수면시간
    @State var sleepStatus: Int = -1 // 수면상태 설정
    @State var smoke: Int = -1 // 흡연
    @State var drink: Int = -1 // 음주
    @State var items1 :[String] = ["아주 잘 잠","잘 잠","잘 못 잠"]
    @State var items2 :[String] = ["거의 못 잠"]
    @State var target: [String] = ["예","아니오"]
    
    @State var drinkAmount = "" // 음주량 -> drink == 0일 시 값 체크
    @State var drinkTarget1: [String] = ["소주", "맥주", "막걸리"]
    @State var drinkTarget2: [String] = ["양주", "와인", "기타"]
    @State var drinkKind: Int = -1 // 주종 -> drinkTarget
    
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
    
    @State var todayText = ""
    @State var yesterdayText = ""
    @State var yesterdayText2 = ""
    
    var todayCheck: String = "0"
    
    private func getData() {
        // 날짜설정 (오늘, 어제날짜 구해야함)
        
        // 오늘날짜
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d(+1)일"
        self.todayText = formatter.string(from: self.date)
        
        // 어제날짜
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "M월 d일"
        let d: Date = Calendar.current.date(byAdding: .day, value: -1, to: self.date)!
        self.yesterdayText = formatter2.string(from: d)
        
        // 어제날짜
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "M월 d일(E)"
        self.yesterdayText2 = formatter3.string(from: d)
        
        // 데이터 불러옴
        // 어제날짜 읽을 양식부터 설정
        let paramFormatter = DateFormatter()
        paramFormatter.dateFormat = "yyyyMMdd%"
        let created = paramFormatter.string(from: d)
        
        var table = ""
        var option = ""
        
        // 운동
        do {
            table = "체중"
            option = " limit 0, 1"
            let list: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " (select * from SelfInput where category in ('\(table)') and created like '\(created)' order by created desc) " + option)
            
            if list.count > 0 {
                self.weight = "\(list[0]["input"]!)"
            }
        } catch {
            print("운동 정보 조회 실패")
        }
        
        // 혈압
        do {
            table = "혈압H', '혈압L"
            option = " limit 0, 2"
            let list: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " (select * from SelfInput where category in ('\(table)') and created like '\(created)' order by created desc) " + option)
            
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
            }
            
        } catch {
            print("혈압 정보 조회 실패")
        }
        
        // 수면흡연
        do {
            table = "sleep_time', 'sleep_status', 'smoking', 'drinking', 'drink_amount', 'drink_kind"
            option = " limit 0, 6"
            let list: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " (select * from SelfInput where category in ('\(table)') and created like '\(created)' order by created desc) " + option)
            
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
            }
            
        } catch {
            print("수면흡연 정보 조회 실패")
        }
        
        // 복약증상
        do {
            table = "edema', 'breath', 'urine', 'constipation', 'stress', 'pain_status', 'pain "
            option = " limit 0, 7"
            let list: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " (select * from SelfInput where category in ('\(table)') and created like '\(created)' order by created desc) " + option)
            
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
            }
            
        } catch {
            print("복약증상 정보 조회 실패")
        }
         
    }
    
    private func submit() {
        
        guard weight.isEmpty == false else { return }
        guard high.isEmpty == false else { return }
        guard low.isEmpty == false else { return }
        
        
        guard sleepTime.isEmpty == false else { return } // 수면시간
        guard sleepStatus != -1 else { return } // 수면상태
        guard smoke != -1 else { return } // 흡연
        guard drink != -1 else { return } // 음주
        
        if drink == 0 {
            guard drinkAmount.isEmpty == false else { return }
            guard drinkKind != -1 else { return }
        }
        
        guard edema != -1 else { return } // 부종
        guard dyspnoea != -1 else { return } // 호흡곤란
        guard foamyUrine != -1 else { return } // 거품뇨
        guard constipation != -1 else { return } // 변비
        guard stress != -1 else { return } // 스트레스
        guard pain != -1 else { return } // 아픈정도
        if pain > 0 {
            guard part != -1 else { return } // 통증부위
        }
        
        let ss = String(UnicodeScalar(sleepStatus + 65)!)
        let smk = smoke == 0 ? "Y" : "N"
        let drk = drink == 0 ? "Y" : "N"
        let dk = String(UnicodeScalar(drinkKind + 65)!)
        
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
        
        if self.todayCheck == "1" {
            settings.screen = AnyView(EightWeeksMain())
        } else {
            // 저장
            
            // 현재 날짜 (yyyy-mm-dd)
            let today = KoreanDate.dbDateFormat.string(from: Date())
            do {
                // 체중
                ABSQLite.insert("insert into SelfInput(category, input, created) values ('체중', \(weight), '\(today)')")
                
                // 혈압
                ABSQLite.insert("insert into SelfInput(category, input, created) values('혈압H', '\(high)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('혈압L', '\(low)', '\(today)')")
                
                // 수면흡연
                ABSQLite.insert("insert into SelfInput(category, input, created) values('sleep_time', '\(sleepTime)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('sleep_status', '\(ss)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('smoking', '\(smk)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('drinking', '\(drk)', '\(today)')")
                if drink == 0 {
                    ABSQLite.insert("insert into SelfInput(category, input, created) values('drink_amount', '\(drinkAmount)', '\(today)')")
                    ABSQLite.insert("insert into SelfInput(category, input, created) values('drink_kind', '\(dk)', '\(today)')")
                }
                
                // 복약증상
                ABSQLite.insert("insert into SelfInput(category, input, created) values('edema', '\(edm)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('breath', '\(dspn)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('urine', '\(fmrn)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('constipation', '\(cnstpt)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('stress', '\(strs)', '\(today)')")
                ABSQLite.insert("insert into SelfInput(category, input, created) values('pain_status', '\(pn)', '\(today)')")
                if pain > 0 {
                    ABSQLite.insert("insert into SelfInput(category, input, created) values('pain', '\(pt)', '\(today)')")
                }
                
                // 성공처리 해야함
                print("저장 성공")
                
                UserDefaults.standard.set(true, forKey: "attendToggle")
                
                let pointDate = KoreanDate.dateParamFormat.string(from: Date())
                ABSQLite.insert("insert into myPoint(yyyymmdd, flag) values('\(pointDate)', '1')")
                
                toggleAlert(msg: "나의 건강수치를 저장했습니다.")
                // 이동처리 해야함 !!! ... JY
                settings.screen = AnyView(EightWeeksMain())
                
                
            } catch {
                print("저장 실패")
            }
        }
        
    }
    
    private func toggleAlert(msg: String) {
        self.showAlert.toggle()
        self.alertMsg = msg
    }
    
    var body: some View {
        
        ScrollView() {
            VStack(alignment: .leading) {
                // 상단 텍스트
                Group {
                    Text("안녕하세요~")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                        .frame(width: nil)
                    Text("오늘은 \(todayText)입니다.")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                    Text("출석체크로 어제 \(yesterdayText) '나의 건강' 수치를 입력해주세요.")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.leading)
                    
                    Text("어제 \(yesterdayText2) 나의 건강")
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
                                        TextField("시간", text: $sleepTime)
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
                                                    self.sleepStatus = selected
                                                    print("\(selected)")
                                                },
                                                selectedID: self.sleepStatus
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
                                                    self.sleepStatus = selected
                                                    print("\(selected)")
                                                },
                                                selectedID: self.sleepStatus
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
                            
                            DashedLine()
                               .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                               .frame(height: 1)
                               .foregroundColor(.yellow)
                        }
                    }
                    
                    inputArea
                    
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
            .padding(.horizontal, 10.0)
            .onAppear {
                getData()
            }
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

struct DailyHealthInput_Previews: PreviewProvider {
    static var previews: some View {
        DailyHealthInput()
    }
}
