//
//  Home.swift
//  avchain
//

import DGCharts
import SwiftUI
import Alamofire
import SwiftyJSON

struct Home: View {
    
    @EnvironmentObject var settings: UserSettings
    
    // 프로그레스바 설정값(total) -> SelfGoal - target
    @State var potassium = 0.0 // 목표 칼륨
    @State var phosphorus = 0.0 // 목표 인
    @State var calcium = 0.0 // 목표 칼슘
    @State var sodium = 0.0 // 목표 나트륨
    
    // 테스트용, 화면 그리기 및 확인 용도
    @State var temp = 0 // 0 = 일반사용자, 1 = 병원에서 데이터 받기 전, 2 = 데이터 받은 후
    
    // 값들
    @State var anemia = 0.0 // 빈혈
    @State var high = 0.0 // 혈압H
    @State var low = 0.0 // 혈압L
    @State var fat = 0.0 // 지방
    @State var weight = 0.0 // 체중
    @State var carbohydrate = 0.0 // 탄수화물
    @State var protein = 0.0 // 단백질
    @State var bloodSugar = 0.0 // 혈당
    @State var calorie = 0.0 // 하루열량
    
    @State var potassiumVal = 0.0 // 칼륨
    @State var phosphorusVal = 0.0 // 인
    @State var calciumVal = 0.0 // 칼슘
    @State var sodiumVal = 0.0 // 나트륨
    @State var calorieVal = 0.0 // 하루열량
    @State var foodDate = ""
    
    
    // 그래프 그리는용도
    @State var entries: [PieChartDataEntry] = [] // 원형그래프 영양소 3개
    
    @State var weightEntries: [BarChartDataEntry] = [] // 체중
    @State var weightAxis: [String] = []
    
    @State var highEntries: [BarChartDataEntry] = [] // 수축기
    @State var highAxis: [String] = []
    
    @State var lowEntries: [BarChartDataEntry] = [] // 이완기
    @State var lowAxis: [String] = []
    
    @State var bsEntries: [BarChartDataEntry] = [] // 혈당
    @State var bsAxis: [String] = []
    
    @State var symptomList: String = "" // 증상목록 - 부종 호흡곤란 거품뇨 변비 -> Y인것들만
    @State var symptomDate: String = "" // yyyy-MM-dd -> 마지막등록일
    
    @State var smokeVal = "" // 흡연(+/-) 음주(+/-)
    @State var smokeDate = "" // yyyy-MM-dd -> 마지막 등록일
    
    // (임시 - 건체중, 투석전/후체중)
    @State var dWeightEntries: [BarChartDataEntry] = [] // 건체중
    @State var dWeightAxis: [String] = []
    @State var beforeDialysisWeightEntries: [BarChartDataEntry] = [] // 투석전체중
    @State var beforeDialysisWeightAxis: [String] = []
    @State var afterDialysisWeightEntries: [BarChartDataEntry] = [] // 투석후체중
    @State var afterDialysisWeightAxis: [String] = []
    
    func getDayOfWeek(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEEEE"
            formatter.locale = Locale(identifier:"ko_KR")
            let convertStr = formatter.string(from: date)
            return convertStr
    }
    
    func checkAlarmProgress(){
        print("check Alarm schedule")
        
        //날짜변경 확인
        
        //하루출첵
        //코어데이터에 있는 날짜 조회
        //현재 시간 기준으로 비교
        //다를경우
        //오늘날짜 업데이트
        //다음으로 오늘 출력된적 있는지 확인
        //출력된적 없으면 하루출첵 팝업값 false
        //하루출첵팝업값이 false인 경우 홈화면 진입시 팝업 출력
        //팝업 닫을시점에 true로 값 변경
        
        
        //출첵을 안하면 아이콘은 [하루]
        
        //출첵하면(오늘자가정보입력하면) 로컬디비에 출석포인트 저장
        //위 과정으로 출석체크 종료
        
        //8주코칭
        // 하루출첵이 되면 콩팥건강8주코칭 건강목표 설정안내뷰가 뜸
        // 취소할시 메인이동
        // 건강목표설정하기 버튼 클릭시 실제로는 10점미만은 진행불가
        // 아래 출첵점수 표시
        // 목표설정은 기존 목표설정페이지와 같음
        // 목표설정시 8주코칭알람설정은 api에서 true일때에 작동한다.
        // 목표 저장하면 webview이동 -> url확인
        // 설문지 4개 다 작성하면 8주코칭여부 api조회 해서 알림여부 확인
        // api조회는 홈 화면 진입시마다 확인한다.
        // true값이 올 경우 매일 8시에 알람 발송 및 아이콘이 [8주] 로 변경
        // false값일경우 코칭 미진행
        
        
        let today = getDayOfWeek(date: Date())
        print("오늘날짜", today)
        
        let checkYesterDay = UserDefaults.standard.string(forKey: "today") ?? ""
        
        if today != checkYesterDay {
            //날짜변경됨
            UserDefaults.standard.setValue(today, forKey: "today")
            
            //팝업확인여부를 미확인으로 변경
            UserDefaults.standard.setValue("false", forKey: "isShowDailyCheck")
            
            //기존 팝업 출력여부
            // isShowPop은 팝업을 닫을때 true로 변경됨
            let isShowDailyCheck = UserDefaults.standard.string(forKey: "isShowDailyCheck") ?? ""
            
            if isShowDailyCheck == "true" {
                // isShowPop이 true일 경우 오늘 팝업을 확인했다는 의미
                // 별다른 처리 없음
                
            } else {
                // isShowPop이 false일 경우 날짜변경이후 최초접속임
                // 출첵페이지 이동
                print("move dailyCheck")
                settings.screen = AnyView(Attendance())
            }
            
        } else {
            //당일 접속...
        }
        
        //당일 재접속이지만 출첵페이지를 확인 하지않았다면 출력 : 특별한 일 없이는 출력되지않음.
        //기존 팝업 출력여부
        // isShowPop은 팝업을 닫을때 true로 변경됨
        let isShowDailyCheck = UserDefaults.standard.string(forKey: "isShowDailyCheck") ?? ""
        
        if isShowDailyCheck == "true" {
            // isShowPop이 true일 경우 오늘 팝업을 확인했다는 의미
            // 별다른 처리 없음
            
        } else {
            // isShowPop이 false일 경우 날짜변경이후 최초접속임
            // 출첵페이지 이동
            print("move dailyCheck")
            settings.screen = AnyView(Attendance())
        }
        
        UserDefaults.standard.setValue(today, forKey: "today")
        
        
    }
    
    func checkIsAddHospital() {
        let isAdd = UserDefaults.standard.string(forKey: "hospitalCode") ?? ""
        
        if isAdd != "" {
            print("1")
            self.temp = 1
        } else {
            print("0")
            self.temp = 0
        }
    }
    
    private func getData() {
        
        // 목표설정값 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfGoal ")
            if data.count > 0 {
                var category = ""

                for item in data {
                    category = item["category"]! as! String
                    var v = item["target"]! as! Int32
                    var tempv = Double(v)
                    switch(category) {
                        case "혈압H": self.high = tempv
                        case "혈압L": self.low = tempv
                        case "지방": self.fat = tempv
                        case "체중": self.weight = tempv
                        case "탄수화물": self.carbohydrate = tempv
                        case "칼륨": self.potassium = tempv * 2
                        case "칼슘": self.calcium = tempv * 2
                        case "인": self.phosphorus = tempv * 2
                        case "나트륨": self.sodium = tempv * 2
                        case "단백질": self.protein = tempv
                        case "혈당": self.bloodSugar = tempv
                        case "하루열량": self.calorie = tempv
                        default: print("default")
                    }
                    
                }

                self.entries = [
                    PieChartDataEntry(value: self.protein, label: "단백질(제시목표)"),
                    PieChartDataEntry(value: self.carbohydrate, label: "탄수화물(제시목표)"),
                    PieChartDataEntry(value: self.fat, label: "지방(제시목표)")
                ]

            }
        } catch {
            print("목표 조회 에러")
        }
        
        // 실제값 조회 - 칼륨, 나트륨, 인, 칼슘 -> 오늘날짜 기준으로 가져옴
        let today = KoreanDate.dbDateFormat.string(from: Date()).prefix(8)
        
        do {
            
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" category, sum(input) as input, created ", table: " ( select category, sum(input) as input, substr(created, 1, 8) as created from SelfInput where category in ('칼륨', '나트륨', '인', '칼슘', '하루열량') group by category, created ) where created = (select max(substr(created, 1, 8)) from SelfInput where category = '음식') group by category, created  ")
            if data.count > 0 {
                var category = ""
                
                var date1: String = ""
                var date2: String = ""

                for item in data {
                    category = item["category"]! as! String
                    var v = item["input"] ?? 0 // int / double
                    
                    var tempV:Double = 0.0
                    
                    if let intValue = v as? Int32 {
                         print(intValue)
                        
                        tempV = Double(intValue as! Int32)
                    }
                    
                    if let doubleValue = v as? Double {
                         print(doubleValue)
                        tempV = doubleValue
                    }
                    
                    
                    switch(category) {
                        case "칼륨": self.potassiumVal = tempV
                        case "칼슘": self.calciumVal = tempV
                        case "인": self.phosphorusVal = tempV
                        case "나트륨": self.sodiumVal = tempV
                    case "하루열량": self.calorieVal = tempV
                        default: print("default")
                    }
                    
                    date1 = (item["created"]! as! String).prefix(4) + "-"
                    date2 = (item["created"]! as! String).prefix(8).suffix(4).prefix(2) + "-" +
                            (item["created"]! as! String).prefix(8).suffix(4).suffix(2)
                }
                
                self.foodDate = date1 + date2

            }
        } catch {
            print("등록한 음식정보 조회 에러")
        }
        
        // 체중정보 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '체중' order by created desc limit 0, 7 ")
            if data.count > 0 {
                
                var captions: [String] = []

                let entries: [BarChartDataEntry] = (0 ..< data.count).map { (i) -> BarChartDataEntry in
                    let v = data[data.count - i - 1]["input"]! as! Int32
                    let tempv = Double(v)
                    let caption = (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "/" + (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                    captions.append(String(caption))
                    return BarChartDataEntry(x: Double(data.count - i - 1), y: tempv)
                }
                
                self.weightEntries = entries
                self.weightAxis = captions
                
                // 임시값 기입
                self.dWeightEntries = entries
                self.beforeDialysisWeightEntries = entries
                self.afterDialysisWeightEntries = entries
                self.dWeightAxis = captions
                self.beforeDialysisWeightAxis = captions
                self.afterDialysisWeightAxis = captions

            }
        } catch {
            print("등록한 체중정보 조회 에러")
        }
        
        // 수축기 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈압H' order by created desc limit 0, 7 ")
            if data.count > 0 {
                
                var captions: [String] = []

                let entries: [BarChartDataEntry] = (0 ..< data.count).map { (i) -> BarChartDataEntry in
                    let v = data[data.count - i - 1]["input"]! as! Int32
                    let tempv = Double(v)
                    let caption = (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "/" + (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                    captions.append(String(caption))
                    return BarChartDataEntry(x: Double(data.count - i - 1), y: tempv)
                }
                
                self.highEntries = entries
                self.highAxis = captions

            }
        } catch {
            print("등록한 이완기정보 조회 에러")
        }
        
        // 이완기 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈압L' order by created desc limit 0, 7 ")
            if data.count > 0 {
                
                var captions: [String] = []

                let entries: [BarChartDataEntry] = (0 ..< data.count).map { (i) -> BarChartDataEntry in
                    let v = data[data.count - i - 1]["input"]! as! Int32
                    let tempv = Double(v)
                    let caption = (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "/" + (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                    captions.append(String(caption))
                    return BarChartDataEntry(x: Double(data.count - i - 1), y: tempv)
                }
                
                self.lowEntries = entries
                self.lowAxis = captions
                
            }
        } catch {
            print("등록한 수축기정보 조회 에러")
        }
        
        // 혈당 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈당' order by created desc limit 0, 7 ")
            if data.count > 0 {
                
                var captions: [String] = []

                let entries: [BarChartDataEntry] = (0 ..< data.count).map { (i) -> BarChartDataEntry in
                    let v = data[data.count - i - 1]["input"]! as! Int32
                    let tempv = Double(v)
                    let caption = (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "/" + (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                    captions.append(String(caption))
                    return BarChartDataEntry(x: Double(data.count - i - 1), y: tempv)
                }
                
                self.bsEntries = entries
                self.bsAxis = captions
                
            }
        } catch {
            print("등록한 혈당정보 조회 에러")
        }
        
        // 증상 조회
        do {
            
//            edema 부종
//            breath 호흡곤란
//            foamyUrine 거품뇨
//            constipation 변비
            
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category in ('edema', 'breath', 'urine', 'constipation') order by created desc limit 0, 4 ")
            if data.count > 0 {
                var category = ""
                
                var date1: String = ""
                var date2: String = ""

                for item in data {
                    category = item["category"]! as! String
                    var v = item["input"]! as! String
                    switch(category) {
                        case "edema": if (v == "Y") {self.symptomList += " 부종"}
                        case "breath": if (v == "Y") {self.symptomList += " 호흡곤란"}
                        case "urine": if (v == "Y") {self.symptomList += " 거품뇨"}
                        case "constipation": if (v == "Y") {self.symptomList += " 변비"}
                        default: print("default")
                    }
                    date1 = (item["created"]! as! String).prefix(4) + "-"
                    date2 = (item["created"]! as! String).prefix(8).suffix(4).prefix(2) + "-" +
                            (item["created"]! as! String).prefix(8).suffix(4).suffix(2)
                }
                
                self.symptomDate = date1 + date2

            }
        } catch {
            print("등록한 증상정보 조회 에러")
        }
        
        // 증상 조회
        do {
            
            // smoking 흡연
            // drinking 음주
            
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category in ('smoking', 'drinking') order by created desc, category desc limit 0, 2 ")
            if data.count > 0 {
                var category = ""
                
                var date1: String = ""
                var date2: String = ""

                for item in data {
                    category = item["category"]! as! String
                    var v = item["input"]! as! String
                    switch(category) {
                        case "smoking": if (v == "Y") {v = "흡연(+) "} else {v = "흡연(-) "}
                        case "drinking": if (v == "Y") {v = "음주(+) "} else {v = "음주(-) "}
                        default: print("default")
                    }
                    
                    self.smokeVal += v
                    
                    date1 = (item["created"]! as! String).prefix(4) + "-"
                    date2 = (item["created"]! as! String).prefix(8).suffix(4).prefix(2) + "-" +
                            (item["created"]! as! String).prefix(8).suffix(4).suffix(2)
                }
                
                self.smokeDate = date1 + date2

            }
        } catch {
            print("등록한 증상정보 조회 에러")
        }
        
    }
    
    func getAgentList(){
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]
        
        print("getAgentList from home")
        
        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/agent/contract/avatar/\(avatarId)", method: .get, encoding: URLEncoding.default, headers:headers)
                        .responseJSON{ (response) in
                            switch response.result {
                            case .success:
                                let json = JSON(response.result.value)
                                guard json["code"].string == "success" else {
                                    //통신은 성공했으나 데이터가져오기 실패인 경우
                                    return
                                }
                                
                                do{
                                    let agentInfo = try? JSONDecoder().decode([AgentInfoElement].self, from: json["data"].rawData())
//                                    print("agentInfo",agentInfo)
                                    // 필요한 때에 파싱
                                }catch{
                                    print("error parse json")
                                }
                                
                                
                            case .failure(_):
                                print("error...")
                            }
                        }
        }
    }
    
    
    func getAgentDetail(){
        
        print("getAgentDetail  from home")
        
        let token = UserDefaults.standard.string(forKey: "token")!
        let avatarId = UserDefaults.standard.string(forKey: "avatarId")!
        let uniqueKey = Int(Date().timeIntervalSince1970 * 1000)
        let isPHR = UserDefaults.standard.string(forKey: "isPHR")!
        let isOnePass = UserDefaults.standard.string(forKey: "isOnePass")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/agent/1", method: .get, encoding: URLEncoding.default, headers: headers)
                        .responseString{ response in
                            
                            switch response.result {
                            case .success(let value):
//                                print("value: \(value)")
                                let resultdata = JSON.init(parseJSON: value)
                                
                                let dataObj = resultdata["data"][0]
                                
                                var temp = dataObj["location"].rawString()
                                var resultUrl = temp! + "?d=1&Authorization=\(dataObj["encodedContractSeq"])&DeviceType=avatar&page_type=graph&avatar_id=\(avatarId)&Form_ID=&AvatarType=beans&form_submission_stage_seq=0&AgentWSID=\(uniqueKey)&systemCode=avatar&systemTypeCode=beans&systemTypeVersion=1.3&myHealthRecord=true&digitalOnePass=\(isOnePass)&token=\(token)"
//                                print(resultUrl)
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    if (temp == 0) {
                        Group {
                            HStack (alignment: .center) {
                                Image("main_app_icon")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                VStack(alignment: .leading) {
                                    Text("DNet")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    Text("검사수치 등에 기반한 여러 추천 서비스 등의 프리미움 서비스가 가능합니다")
                                        .font(.system(size: 14))
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.vertical)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                            .border(Color(white: 0.8))
                            .background(Color.white
                                .shadow(radius: 2)
                            )
                            .onTapGesture {
                                settings.screen = AnyView(WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v1/agent/patient/dnet.jsp"))
                            }
                        }
                        Group {
                            HStack (alignment: .center) {
                                Image("main_app_icon")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                VStack(alignment: .leading) {
                                    Text("DNet 병원지도 찾기")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    Text("DNet이 설치된 병원을 지도에서 찾을수 있습니다!")
                                        .font(.system(size: 14))
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.vertical)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                            .border(Color(white: 0.8))
                            .background(Color.white
                                .shadow(radius: 2)
                            )
                            .onTapGesture {
                                settings.screen = AnyView(Helper(selected: "인공신실 찾기"))
                            }
                        }
                    } else {
                        Group {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("칼륨")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                    HalfPieChart(entries: [PieChartDataEntry(value: 4.5, label: ""), PieChartDataEntry(value: 10.5, label: "")], color: .systemGreen, category: "4.5")
                                        .frame(height: 85)
                                    Text("2023-01-15 (3.5 ~ 5.5)")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("인")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                    HalfPieChart(entries: [PieChartDataEntry(value: 4.5, label: ""), PieChartDataEntry(value: 10.5, label: "")], color: .systemGreen, category: "4.5")
                                        .frame(height: 85)
                                    Text("2023-01-15 (4.5 ~ 5.5)")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                            }
                        }
                        Group {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("빈혈")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                    HalfPieChart(entries: [PieChartDataEntry(value: 4.5, label: ""), PieChartDataEntry(value: 27.5, label: "")], category: "4.5")
                                        .frame(height: 85)
                                    Text("2023-01-15 (12.0 ~ 16.0)")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("칼슘")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                    HalfPieChart(entries: [PieChartDataEntry(value: 4.5, label: ""), PieChartDataEntry(value: 16.5, label: "")], category: "4.5")
                                        .frame(height: 85)
                                    Text("2023-01-15 (8.2 ~ 10.5)")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                            }
                            
                            // 칼륨, 인, 빈혈, 칼슘 중 정상수치가 아닌 경우 나타나는듯?
                            Group {
                                HStack (alignment: .center) {
                                    Image("icon_problem_list")
                                        .resizable()
                                        .frame(width: 50, height: 80)
                                    VStack(alignment: .leading) {
                                        Text("교육자료 보러가기 >")
                                            .font(.system(size: 18))
                                            .foregroundColor(darkBrown)
                                            .fontWeight(.bold)
                                        Text("[빈혈] 수치가 정상범위보다 낮습니다.")
                                            .font(.system(size: 14))
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Text("[칼슘, 인] 수치가 정상범위보다 높습니다.")
                                            .font(.system(size: 14))
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.vertical)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                                .onTapGesture {
                                    settings.screen = AnyView(News(selected: "카드뉴스"))
                                }
                            }
                            Group {
                                HStack (alignment: .center) {
                                    Image("icon_problem_list")
                                        .resizable()
                                        .frame(width: 50, height: 80)
                                    VStack(alignment: .leading) {
                                        Text("영양불량 상태일 가능성이 있습니다. 교육자료(클릭)를 참고하시고, 의료진과 논의하여 영양사에게 상세한 영양평가를 받아 보길 권유해 드립니다. >>")
                                            .font(.system(size: 14))
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.vertical)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                                .onTapGesture {
                                    settings.screen = AnyView(News(selected: "영상뉴스"))
                                }
                            }
                            
                        }
                        
                    }
                }
                
                NavigationLink(destination: AnyView(FoodDetail())) {
                    VStack (alignment: .leading) {
                        
                        Group {
                            HStack {
                                Text("음식 ")
                                    .font(.system(size: 20))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Text(foodDate)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                            }
                            HStack {
                                Text("\(calorieVal, specifier: "%.0f") kcal")
                                    .font(.system(size: 20))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Text("목표 \(calorie, specifier: "%.0f")")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                            }
                            
                            if entries.count > 0 {
                                PieChart(entries: entries)
                                    .frame(height: 200)
                            }
                        }
                        Group {
                            
                            
                            Group {
                                VStack(alignment: .leading) {
                                    Text("칼륨")
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(potassiumVal, specifier: "%.1f") mg")
                                            .foregroundColor(darkBrown)
                                            .fontWeight(.bold)
                                        Text("목표 \(potassium / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(darkBrown)
                                    }
                                    // 칼륨 200% 일때의 값 구해야함! -> total 값 변경
                                    ProgressView(value: potassiumVal, total: potassium) {
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
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(sodiumVal, specifier: "%.1f") mg")
                                            .foregroundColor(darkBrown)
                                            .fontWeight(.bold)
                                        Text("목표 \(sodium / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(darkBrown)
                                    }
                                    // 나트륨 200% 일때의 값 구해야함! -> total 값 변경
                                    ProgressView(value: sodiumVal, total: sodium) {
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
                        Group {
                            Group {
                                VStack(alignment: .leading) {
                                    Text("인")
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(phosphorusVal, specifier: "%.1f") mg")
                                            .foregroundColor(darkBrown)
                                            .fontWeight(.bold)
                                        Text("목표 \(phosphorus / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(darkBrown)
                                    }
                                    // 인 200% 일때의 값 구해야함! -> total 값 변경
                                    ProgressView(value: phosphorusVal, total: phosphorus) {
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
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(calciumVal, specifier: "%.1f") mg")
                                            .foregroundColor(darkBrown)
                                            .fontWeight(.bold)
                                        Text("목표 \(calcium / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(darkBrown)
                                    }
                                    // 칼슘 200% 일때의 값 구해야함! -> total 값 변경
                                    ProgressView(value: calciumVal, total: calcium) {
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
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color(white: 0.8))
                    .background(Color.white
                        .shadow(radius: 2)
                    )
                }
                
                Group {
                    
                    // 체중, 수축기, 이완기, 혈당은 자가입력 값이 있으면 BarGraph 형태로 나와야함
                    NavigationLink(destination: AnyView(SelfInputs(selected: "운동"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("체중")
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Spacer()
                                if weightEntries.count == 0 {
                                    Text(" _ kg")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                } else {
                                    BarChart(entries: weightEntries, captions: weightAxis)
                                        .frame(height: 100)
                                }
                                
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                    NavigationLink(destination: AnyView(SelfInputs(selected: "운동"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("건체중")
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Spacer()
                                if dWeightEntries.count == 0 {
                                    Text(" _ kg")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                } else {
                                    BarChart(entries: dWeightEntries, captions: dWeightAxis)
                                        .frame(height: 100)
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                    NavigationLink(destination: AnyView(SelfInputs(selected: "운동"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("투석 전 체중")
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Spacer()
                                if beforeDialysisWeightEntries.count == 0 {
                                    Text(" _ kg")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                } else {
                                    BarChart(entries: beforeDialysisWeightEntries, captions: beforeDialysisWeightAxis)
                                        .frame(height: 100)
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                }
                
                Group {
                    NavigationLink(destination: AnyView(SelfInputs(selected: "운동"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("투석 후 체중")
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Spacer()
                                if afterDialysisWeightEntries.count == 0 {
                                    Text(" _ kg")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                } else {
                                    BarChart(entries: afterDialysisWeightEntries, captions: afterDialysisWeightAxis)
                                        .frame(height: 100)
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                    NavigationLink(destination: AnyView(SelfInputs(selected: "혈압"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("수축기")
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Spacer()
                                if highEntries.count == 0 {
                                    Text(" _ mmHg")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                } else {
                                    BarChart(entries: highEntries, captions: highAxis)
                                        .frame(height: 100)
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                    NavigationLink(destination: AnyView(SelfInputs(selected: "혈압"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("이완기")
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Spacer()
                                if lowEntries.count == 0 {
                                    Text(" _ mmHg")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                } else {
                                    BarChart(entries: lowEntries, captions: lowAxis)
                                        .frame(height: 100)
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                }
                
                Group {
                    NavigationLink(destination: AnyView(SelfInputs(selected: "혈당"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("혈당")
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                                    .fontWeight(.bold)
                                Spacer()
                                if bsEntries.count == 0 {
                                    Text(" _ mg/dl")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                } else {
                                    BarChart(entries: bsEntries, captions: bsAxis)
                                        .frame(height: 100)
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                    NavigationLink(destination: AnyView(SelfInputs(selected: "복약증상"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("증상 ")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    Text(self.symptomDate)
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                Spacer()
                                Text(self.symptomList)
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                    NavigationLink(destination: AnyView(SelfInputs(selected: "수면흡연"))) {
                        HStack (alignment: .top) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("수면/흡연/음주 ")
                                        .font(.system(size: 18))
                                        .foregroundColor(darkBrown)
                                        .fontWeight(.bold)
                                    Text(self.smokeDate)
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                Spacer()
                                Text(self.smokeVal)
                                    .font(.system(size: 18))
                                    .foregroundColor(darkBrown)
                            }
                            .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
                }
                
                if temp != 0 {
                    HStack {
                        PHRItem(id: 0, title: "처방약", image: "icon_medic", alarm: "0")
                        Spacer()
                        PHRItem(id: 1, title: "검사결과", image: "icon_checkup_result", alarm: "0")
                        Spacer()
                        PHRItem(id: 2, title: "투석정보/재활이력", image: "icon_payer", alarm: "0")
                    }
                }
                
                Group {
                    HStack (alignment: .center) {
                        Image("myhealth")
                            .resizable()
                            .frame(width: 80, height: 80)
                        VStack(alignment: .leading) {
                            Text("나의건강기록 가져오기")
                                .font(.system(size: 18))
                                .foregroundColor(darkBrown)
                                .fontWeight(.bold)
                            Text("나의건강기록앱이 설치되지 않았습니다.")
                                .font(.system(size: 14))
                                .lineLimit(20)
                        }
                        .padding(.vertical)
                        .padding(.leading, 10)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                    .border(Color(white: 0.8))
                    .background(Color.white
                        .shadow(radius: 2)
                    )
                    .onTapGesture {
                        settings.screen = AnyView(WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v1/myhealthrecord/patient/home_page/main.jsp"))
                    }
                }
                
                Spacer()
                    
            }
            .padding(.horizontal)
            .padding(.bottom,10)
            .navigationBarHidden(true)
            .onAppear {
                getData()
                self.getAgentList()
                self.getAgentDetail()
                self.checkAlarmProgress()
            }
        }

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
