//
//  AgentShare.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct AgentShare: View {
    
    @EnvironmentObject var settings: UserSettings
    
    @State var weight1 = false
    @State var weight2 = false
    @State var weight3 = false
    @State var k = false
    @State var p = false
    @State var hb = false
    @State var ca = false
    @State var uricAcid = false
    @State var pth = false
    
    func postAgentInfo(){
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]
        
        var params:[[String:Any]] = [
        ]
        
        
        weight1 ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 2,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 2,  "agreement" : "I"])
        weight2 ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 3,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 3,  "agreement" : "I"])
        weight3 ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 4,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 4,  "agreement" : "I"])
        k ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 9,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 9,  "agreement" : "I"])
        p ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 10,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 10,  "agreement" : "I"])
        hb ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 11,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 11,  "agreement" : "I"])
        ca ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 12,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 12,  "agreement" : "I"])
        uricAcid ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 13,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 13,  "agreement" : "I"])
        pth ? params.append(["agentSeq" : 1,  "agentPHRSeq" : 14,  "agreement" : "V"]) : params.append(["agentSeq" : 1,  "agentPHRSeq" : 14,  "agreement" : "I"])
        
        do {

                let url = URL(string: "\(URLAddress.ADDRESS)/PHR/contract/add")
                var request = URLRequest(url: url!)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])

                Alamofire.request(request).responseJSON { (response) in
                    switch response.result {
                    case .success:
                      //  print(response.result.value)
                        break
                    case .failure:
                        print(response.error)
                        break
                    }
                }
        } catch {
            print("error")
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
                                    //didnt work
                                    let agentInfo = try? JSONDecoder().decode(AgentListData.self, from: json["data"].rawData())
                                    
                                    var tempObj = json["data"][0]
                                    var phrServiceObj = tempObj["agentServicePHRs"]
                                    
                                    for i in 0 ... phrServiceObj.count-1{
                                        print(" agentSeq :\(phrServiceObj[i]["agentSeq"])  phrSeq: \(phrServiceObj[i]["clsAgentPHR"]["agentPhrSeq"])    phr vaild: \(phrServiceObj[i]["clsAgentPHR"]["valid"]) ")
                                        
                                        switch phrServiceObj[i]["clsAgentPHR"]["agentPhrSeq"] {
                                        case 2:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                weight1 = true
                                            } else {
                                                weight1 = false
                                            }
                                            break
                                        case 3:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                weight2 = true
                                            } else {
                                                weight2 = false
                                            }
                                            break
                                        case 4:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                weight3 = true
                                            } else {
                                                weight3 = false
                                            }
                                            break
                                        case 9:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                k = true
                                            } else {
                                                k = false
                                            }
                                            break
                                        case 10:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                p = true
                                            } else {
                                                p = false
                                            }
                                            break
                                        case 11:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                hb = true
                                            } else {
                                                hb = false
                                            }
                                            break
                                        case 12:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                ca = true
                                            } else {
                                                ca = false
                                            }
                                            break
                                        case 13:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                uricAcid = true
                                            } else {
                                                uricAcid = false
                                            }
                                            break
                                        case 14:
                                            if(phrServiceObj[i]["clsAgentPHR"]["valid"] == "V"){
                                                pth = true
                                            } else {
                                                pth = false
                                            }
                                            break
                                        default:
                                            print("empty data")
                                            break
                                        }
                                        
                                        
                                        
                                    }
                                    // 1:2
                                    
                                    
                                
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("에이전트별-선별공유")
                VStack(alignment: .leading) {
                    HStack {
                        Toggle("", isOn: $weight1)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("건체중")
                            .font(.caption)
                            .onTapGesture {
                                self.weight1.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $weight2)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("투석 전 체중")
                            .font(.caption)
                            .onTapGesture {
                                self.weight2.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $weight3)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("투석 후 체중")
                            .font(.caption)
                            .onTapGesture {
                                self.weight3.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $k)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("K")
                            .font(.caption)
                            .onTapGesture {
                                self.k.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $p)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("P")
                            .font(.caption)
                            .onTapGesture {
                                self.p.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $hb)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("Hb")
                            .font(.caption)
                            .onTapGesture {
                                self.hb.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $ca)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("Ca")
                            .font(.caption)
                            .onTapGesture {
                                self.ca.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $uricAcid)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("Uric Acid")
                            .font(.caption)
                            .onTapGesture {
                                self.uricAcid.toggle()
                            }
                        Spacer()
                    }
                    HStack {
                        Toggle("", isOn: $pth)
                            .toggleStyle(ToggleSquareCheckbox(color: .brown))
                            .font(.title)
                        Text("PTH")
                            .font(.caption)
                            .onTapGesture {
                                self.pth.toggle()
                            }
                        Spacer()
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                HStack {
                    Spacer()
                    Text("확인")
                        .frame(maxWidth: .infinity)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(.yellow)
                        .cornerRadius(100)
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.vertical)
                        .onTapGesture {
                            postAgentInfo()
                            settings.screen = AnyView(Helper())
                        }
                }
            }
        }
        .onAppear(){
            getAgentList()
        }
    }
}

struct AgentShare_Previews: PreviewProvider {
    static var previews: some View {
        AgentShare()
    }
}
