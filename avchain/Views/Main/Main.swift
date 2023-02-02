//
//  Main.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Main: View {
    @State private var isSidebarOpened = false
    @State var attendToggle = UserDefaults.standard.bool(forKey: "attendToggle") ?? false
    @StateObject var settings = UserSettings()
    let today = KoreanDate.dbDateFormat.string(from: Date())
    
    // 네비게이션 타이틀 설정
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().backgroundColor = UIColor(darkBrown)
        
//        let existingConstraint = UINavigationBar.appearance().constraintWithIdentifier("UIView-Encapsulated-Layout-Height")
//        existingConstraint?.constant = 88.0
//        UINavigationBar.appearance().setNeedsLayout()
    }
    
    // 처음 진입 시 유저정보 가져와야함
    func getUserInfo() {
            UserDefaults.standard.set(false, forKey: "attendToggle")
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]
        
//            print(token)
//            print(avatarId)

            do {
                Alamofire.request("\(URLAddress.ADDRESS)/member/\(avatarId)", method: .get, encoding: URLEncoding.default, headers: headers)
                    .responseJSON{ (response) in
                        switch response.result {
                        case .success:
                            let json = JSON(response.result.value)
                            guard json["code"].string == "success" else {
                                return
                            }
                            
                            do{
                                var memberInfo = try? JSONDecoder().decode(MemberInfo.self, from: json["data"].rawData())
                                
                                UserDefaults.standard.setValue(memberInfo?.name, forKey: "name")
                                UserDefaults.standard.setValue(memberInfo?.birth, forKey: "birth")
                                UserDefaults.standard.setValue(memberInfo?.genderCode, forKey: "gender")
                                UserDefaults.standard.setValue(memberInfo?.email, forKey: "email")
                                UserDefaults.standard.setValue(memberInfo?.mobile, forKey: "mobile")
                                
                                //core에 obj 저장
                                let encoder = JSONEncoder()
                                if let encoded = try? encoder.encode(memberInfo) {
                                    UserDefaults.standard.setValue(encoded, forKey: "userData")
                                }
                                
                                //core에 obj 호출
                                if let savedData = UserDefaults.standard.object(forKey: "userData") as? Data {
                                    let decoder = JSONDecoder()
                                    if let savedObject = try? decoder.decode(MemberInfo.self, from: savedData) {
                                        print("restore Data",savedObject)
                                    }
                                }
                                
                            } catch{
                                print("err")
                            }

                        case .failure(_):
                            print("error...")
                        }
                    }
            } catch {
                print("정보조회 에러")
            }
//
//        }
    }
    
    func getCcrData() {
        
        print("get ccr data list")
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
    
            print(token)
            print(avatarId)

        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/ccr/list/beans/\(avatarId)", method: .get, encoding: URLEncoding.default, headers: headers)
                .responseJSON{ (response) in
                    print(response)
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value)
                        guard json["code"].string == "success" else {
                            return
                        }
                        
                        do{
                            let jsonData = json["data"][0]
                            let downloadFlag = jsonData["downloadFlag"]
                            let seqCode = jsonData["seq"]
                            
                            print("dw",downloadFlag.stringValue)
                            print("sq",seqCode)
                            
                            if(downloadFlag.stringValue == "F") {
                                getDownloadCcr(seqCode: seqCode.stringValue)
                            }
                            
                        } catch{
                            print("err")
                        }

                    case .failure(_):
                        print("error...")
                    }
                }
        } catch {
            print("정보조회 에러")
        }
        
    }
    
    func getDownloadCcr(seqCode: String){
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
        ]
        
        print("getDownloadCcr from PHR")
        
        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/ccr/download/\(avatarId)/\(seqCode)", method: .get, encoding: URLEncoding.default, headers:headers)
                        .responseJSON{ (response) in
                            
                            switch response.result {
                            case .success:
                                let json = JSON(response.result.value)
                                
//                                print("ssss",json)
                                var ccrDataInfo = try? JSONDecoder().decode(CCRRestData.self, from: json.rawData())
                                
                                
                                //check input result
//                                print(ABSQLite.select("*", table: "Medications"))
                                
                                
                                //테스트시 임시로 막음
                                //parse medication
//                                putMedDataInfo(dataInfo: ccrDataInfo!.medications[0])
//                                //parse problem
//                                putProblemInfo(dataInfo: ccrDataInfo!.problems[0])
//                                //parse vitalsigns
//                                putVitalsignsInfo(dataInfo: ccrDataInfo!.vitalsigns[0])
//                                //parse results
//                                putResultsInfo(dataInfo: ccrDataInfo!.results[0])
//                                //parse procedures
//                                putProceduresInfo(dataInfo: ccrDataInfo!.procedures[0])
//                                //parse encounters
//                                putEncountersInfo(dataInfo: ccrDataInfo!.encounters[0])

//                                실사용시 주석해제
                                putCcrStatus(seqCode: seqCode)
                                
                            case .failure(_):
                                print("error...")
                            }
                        }
        }
    }
    
    func putMedDataInfo(dataInfo: [String : [String]]){
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        
        let quantity = dataInfo["quantity"]
        let prescriptionNumber = dataInfo["prescriptionNumber"]
        let codeValue = dataInfo["codeValue"]
        let objectID = dataInfo["objectID"]
        let productName = dataInfo["productName"]
        let actorID = dataInfo["actorID"]
        let dateTimeType = dataInfo["dateTimeType"]
        let type = dataInfo["type"]
        let instruction = dataInfo["instruction"]
        let codeCodingSystem = dataInfo["codeCodingSystem"]
        let manufacturer = dataInfo["manufacturer"]
        let dateTimeValue = dataInfo["dateTimeValue"]
        let route = dataInfo["route"]
        let frequency = dataInfo["frequency"]
        let actorRole = dataInfo["actorRole"]
        
        if(quantity!.count > 0 ){
            for i in 0 ... quantity!.count-1 {
//                print(String(i) + ":" + quantity![i] + prescriptionNumber![i] + codeValue![i] + objectID![i] + productName![i] + actorID![i] + dateTimeType![i] + type![i] + instruction![i] + codeCodingSystem![i] + manufacturer![i] + dateTimeValue![i] + route![i] + frequency![i] + actorRole![i])
                
                
                ABSQLite.insert("INSERT INTO main.Medications (Phr_Id, Productname, User_Id, Type, Route, Frequency, Quantity,  Manufacturer, Instruction, Datetime_Type, Datetime_Value, Actor_Id, Actor_Role, Initial_Update, Last_Update, Flag, CCRDataObjectID, CodeValue, CodeCodingSystem, PrescriptionNumber, HashSeq) VALUES (0, \"\(productName![i])\", \"\(avatarId)\", \"\(type![i])\", \"\(route![i])\", \"\(frequency![i])\", \"\(quantity![i])\", \"\(manufacturer![i])\", \"\(instruction![i])\", \"\(dateTimeType![i])\", \"\(dateTimeValue![i])\", \"\(actorID![i])\", \"\(actorRole![i])\", \"0000.00.00 00:00:00\", \"\(today)\", 1, \"\(objectID![i])\", \"\(codeValue![i])\", \"\(codeCodingSystem![i])\", \"\(prescriptionNumber![i])\", 915)")
                
                
            }
        }
        
        
        
    }
    
    func putProblemInfo(dataInfo: [String : [String]]){
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        
        let status = dataInfo["status"]
        let codeValue = dataInfo["codeValue"]
        let codeCodingSystem = dataInfo["codeCodingSystem"]
        let actorID = dataInfo["actorID"]
        let dateTimeType = dataInfo["dateTimeType"]
        let dateTimeValue = dataInfo["dateTimeValue"]
        let actorRole = dataInfo["actorRole"]
        let description = dataInfo["description"]
        let type = dataInfo["type"]
        let additionalDescription = dataInfo["additionalDescription"]
        let objectID = dataInfo["objectID"]
        
        if(status!.count > 0 ){
            for i in 0 ... status!.count-1 {
//                print(String(i) + ":" + status![i] + codeValue![i] + codeCodingSystem![i] + actorID![i] + dateTimeType![i] + dateTimeValue![i] + actorRole![i] + description![i] + type![i] + additionalDescription![i] + objectID![i])
                
                
                ABSQLite.insert("INSERT INTO main.Problems (Phr_Id, Description, AdditionalDescription, User_Id, Type, Status, Datetime_Type, Datetime_Value, Actor_Id, Actor_Role, Initial_Update, Last_Update, Flag, CCRDataObjectID, CodeValue, CodeCodingSystem, HashSeq) VALUES (0, \"\(description![i])\", \"\(additionalDescription![i])\", \"\(avatarId)\", \"\(type![i])\", \"\(status![i])\", \"\(dateTimeType![i])\", \"\(dateTimeValue![i])\", \"\(actorID![i])\", \"\(actorRole![i])\", \"0000.00.00 00:00:00\", \"\(today)\", 1, \"\(objectID![i])\", \"\(codeValue![i])\", \"\(codeCodingSystem![i])\", 915)")
                
                
            }
        }
        
        
        
    }
    
    func putVitalsignsInfo(dataInfo: [String : [String]]){
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        
        let testResultValue = dataInfo["testResultValue"]
        let codeValue = dataInfo["codeValue"]
        let codeCodingSystem = dataInfo["codeCodingSystem"]
        let actorID = dataInfo["actorID"]
        let dateTimeType = dataInfo["dateTimeType"]
        let dateTimeValue = dataInfo["dateTimeValue"]
        let actorRole = dataInfo["actorRole"]
        let description = dataInfo["description"]
        let type = dataInfo["type"]
        let testResultUnit = dataInfo["testResultUnit"]
        let objectID = dataInfo["objectID"]
        
        if(testResultValue!.count > 0 ){
            for i in 0 ... testResultValue!.count-1 {
//                print(String(i) + ":" + testResultValue![i] + codeValue![i] + codeCodingSystem![i] + actorID![i] + dateTimeType![i] + dateTimeValue![i] + actorRole![i] + description![i] + type![i] + testResultUnit![i] + objectID![i])
                
                ABSQLite.insert("INSERT INTO main.VitalSigns (Phr_Id, Description, Type, User_Id, Testresult_Value, Testresult_Unit, Datetime_Type, Datetime_Value, Actor_Id, Actor_Role, Initial_Update, Last_Update, Flag, CCRDataObjectID, CodeValue, CodeCodingSystem, HashSeq) VALUES ('0', \"\(description![i])\", \"\(type![i])\", \"\(avatarId)\", \"\(testResultValue![i])\", \"\(testResultUnit![i])\", \"\(dateTimeType![i])\", \"\(dateTimeValue![i])\", \"\(actorID![i])\", \"\(actorRole![i])\", \"0000.00.00 00:00:00\", \"\(today)\", 1, \"\(objectID![i])\", \"\(codeValue![i])\", \"\(codeCodingSystem![i])\", 915)")
                
                
                
            }
        }
        
        
        
    }
    
    func putResultsInfo(dataInfo: [String : [String]]){
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        
        
        let testResultValue = dataInfo["testResultValue"]
        let codeValue = dataInfo["codeValue"]
        let codeCodingSystem = dataInfo["codeCodingSystem"]
        let actorID = dataInfo["actorID"]
        let dateTimeType = dataInfo["dateTimeType"]
        let dateTimeValue = dataInfo["dateTimeValue"]
        let actorRole = dataInfo["actorRole"]
        let description = dataInfo["description"]
        let type = dataInfo["type"]
        let testResultUnit = dataInfo["testResultUnit"]
        let objectID = dataInfo["objectID"]
        
        if(testResultValue!.count > 0 ){
            for i in 0 ... testResultValue!.count-1 {
//                print(String(i) + ":" + testResultValue![i] + codeValue![i] + codeCodingSystem![i] + actorID![i] + dateTimeType![i] + dateTimeValue![i] + actorRole![i] + description![i] + type![i] + testResultUnit![i] + objectID![i])
                
                
                ABSQLite.insert("INSERT INTO main.Results (Phr_Id, User_Id, Description, Type, Testresult_Value, Testresult_Unit, Datetime_Type, Datetime_Value, Actor_Id, Actor_Role, Initial_Update, Last_Update, Flag, CCRDataObjectID, CodeValue, CodeCodingSystem, HashSeq) VALUES ('0', \"\(avatarId)\", \"\(description![i])\", \"\(type![i])\", \"\(testResultValue![i])\", \"\(testResultUnit![i])\", \"\(dateTimeType![i])\", \"\(dateTimeValue![i])\", \"\(actorID![i])\", \"\(actorRole![i])\", \"0000.00.00 00:00:00\", \"\(today)\", 1, \"\(objectID![i])\", \"\(codeValue![i])\", \"\(codeCodingSystem![i])\", 915)")
                
                
            }
        }
        
        
        
    }
    
    func putProceduresInfo(dataInfo: [String : [String]]){
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        
        let codeValue = dataInfo["codeValue"]
        let codeCodingSystem = dataInfo["codeCodingSystem"]
        let actorID = dataInfo["actorID"]
        let actorRole = dataInfo["actorRole"]
        let dateTimeValue = dataInfo["dateTimeValue"]
        let description = dataInfo["description"]
        let additionalDescription = dataInfo["additionalDescription"]
        let objectID = dataInfo["objectID"]
        
        if(codeValue!.count > 0 ){
            for i in 0 ... codeValue!.count-1 {
//                print(String(i) + ":" + codeValue![i] + codeCodingSystem![i] + actorID![i] + actorRole![i] + dateTimeValue![i] + description![i] + additionalDescription![i] + objectID![i])
                
                ABSQLite.insert("INSERT INTO main.Procedures (Phr_Id, Description, AdditionalDescription, User_Id, Datetime_Value, Actor_Id, Actor_Role, Initial_Update, Last_Update, Flag, CCRDataObjectID, CodeValue, CodeCodingSystem, HashSeq) VALUES ('0', \"\(description![i])\", \"\(additionalDescription![i])\", \"\(avatarId)\", \"\(dateTimeValue![i])\", \"\(actorID![i])\", \"\(actorRole![i])\", \"0000.00.00 00:00:00\", \"\(today)\", 1, \"\(objectID![i])\", \"\(codeValue![i])\", \"\(codeCodingSystem![i])\", 915)")
                
                
                
                
            }
        }
        
        
    }
    
    func putEncountersInfo(dataInfo: [String : [String]]){
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        
        let consent = dataInfo["consent"]
        let location = dataInfo["location"]
        let codeValue = dataInfo["codeValue"]
        let codeCodingSystem = dataInfo["codeCodingSystem"]
        let actorID = dataInfo["actorID"]
        let actorRole = dataInfo["actorRole"]
        let dateTimeType = dataInfo["dateTimeType"]
        let dateTimeValue = dataInfo["dateTimeValue"]
        let description = dataInfo["description"]
        let type = dataInfo["type"]
        let objectID = dataInfo["objectID"]
        
        if(consent!.count > 0) {
            for i in 0 ... consent!.count-1 {
//                print(String(i) + ":" + consent![i] + location![i] + codeValue![i] + codeCodingSystem![i] + actorID![i] + actorRole![i] + dateTimeType![i] + dateTimeValue![i] + description![i] + type![i] + objectID![i])
                
                ABSQLite.insert("INSERT INTO main.Encounters (Phr_Id, User_Id, Description, Type, Location, Consent, Datetime_Type, Datetime_Value, Actor_Id, Actor_Role, Initial_Update, Last_Update, Flag, CCRDataObjectID, CodeValue, CodeCodingSystem, HashSeq) VALUES ('0', \"\(avatarId)\", \"\(description![i])\", \"\(type![i])\", \"\(location![i])\", \"\(consent![i])\", \"\(dateTimeType![i])\", \"\(dateTimeValue![i])\", \"\(actorID![i])\", \"\(actorRole![i])\", \"0000.00.00 00:00:00\", \"\(today)\", 1, \"\(objectID![i])\", \"\(codeValue![i])\", \"\(codeCodingSystem![i])\", 915)")
            }
        }
        
        
    }
    
    func putCcrStatus(seqCode: String){
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]
        
        let params :[String:Any?] = [
            "avatarId": avatarId,
            "seq":seqCode,
            "downloadFlag": "T",
            "pushFlag": "T"
        ]
        
        
        do {
            Alamofire.request("\(URLAddress.ADDRESS)/avatar/ccr/afterdownload", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON{ (response) in
                    print(response)
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value)
                        guard json["code"].string == "success" else {
                            print("error")
                            return
                        }
                        
                        
                        
                    case .failure(_):
                        print("error...")
                    }
                }
        } catch {
            print("통신에러")
        }
        
        
    }
    
    func checkDnetConnect(){
        
        print("getMemberHospital")
        
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/member/hospital/\(avatarId)", method: .get, encoding: URLEncoding.default, headers: headers)
                        .responseJSON{ (response) in
                            switch response.result {
                            case .success:
                                let json = JSON(response.result.value)
                                guard json["code"].string == "success" else {
                                    //통신은 성공했으나 데이터가져오기 실패인 경우
                                    return
                                }
                                
                                
                                do{
                                    
                                    var resultArray = json["data"].arrayObject
                                    
                                    if(resultArray == nil){
                                        //no data
                                        return
                                    }
                                    if((resultArray?.isEmpty) != nil){
                                        //no data
                                        return
                                    }
                                    
                                    for obj in resultArray! {
                                        let objData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)

                                        let getInstanceData = try JSONDecoder().decode(Datum.self, from: objData)
                                        print("병원데이터",getInstanceData)
                                        print("병원데이터 코드",getInstanceData.hospitalCode)
                                        print("병원데이터 부서",getInstanceData.departmentCode)
                                        print("병원데이터 동의",getInstanceData.agreement)
                                        
                                        UserDefaults.setValue(getInstanceData.hospitalCode, forKey: "hospitalCode")
                                        UserDefaults.setValue(getInstanceData.departmentCode, forKey: "departmentCode")
                                        UserDefaults.setValue(getInstanceData.agreement, forKey: "hospitalAgreement")
                                        
                                    }
                                    
                                    
                                } catch{
                                    print("fail")
                                }
                                
                                
                            case .failure(_):
                                print("error...")
                            }
                        }
        }
        
    }
    
    func checkEightWeek(){
        let token = UserDefaults.standard.string(forKey: "token")!
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
         
        do {
            Alamofire.request("https://agents.snubi.org:8443/agents/v1/agent/patient/check_base_form.jsp?avatar_id=\(avatarId)", method: .get, encoding: URLEncoding.default, headers: headers)
                        .responseString{ response in
                                    switch response.result {
                                    case .success(let value):
                                        var resultCore = value.trimmingCharacters(in: ["\n"])
                                        var resultArray = resultCore.split(separator: "@")
                                        
                                        if (resultArray[0] == "true") {
                                            UserDefaults.setValue(resultArray[0], forKey: "8weekStatus")
                                            UserDefaults.setValue(resultArray[1], forKey: "8weekStartDate")
                                            UserDefaults.setValue(resultArray[2], forKey: "8weekEndDate")
                                        } else {
//                                            print("8주 코칭 대상아님")
//                                            print("token",UserDefaults.standard.string(forKey: "token")!)
                                        }
                                        
                                    case .failure(let error):
                                        print(error)
                                    }
                        }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            ZStack {
                NavigationView {
                    Text("")
                        .ignoresSafeArea(edges: .top)
                        .navigationBarTitle("콩팥콩팥", displayMode: .inline)
//                        .foregroundColor(.brown)
                        .navigationBarItems(leading:
                            HStack {
                            Image("navigation_menu2")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .onTapGesture {
                                    isSidebarOpened.toggle()
                                }
                            },trailing:
                            HStack {
        //                    MainCalendar
                            Image("icon_calendar_white")
                                .resizable()
                                .frame(width: 25, height: 25)
//                                .padding(.horizontal, 3)
                                .onTapGesture {
                                    settings.screen = AnyView(MainCalendar())
                                }
        //                    MainNews
                            Image("navigation_alram")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 5)
                                .onTapGesture {
                                    settings.screen = AnyView(Survey())
                                }
        //                    Attendance
                            Text("\(self.attendToggle ? "8주" : "하루")")
                                .padding(.vertical, 7)
                                .padding(.horizontal, 3)
                                .border(.white)
                                .foregroundColor(.white)
                                .font(.system(size: 10, weight: .bold))
                                .frame(width: 25, height: 25)
                                .onTapGesture {
                                    settings.screen = AnyView(Attendance())
                                }
//                            .padding(.horizontal, 3)
                        })
                        
                }
                
                
                .padding(.top, 10)
                .ignoresSafeArea(edges: .top)
                    
                settings.screen
                    .padding(.bottom, UIScreen.main.bounds.height / 10)
                    .padding(.top, 48)
                BottomMenu()
                Sidebar(isSidebarVisible: $isSidebarOpened)
            }
            
            
            
            
            
        }
        .environmentObject(settings)
        .onAppear {
            getUserInfo()
            checkDnetConnect()
            checkEightWeek()
            getCcrData()
        }
    }
        
}

struct NavigationBarAccessor: UIViewControllerRepresentable {
    var callback: (UINavigationBar) -> (AnyView)
    private let proxyViewController = ProxyViewController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationBarAccessor>) -> UIViewController {
        self.proxyViewController.callback = callback
        return proxyViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationBarAccessor>) {
    }

    private class ProxyViewController: UIViewController {
        var callback: ((UINavigationBar) -> AnyView)?

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let navigationBar = self.navigationController?.navigationBar {
                _ = self.callback?(navigationBar)
            }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
