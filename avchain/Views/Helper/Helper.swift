//
//  Helper.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON
import UniformTypeIdentifiers

struct Helper: View {
    @State var category = ["콩팥진단", "Ai주치의", "인공신실 찾기", "상담실"]
    @State var selected: String = "콩팥진단"
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
                .navigationBarHidden(true)
                .background(gray)
            }
            // 카테고리 끝
            
            switch (selected) {
                case "콩팥진단":
                    Diagnosis()
                case "Ai주치의":
                    AiDoctor()
                case "인공신실 찾기":
                    WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v1/hospital_map/patient/home_page/main.jsp")
                case "상담실":
                    WebView(urlToLoad: "https://agents.snubi.org:8443/agents/v1/welfare/patient/home_page/main.jsp")
                default:
                    emptySpace()
            }
            Spacer()
        }
    }
}

struct Diagnosis: View {
    
    //드래그 지원
    struct DragDelegate<Item: Equatable>: DropDelegate {
        @Binding var current: Item?

        func dropUpdated(info: DropInfo) -> DropProposal? {
            DropProposal(operation: .move)
        }

        func performDrop(info: DropInfo) -> Bool {
            current = nil
            return true
        }
    }
    
//    func postAgentContractAdd() {
//
//        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
//        let token = UserDefaults.standard.string(forKey: "token") ?? ""
//
//        //agent list result
//        let params = [
//                  ["agentSeq" : 1,  "agentPHRSeq" : 2,  "agreement" : "I"],
//                  ["agentSeq" : 3,  "agentPHRSeq" : 1,  "agreement" : "I"]
//        ]
//
//
//
//        do {
//
//                let url = URL(string: "\(URLAddress.ADDRESS)/PHR/contract/add")
//                var request = URLRequest(url: url!)
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//                request.httpMethod = "POST"
//                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
//
//                Alamofire.request(request).responseJSON { (response) in
//                    switch response.result {
//                    case .success:
//                      //  print(response.result.value)
//                        break
//                    case .failure:
//                        print(response.error)
//                        break
//                    }
//                }
//        } catch {
//            print("error")
//        }
//
//    }
    
    //사용하지는 않음. 실제 구동되는 페이지가 많이 없기때문...
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
                                    print("agent full data",json["data"])
                                    let agentInfo = try? JSONDecoder().decode([AgentInfoElement].self, from: json["data"].rawData())
//                                    print("agentInfo",agentInfo)
//                                    agentInfo![0].agentServicePHRs![0].clsAgentPHR?.agentPhrSeq
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
    //
    func getAgentDetail(){
        print("getAgentDetail")
        let token = UserDefaults.standard.string(forKey: "token")!
        let avatarId = UserDefaults.standard.string(forKey: "avatarId")!
        let uniqueKey = Int(Date().timeIntervalSince1970 * 1000)
        let isPHR = UserDefaults.standard.string(forKey: "isPHR")!
        let isOnePass = UserDefaults.standard.string(forKey: "isOnePass")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        print("unix",uniqueKey)
        
        do {
            //jwt token
            //get은 application/json 넣어줄 필요 없음.
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/agent/1", method: .get, encoding: URLEncoding.default, headers: headers)
                        .responseString{ response in
                            
                            switch response.result {
                            case .success(let value):
//                                print("value: \(value)")
                                let resultdata = JSON.init(parseJSON: value)
                                
                                let dataObj = resultdata["data"][0]
                                
                                var temp = dataObj["location"].rawString()
                                items[1].url = temp! + "?d=1&Authorization=\(dataObj["encodedContractSeq"])&DeviceType=avatar&page_type=graph&avatar_id=\(avatarId)&Form_ID=&AvatarType=beans&form_submission_stage_seq=0&AgentWSID=\(uniqueKey)&systemCode=avatar&systemTypeCode=beans&systemTypeVersion=1.3&myHealthRecord=true&digitalOnePass=\(isOnePass)&token=\(token)"
                                
                                
                                //temp printing
//                                print("dddddddddddddd", temp! + "?d=1&Authorization=\(dataObj["encodedContractSeq"])&DeviceType=avatar&page_type=graph&avatar_id=\(avatarId)&Form_ID=&AvatarType=beans&form_submission_stage_seq=0&AgentWSID=\(uniqueKey)&systemCode=avatar&systemTypeCode=beans&systemTypeVersion=1.3&myHealthRecord=true&digitalOnePass=\(isOnePass)&token=\(token)")
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
        }
    }
    
    @State var items: [DiagnosisItems] = [
        DiagnosisItems(title: "콩팥건강 종합진단", content: "콩팥건강 종합진단", seq: 68, url: "https://agents.snubi.org:8443/agents/v1/agent/patient/diagnosis.jsp"),
        
        DiagnosisItems(title: "검사수치 기반 식단관리", content: "환자용 혈액 검사결과를 요약해주고, 결과에 따른 식이조절 방법을 알려줍니다.", seq: 1, url: "https://agents.snubi.org:8443/agents/v1/daily_labs/patient/home_page/main.jsp?avatarId=ID202208031328462207"),
        
        DiagnosisItems(title: "나의건강기록(보건복지부)", content: "나의건강기록(보건복지부)", seq: 56, url: "https://agents.snubi.org:8443/agents/v1/myhealthrecord/patient/home_page/main.jsp"),
        
        DiagnosisItems(title: "병원연결(진료카드등록)", content: "병원연결(진료카드등록) 에이전트", seq: 60, url: "https://agents.snubi.org:8443/agents/v1/card/patient/home_page/main.jsp")
    ]
    
    @EnvironmentObject var settings: UserSettings
    @State var dragging: DiagnosisItems?
    
    var body: some View {
        
        List{
            ForEach(items, id: \.self) { item in
                HelperItem(title: item.title, content: item.content, seq: item.seq)
                    .onTapGesture {
                        settings.screen = AnyView(WebView(urlToLoad: item.url))
                    }
                    .onDrag {
                                        self.dragging = item
                                        return NSItemProvider(object: NSString())
                                    }
                                    .onDrop(of: [UTType.text], delegate: DragDelegate(current: $dragging))
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
            }.onMove { from, to in
                items.move(fromOffsets: from, toOffset: to)
            }
        }
        .colorScheme(.light)
        .listStyle(.plain)
        .navigationBarHidden(true)
        .onAppear(){
            self.getAgentDetail()
            self.getAgentList()
        }
        
    }
    
}

struct AiDoctor: View {
    
    //드래그 지원
    struct DragDelegate<Item: Equatable>: DropDelegate {
        @Binding var current: Item?

        func dropUpdated(info: DropInfo) -> DropProposal? {
            DropProposal(operation: .move)
        }

        func performDrop(info: DropInfo) -> Bool {
            current = nil
            return true
        }
    }
    
    
    func getCurrentTimeStampWOMilisecondsThis(dateToConvert: NSDate) -> String {
            let objDateformat: DateFormatter = DateFormatter()
            objDateformat.dateFormat = "yyyy-MM-dd"
            let strTime: String = objDateformat.string(from: dateToConvert as Date)
            let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
            let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
            let strTimeStamp: String = "\(milliseconds)"
            return strTimeStamp
    }
    
    func makeUnique() -> String {
            let now             = NSDate()
            let nowTimeStamp    = getCurrentTimeStampWOMilisecondsThis(dateToConvert: now)
//            let lower : UInt32  = 100
//            let upper : UInt32  = 999
//            let randomNumber    = arc4random_uniform(upper - lower) + lower
            let id:String      = "\(nowTimeStamp)" // 13자리
            return id
    }

    //items객체가 move될때 UserDefaults에 저장
    @State var aiItems: [DiagnosisItems] = [
        DiagnosisItems(title: "콩팥운동 ai코치", content: "베타서비스", seq: 65, url:"https://pt.mindtrip.co.kr"),
        DiagnosisItems(title: "콩팥건강 8주", content: "콩팥건강 8주", seq: 69, url:"https://agents.snubi.org:8443/agents/v1/agent/patient/week8.jsp?avatarId=\(UserDefaults.standard.string(forKey: "avatarId") ?? "")"),
        DiagnosisItems(title: "PROM(설문지)", content: "PROM", seq: 70, url:"https://agents.snubi.org:8443/agents/v1/agent/patient/week8form.jsp"),
        DiagnosisItems(title: "약물분석", content: "약물분석", seq: 71, url:"https://agents.snubi.org:8443/agents/v1/myhealthrecord/patient/home_page/main.jsp"),
        DiagnosisItems(title: "유전체 분석", content: "준비중입니다.", seq: 72, url:"https://agents.snubi.org:8443/agents/v1/welfare/patient/home_page/main.jsp"),
        DiagnosisItems(title: "임상연구 참여", content: "준비중입니다.", seq: 73, url:"https://agents.snubi.org:8443/agents/v1/welfare/patient/home_page/main.jsp")
    ]
    
    
    @EnvironmentObject var settings: UserSettings
    @State var dragging: DiagnosisItems?
    
    var body: some View {
        List {
            ForEach(aiItems, id: \.self) { item in
                HelperItem(title: item.title, content: item.content, seq: item.seq)
                    .onTapGesture {
                        settings.screen = AnyView(WebView(urlToLoad: item.url))
                    }
                    .onDrag {
                        self.dragging = item
                        return NSItemProvider(object: NSString())
                    }
                    .onDrop(of: [UTType.text], delegate: DragDelegate(current: $dragging))
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
            }.onMove { from, to in
                aiItems.move(fromOffsets: from, toOffset: to)
            }
        }
        .colorScheme(.light)
        .listStyle(.plain)
        .navigationBarHidden(true)
        .onAppear(){
            //            self.getAgentDetail()
        }
    }
}

struct DiagnosisItems: Hashable, Identifiable, Equatable {
    let id = UUID()
    let title: String
    let content: String
    let seq: Int
    var url: String
}

struct Helper_Previews: PreviewProvider {
    static var previews: some View {
        Helper()
    }
}
