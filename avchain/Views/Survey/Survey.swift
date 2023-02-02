//
//  Survey.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON


struct SurveyItems: Hashable, Identifiable, Equatable {
    let id = UUID()
    let title: String
    let content: String
    let seq: Int
    var url: String
}

struct Survey: View {
    @EnvironmentObject var settings: UserSettings
    @State var selected = 0
    @State var showAlert: Bool = false
    @State var alertMsg = ""
    @State var surveyList:[SurveyItems] = []
    
    func loadData() {
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let uniqueKey = Int(Date().timeIntervalSince1970 * 1000)
        let url = "\(URLAddress.PLATFORM_ADDRESS)/form/list/schedule?avatarID=\(avatarId)"
        
        do {
            Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", method: .get, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .responseJSON{ (response) in
//                    print(response)
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value)
                        res = json
                        guard json["code"].string == "success" else {
                            return
                        }
                        
                        let surveyFormData = try? JSONDecoder().decode(SurveyFormData.self, from: json["data"].rawData())
                        print("info",surveyFormData)
                        
                        for i in 0 ... surveyFormData!.count-1 {
                            
                            var agentName = surveyFormData![i].agentServiceAvatar.agentName
                            var agentUrl = surveyFormData![i].agentServiceAvatar.location
                            var agentSeq = surveyFormData![i].agentServiceAvatar.agentSeq
                            
                            
                            let headers: HTTPHeaders = [
                                "Authorization": "Bearer \(token)"
                            ]
                            do {
                                Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/agent/\(agentSeq)", method: .get, encoding: URLEncoding.default, headers: headers)
                                            .responseString{ response in
                                                
                                                switch response.result {
                                                case .success(let value):
                    //                                print("value: \(value)")
                                                    let resultdata = JSON.init(parseJSON: value)
                                                    
                                                    let dataObj = resultdata["data"][0]
                                                    var agentEncodeSeq = dataObj["encodedContractSeq"].stringValue
                                                    
                                                    print("finish rest protocol")
                                                    
                                                    for j in 0 ... surveyFormData![i].listSetFormSubmissionStage.count-1 {
                                                        print("in j loop", agentEncodeSeq)
                                                        var formSeqNum = surveyFormData![i].listSetFormSubmissionStage[j].formSubmissionStageSeq
                                                        var formIsFinish = surveyFormData![i].listSetFormSubmissionStage[j].formSubmissionStage
                                                        var formUpdateDate = surveyFormData![i].listSetFormSubmissionStage[j].updateDate
                                                        var formUrl = surveyFormData![i].agentServiceAvatar
                                                        
                                                        if(formIsFinish.rawValue.contains("completed") ){
                                                            
                                                            var fixedUrl = formUrl.location + "?d=1&Authorization=\(agentEncodeSeq)&DeviceType=avatar&page_type=graph&avatar_id=\(avatarId)&Form_ID=&AvatarType=beans&form_submission_stage_seq=0&AgentWSID=\(uniqueKey)&systemCode=avatar&systemTypeCode=beans&systemTypeVersion=1.3&myHealthRecord=true&digitalOnePass=false&token=\(token)"
                        //
                                                            surveyList.append(SurveyItems(title: "\(agentName)(\(formSeqNum))", content: formUpdateDate, seq: formSeqNum, url: fixedUrl))
                                                        }
                                                    }
                                                    
                                                case .failure(let error):
                                                    print(error)
                                                }
                                            }
                            }
                            
                            
                        }
                        
                    case .failure(_):
                        print("error...")
                    }
                }
        } catch {
            print("서버통신 에러")
        }
    }
        var body: some View {
            VStack {
                Group {
                    HStack {
                        Spacer()
                        VStack {
                            Text("작성완료보관")
                                .foregroundColor(.brown)
                                .fontWeight(.bold)
    //                            .padding(.top, 20)
                                .offset(y: self.selected == 0 ? 8.5 : 0)
                            if self.selected == 0 {
                                Rectangle()
                                    .frame(width: 0, height: 5)
                                    .padding(.horizontal, 30)
                                    .background(Color.yellow)
                                    .offset(x: 0, y: 0)
                            }
                        }
                        .onTapGesture {
                            print("tapped")
                            self.selected = 0
                        }
                        Spacer()
                        VStack {
                            Text("작성요청대기")
                                .foregroundColor(.brown)
                                .fontWeight(.bold)
    //                            .padding(.top, 20)
                                .offset(y: self.selected == 1 ? 8.5 : 0)
                            if self.selected == 1 {
                                Divider()
                                    .frame(width: 0, height: 5)
                                    .padding(.horizontal, 30)
                                    .background(Color.yellow)
                            }
                        }
                        .onTapGesture {
                            print("tapped")
                            self.selected = 1
                        }
                        Spacer()
                    }
                    .padding(.vertical)
    //                Divider()
                }
                .background(Color(red: 223/255, green: 223/255, blue: 223/255))
                Group {
                    ScrollView{
                        VStack {
                            if self.selected == 0 {
                                ForEach(surveyList)  { item in
                                    Group {
                                        HStack(alignment: .center) {
                                            Image("icon_problem_list")
                                                .resizable()
                                                .frame(width: 30, height: 40, alignment: .leading)
                                            VStack(alignment: .leading) {
                                                Text(item.title)
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 16))
                                                Text(item.content)
                                                    .font(.system(size: 12))
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        Divider()
                                    }
                                    .onTapGesture {
                                        // 웹뷰 페이지로 이동
                                        print("tab agent")
                                        print(item.seq)
                                        print(item.url)
                                        settings.screen = AnyView(WebView(urlToLoad: item.url))
                                    }
                                }
                            } else {
                                Group {
                                    HStack(alignment: .center) {
                                        Image("icon_problem_list")
                                            .resizable()
                                            .frame(width: 30, height: 40, alignment: .leading)
                                        VStack(alignment: .leading) {
                                            Text("자료가 없습니다.") // drug_name
                                                .fontWeight(.bold)
                                                .font(.system(size: 16))
                                            Text("yyyy.mm.dd hh:mm:ss")
                                                .font(.system(size: 12))
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    Divider()
                                }
                            }
                            
                        }
                    }
                   
                }
                Spacer()
            }
            .onAppear {
                loadData()
            }
        }

}

struct Survey_Previews: PreviewProvider {
    static var previews: some View {
        Survey()
    }
}
