//
//  FoodDetail.swift
//  avchain
//

import SwiftUI
import DGCharts

// 메인 음식 클릭 뷰
struct FoodDetail: View {
    @State var category = ["음식성분 분석", "식단기록"]
    @State var selected = "음식성분 분석"
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
                case "음식성분 분석":
                    FoodIngredients()
                case "식단기록":
                    FoodRecord()
                default:
                    emptySpace()
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct FoodIngredients: View {
    // 하루열량
    // 단백질
    // 탄수화물
    // 지방
    // 나트륨 함량
    // 인 함량
    // 칼슘 함량
    // 위 값들은 DB에서 log랑 foodNew랑 조인해서 값 합쳐야하나? ... JY
    
    //  음식      열량    단백   탄수  지방   나트륨  인   칼슘
    // {"고구마", "120", "10", "5", "20", "3", "7", "20"}
    // {"오렌지", "300", "7",  "10","6",  "9", "9", "30"}
    //           420    17    15   26    12   16   50
    //   합산된 데이터는 디비에 넣고 오늘자 음식 데이터에 추가한다.
    //   해당데이터를 메인에서 출력
    
    var header = ["하루열량", "단백질", "탄수화물", "지방", "나트륨 함량", "인 함량", "칼슘 함량"]
    var whereSet = ["하루열량", "단백질", "탄수화물", "지방", "나트륨", "인", "칼슘"]
    @State var calorieList: LineChartData = [] // 열량
    @State var calorieCaption: [String] = []
    @State var proteinList: LineChartData = [] // 단백질
    @State var proteinCaption: [String] = []
    @State var carbohydrateList: LineChartData = [] // 탄수화물
    @State var carbohydrateCaption: [String] = []
    @State var fatList: LineChartData = [] // 지방
    @State var fatCaption: [String] = []
    @State var sodiumList: LineChartData = [] // 나트륨
    @State var sodiumCaption: [String] = []
    @State var phosphorusList: LineChartData = [] // 인
    @State var phosphorusCaption: [String] = []
    @State var calciumList: LineChartData = [] // 칼슘
    @State var calciumCaption: [String] = []
    
    private func getData() {
        do {
            var data: [Dictionary<AnyHashable, Any>]
            // 하루열량
            for i in whereSet {
                data = ABSQLite.select(" category, sum(input) as input, created ", table: " (select category, input, substr(created, 1, 8) as created from SelfInput) where category = '\(i)' group by category, created order by created desc limit 0, 7 ")
                
                var c: [String] = []
                
                let entries: [ChartDataEntry] = (0 ..< data.count).map { (i) -> ChartDataEntry in
                    var v = data[data.count - i - 1]["input"] ?? 0 // int / double
                    
                    var tempV:Double = 0.0
                    
                    if let intValue = v as? Int32 {
                         print(intValue)
                        
                        tempV = Double(intValue as! Int32)
                    }
                    
                    if let doubleValue = v as? Double {
                         print(doubleValue)
                        tempV = doubleValue
                    }
                    
                    
                    
                    let caption = (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).prefix(2) + "/" + (data[data.count - i - 1]["created"]! as! String).prefix(8).suffix(4).suffix(2)
                    c.append(String(caption))
                    
                    return ChartDataEntry(x: Double(data.count - i - 1), y: tempV)
                }
                
                let dataSet = LineChartDataSet(entries: entries)
                dataSet.setColor(.systemBlue)
                dataSet.label = i
                let lineChartData = LineChartData(dataSet: dataSet)
                
                switch(i) {
                    case "하루열량": self.calorieList = lineChartData; self.calorieCaption = c
                    case "단백질": self.proteinList = lineChartData; self.proteinCaption = c
                    case "탄수화물": self.carbohydrateList = lineChartData; self.carbohydrateCaption = c
                    case "지방": self.fatList = lineChartData; self.fatCaption = c
                    case "나트륨": self.sodiumList = lineChartData; self.sodiumCaption = c
                    case "인": self.phosphorusList = lineChartData; self.phosphorusCaption = c
                    case "칼슘": self.calciumList = lineChartData; self.calciumCaption = c
                    default: print("default")
                }
            }
        } catch {
            print("음식성분 조회 실패")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0 ..< header.count) { item in
                    Group {
                        Text(header[item])
                            .foregroundColor(darkBrown)
                            .font(.body)
                            .bold()
                        switch(header[item]) {
                            case "하루열량":
                                    LineChart(data: calorieList, captions: calorieCaption)
                                        .frame(height: 200)
                                        .padding(.horizontal)
                            case "단백질":
                                    LineChart(data: proteinList, captions: proteinCaption)
                                        .frame(height: 200)
                                        .padding(.horizontal)
                            case "탄수화물":
                                    LineChart(data: carbohydrateList, captions: carbohydrateCaption)
                                        .frame(height: 200)
                                        .padding(.horizontal)
                            case "지방":
                                    LineChart(data: fatList, captions: fatCaption)
                                        .frame(height: 200)
                                        .padding(.horizontal)
                            case "나트륨 함량":
                                    LineChart(data: sodiumList, captions: sodiumCaption)
                                        .frame(height: 200)
                                        .padding(.horizontal)
                            case "인 함량":
                                    LineChart(data: phosphorusList, captions: phosphorusCaption)
                                        .frame(height: 200)
                                        .padding(.horizontal)
                            case "칼슘 함량":
                                    LineChart(data: calciumList, captions: calciumCaption)
                                        .frame(height: 200)
                                        .padding(.horizontal)
                                    
                            default: Text("")
                        }
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                self.getData()
            }
        }
    }
}

struct FoodRecord: View {
    @StateObject var cm = CalendarManager(mode: .Week,
                                    startDate: .startDefault,
                                    endDate: .endDefault,
                                    startPoint: .current)
    @State var list: [Dictionary<AnyHashable, Any>] = [] // 식단기록 리스트
    @State var dateList: [String] = []
    
    private func getData(cc: CalendarComponents) {
        let month = cm.selectedComponent.month < 10 ? "0\(cm.selectedComponent.month)" : "\(cm.selectedComponent.month)"
        let day = cm.selectedComponent.day < 10 ? "0\(cm.selectedComponent.day)" : "\(cm.selectedComponent.day)"
        
        let date = "\(cc.year)-" + month + "-" + day
        let created = "\(cc.year)" + month + day + "%"
        
        do {
            var data = ABSQLite.select(" * ", table: " SelfInput where category = '음식' and created like '\(created)'")
            
            if data.count > 0 {
                print("식단기록 조회 성공")
                
                let formatter = DateFormatter()
               formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                
                for item in data {
                    var c = item["created"]! as! String // yyyyMMddHHmmss
                    if c.count < 14 {
                        c += "0"
                    }
                    let d = KoreanDate.dbDateFormat.date(from: c)
//
//                    created = formatter.string(from: date!)
                    self.dateList.append(d!.toStringForInput())
                    
                }
                self.list = data
            }
        } catch {
            print("식단기록 조회 실패")
        }
    }
    
    var body: some View {
        VStack {
            // 달력부분
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
                    getData(cc: cc)
                }
            }
            .background(calendarPurple)
            
            ScrollView {
                VStack {
                    if (self.list.isEmpty) {
                        HStack(alignment: .center) {
                            Image("icon_problem_list")
                                .resizable()
                                .frame(width: 25, height: 40, alignment: .leading)
                            VStack(alignment: .leading) {
                                Text("자료가 없습니다.") // drug_name
                                    .fontWeight(.bold)
                                    .font(.body)
                                Text("yyyy.mm.dd hh:mm:ss")
                                    .font(.system(size: 10))
                            }
                            Spacer()
                        }
                        Divider()
                    } else {
                        ForEach(0 ..< list.count) { item in
                            Group {
                                HStack(alignment: .center) {
                                    Image("icon_problem_list")
                                        .resizable()
                                        .frame(width: 25, height: 40, alignment: .leading)
                                    VStack(alignment: .leading) {
                                        Text("\(list[item]["category"]! as! String)") // food name
                                            .fontWeight(.bold)
                                            .font(.body)
                                        Text("\(dateList[item])") // yyyy-mm-dd hh:mm:ss
                                            .font(.system(size: 10))
                                    }
                                    Spacer()
                                }
                                Divider()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    getData(cc: self.cm.selectedComponent)
                }
            }
        }
        .onAppear {
//            getData()
        }
    }
}

struct FoodDetail_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetail()
    }
}
