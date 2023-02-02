//
//  SelfManagement.swift
//  avchain
//

import SwiftUI
import DGCharts

struct SelfManagement: View {
//    @State var high = "" // 혈압 수축기
//    @State var low = "" // 혈압 이완기
//    @State var weight = "" // 체중
//    @State var bloodsugar = "" // 혈당
//    @State var calorie = "" // 하루 섭취 칼로리
//    @State var protein = "" // 단백질
//    @State var carbohydrate = "" // 탄수화물
//    @State var fat = "" // 지방
//    @State var potassium = "" // 칼륨
//    @State var phosphorus = "" // 인
//    @State var calcium = "" // 칼슘
//    @State var sodium = "" // 나트륨
    
    // 프로그레스바 설정값(total) -> SelfGoal - target
    @State var potassium = 0.0 // 목표 칼륨
    @State var phosphorus = 0.0 // 목표 인
    @State var calcium = 0.0 // 목표 칼슘
    @State var sodium = 0.0 // 목표 나트륨
    
    // 값들
    @State var anemia = 0.0 // 빈혈
    @State var high = 0.0 // 혈압H
    @State var low = 0.0 // 혈압L
    @State var hlDate = ""
    @State var fat = 0.0 // 지방
    @State var weight = 0.0 // 체중
    @State var weightDate = ""
    @State var carbohydrate = 0.0 // 탄수화물
    @State var protein = 0.0 // 단백질
    @State var bloodSugar = 0.0 // 혈당
    @State var bloodSugarDate = "" // 혈당
    @State var calorie = 0.0 // 하루열량
    
    @State var potassiumVal = 0.0 // 칼륨
    @State var phosphorusVal = 0.0 // 인
    @State var calciumVal = 0.0 // 칼슘
    @State var sodiumVal = 0.0 // 나트륨
    @State var foodDate = ""
    
    @State var symptomList: String = "" // 증상목록 - 부종 호흡곤란 거품뇨 변비 -> Y인것들만
    @State var symptomDate: String = "" // yyyy-MM-dd -> 마지막등록일
    
    @State var smokeVal = "" // 흡연(+/-) 음주(+/-)
    @State var smokeDate = "" // yyyy-MM-dd -> 마지막 등록일
    
    @State var entries: [PieChartDataEntry] = [] // 원형그래프 영양소 3개
    
    @EnvironmentObject var settings: UserSettings
    
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
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" category, sum(input) as input, created ", table: " ( select category, sum(input) as input, substr(created, 1, 8) as created from SelfInput where category in ('칼륨', '나트륨', '인', '칼슘') group by category, created ) where created = '20230121' group by category, created ")
            if data.count > 0 {
                var category = ""
                
                var date1: String = ""
                var date2: String = ""

                for item in data {
                    category = item["category"]! as! String
                    var v = item["input"]! as! Double
//                    var tempv = Double(v)
                    switch(category) {
                        case "칼륨": self.potassiumVal = v
                        case "칼슘": self.calciumVal = v
                        case "인": self.phosphorusVal = v
                        case "나트륨": self.sodiumVal = v
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
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '체중' order by created desc limit 0, 1 ")
            if data.count > 0 {

                let v = data[0]["input"]! as! Int32
                let tempv = Double(v)
                let date1 = (data[0]["created"]! as! String).prefix(4) + "-"
                let date2 = (data[0]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "-" +
                        (data[0]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                
                self.weight = tempv
                self.weightDate = String(date1 + date2)

            }
        } catch {
            print("등록한 체중정보 조회 에러")
        }
        
        // 수축기 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈압H' order by created desc limit 0, 1 ")
            if data.count > 0 {
                
                let v = data[0]["input"]! as! Int32
                let tempv = Double(v)
                let date1 = (data[0]["created"]! as! String).prefix(4) + "-"
                let date2 = (data[0]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "-" +
                        (data[0]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                
                self.high = tempv
                self.hlDate = String(date1 + date2)

            }
        } catch {
            print("등록한 이완기정보 조회 에러")
        }
        
        // 이완기 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈압L' order by created desc limit 0, 1 ")
            if data.count > 0 {
                
                let v = data[0]["input"]! as! Int32
                let tempv = Double(v)
                self.low = tempv
                
            }
        } catch {
            print("등록한 수축기정보 조회 에러")
        }
        
        // 혈당 조회
        do {
            var data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" * ", table: " SelfInput where category = '혈당' order by created desc limit 0, 1 ")
            if data.count > 0 {
                
                let v = data[0]["input"]! as! Int32
                let tempv = Double(v)
                let date1 = (data[0]["created"]! as! String).prefix(4) + "-"
                let date2 = (data[0]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "-" +
                        (data[0]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                
                self.bloodSugar = tempv
                self.bloodSugarDate = String(date1 + date2)
                
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
                
                self.symptomList = ""

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
                
                self.smokeVal = ""
                
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
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    Group {
                        VStack {
                            HStack (alignment: .top) {
                                Image("icon_checkup_result")
                                    .resizable()
                                    .frame(width: 50, height: 80)
                                VStack(alignment: .leading) {
                                    Text("자기관리 목표를 설정할수 있습니다.")
                                        .bold()
                                        .font(.system(size: 18))
                                        .foregroundColor(.brown)
                                    Text("목표설정 바로가기 >")
                                        .font(.system(size: 14))
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
                                settings.screen = AnyView(TargetSetting())
                            }
                        }
                        
                        DashedLine()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .frame(height: 1)
                            .foregroundColor(.yellow)
                            .padding(.vertical)
                        
                    }
                    
                    NavigationLink(destination: AnyView(FoodDetail())) {
                        VStack (alignment: .leading) {
                            HStack {
                                Text("음식 ")
                                    .font(.system(size: 20))
                                    .foregroundColor(.brown)
                                    .fontWeight(.bold)
                                Text(foodDate)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                            }
                            Text("\(calorie, specifier: "%.0f") kcal")
                                .font(.system(size: 20))
                                .foregroundColor(.brown)
                                .fontWeight(.bold)
                            HStack {
                                Spacer()
                                NavigationLink(destination: SelfInputs(selected: "음식")) {
                                    Text("음식추가")
                                        .foregroundColor(darkBrown)
                                        .padding(.init(top: 6.5, leading: 10, bottom: 6.5, trailing: 10))
                                        .background(Capsule().fill(lightYellow))
                                }
                            }
                            Group {
                                Text("3대영양소")
                                    .foregroundColor(darkBrown)
                                    .bold()
                                if entries.count > 0 {
                                    PieChart(entries: entries)
                                        .frame(height: 200)
                                }
                            }
                            Group {
                                VStack(alignment: .leading) {
                                    Text("칼륨")
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(potassiumVal, specifier: "%.1f") mg")
                                            .foregroundColor(.brown)
                                            .fontWeight(.bold)
                                        Text("+목표 \(potassium / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(.brown)
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
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(sodiumVal, specifier: "%.1f") mg")
                                            .foregroundColor(.brown)
                                            .fontWeight(.bold)
                                        Text("+목표 \(sodium / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(.brown)
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
                            Group {
                                VStack(alignment: .leading) {
                                    Text("인")
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(phosphorusVal, specifier: "%.1f") mg")
                                            .foregroundColor(.brown)
                                            .fontWeight(.bold)
                                        Text("+목표 \(phosphorus / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(.brown)
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
                                        .foregroundColor(.brown)
                                        .fontWeight(.bold)
                                    HStack {
                                        Text("\(calciumVal, specifier: "%.1f") mg")
                                            .foregroundColor(.brown)
                                            .fontWeight(.bold)
                                        Text("+목표 \(calcium / 2, specifier: "%.1f")")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("%")
                                            .foregroundColor(.brown)
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
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(white: 0.8))
                        .background(Color.white
                            .shadow(radius: 2)
                        )
                    }
//                    Group {
                        Group {
                            NavigationLink(destination: AnyView(SelfInputs(selected: "운동"))) {
                                HStack (alignment: .top) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("체중 ")
                                                .font(.system(size: 18))
                                                .foregroundColor(.brown)
                                                .fontWeight(.bold)
                                            Text(weightDate)
                                                .bold()
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text("\(weight, specifier: "%.0f") kg")
                                            .font(.system(size: 18))
                                            .foregroundColor(.brown)
                                        HStack {
                                            Spacer()
                                            NavigationLink(destination: SelfInputs(selected: "운동")) {
                                                Text("체중추가")
                                                    .foregroundColor(darkBrown)
                                                    .padding(.init(top: 6.5, leading: 10, bottom: 6.5, trailing: 10))
                                                    .background(Capsule().fill(lightYellow))
                                            }
                                        }
                                    }
                                    .padding(.vertical)
                                }
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                            }
                            NavigationLink(destination: AnyView(SelfInputs(selected: "혈압"))) {
                                HStack (alignment: .top) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("혈압 ")
                                                .font(.system(size: 18))
                                                .foregroundColor(.brown)
                                                .fontWeight(.bold)
                                            Text(hlDate)
                                                .bold()
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text("\(high, specifier: "%.0f")/\(low, specifier: "%.0f") mmHg")
                                            .font(.system(size: 18))
                                            .foregroundColor(.brown)
                                        HStack {
                                            Spacer()
                                            NavigationLink(destination: SelfInputs(selected: "혈압")) {
                                                Text("혈압추가")
                                                    .foregroundColor(darkBrown)
                                                    .padding(.init(top: 6.5, leading: 10, bottom: 6.5, trailing: 10))
                                                    .background(Capsule().fill(lightYellow))
                                            }
                                        }
                                    }
                                    .padding(.vertical)
                                }
                                .padding(.horizontal)
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
                                        HStack {
                                            Text("혈당 ")
                                                .font(.system(size: 18))
                                                .foregroundColor(.brown)
                                                .fontWeight(.bold)
                                            Text(bloodSugarDate)
                                                .bold()
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text("\(bloodSugar, specifier: "%.0f") mg/dl")
                                            .font(.system(size: 18))
                                            .foregroundColor(.brown)
                                        HStack {
                                            Spacer()
                                            NavigationLink(destination: SelfInputs(selected: "혈당")) {
                                                Text("혈당추가")
                                                    .foregroundColor(darkBrown)
                                                    .padding(.init(top: 6.5, leading: 10, bottom: 6.5, trailing: 10))
                                                    .background(Capsule().fill(lightYellow))
                                            }
                                        }
                                    }
                                    .padding(.vertical)
                                }
                                .padding(.horizontal)
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
                                                .foregroundColor(.brown)
                                                .fontWeight(.bold)
                                            Text(symptomDate)
                                                .bold()
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text(symptomList)
                                            .font(.system(size: 18))
                                            .foregroundColor(.brown)
                                        HStack {
                                            Spacer()
                                            NavigationLink(destination: SelfInputs(selected: "복약증상")) {
                                                Text("증상추가")
                                                    .foregroundColor(darkBrown)
                                                    .padding(.init(top: 6.5, leading: 10, bottom: 6.5, trailing: 10))
                                                    .background(Capsule().fill(lightYellow))
                                            }
                                        }
                                    }
                                    .padding(.vertical)
                                }
                                .padding(.horizontal)
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
                                                .foregroundColor(.brown)
                                                .fontWeight(.bold)
                                            Text(smokeDate)
                                                .bold()
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text(smokeVal) // 저장한 값에 따라 - (아니오) 및 + (예)
                                            .font(.system(size: 18))
                                            .foregroundColor(.brown)
                                        HStack {
                                            Spacer()
                                            NavigationLink(destination: AnyView(SelfInputs(selected: "수면흡연"))) {
                                                Text("추가하기")
                                                    .foregroundColor(darkBrown)
                                                    .padding(.init(top: 6.5, leading: 10, bottom: 6.5, trailing: 10))
                                                    .background(Capsule().fill(lightYellow))
                                            }
                                        }
                                    }
                                    .padding(.vertical)
                                }
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color(white: 0.8))
                                .background(Color.white
                                    .shadow(radius: 2)
                                )
                            }
                    }
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
            .onAppear{
                getData()
            }
        }
    }
}

struct SelfManagement_Previews: PreviewProvider {
    static var previews: some View {
        SelfManagement()
    }
}
