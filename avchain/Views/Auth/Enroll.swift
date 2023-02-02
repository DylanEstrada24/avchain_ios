//
//  Enroll.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Enroll: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var title = "약관동의"
    @State var step = 1
    @State var avatarId = ""
    @State var phoneCap = "010"
    @State var phone = ""
    
    @State var name = ""
    @State var gender = -1
    @State var birth = Date()
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        Group {
            Group {
                VStack(alignment: .leading) {
                    if self.step != 6 {
                        HStack {
                            Text(title)
                                .fontWeight(.bold)
                                .foregroundColor(.brown)
                                .font(.system(size: 30))
                            Spacer()
                            Image(systemName: "multiply")
                                .font(.title)
                                .onTapGesture {
                                self.mode.wrappedValue.dismiss()
                            }
                        }
                        .padding(.top, 30)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                    if self.step == 1 { // 약관 동의
                        EnrollStep1(step: self.$step, title: self.$title)
                    }
                    
                    if self.step == 2 { // 휴대폰 인증
                        EnrollStep2(
                            step: self.$step,
                            title: self.$title,
                            phoneCap: self.$phoneCap,
                            phone: self.$phone,
                            avatarId: self.$avatarId
                        )
                    }
                    
                    if self.step == 3 { // 회원정보 입력
                        EnrollStep3(
                            step: self.$step,
                            title: self.$title,
                            phoneCap: self.$phoneCap,
                            phone: self.$phone,
                            name: self.$name,
                            gender: self.$gender,
                            birth: self.$birth,
                            email: self.$email,
                            password: self.$password
                        )
                    }
                    
                    if self.step == 4 { // 병원정보 여부 분기
                        EnrollStep4(
                            step: self.$step,
                            title: self.$title,
                            phoneCap: self.$phoneCap,
                            phone: self.$phone,
                            name: self.$name,
                            gender: self.$gender,
                            birth: self.$birth,
                            email: self.$email,
                            password: self.$password,
                            avatarId: self.$avatarId
                        )
                    }
                    
                    if self.step == 5 { // 병원정보 입력
                        EnrollStep5(
                            step: self.$step,
                            title: self.$title,
                            phoneCap: self.$phoneCap,
                            phone: self.$phone,
                            name: self.$name,
                            gender: self.$gender,
                            birth: self.$birth,
                            email: self.$email,
                            password: self.$password,
                            avatarId: self.$avatarId
                        )
                    }
                    
                    if self.step == 6 { // 가입 완료
                        EnrollStep6()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct EnrollStep1: View {
    
    @Binding var step: Int
    @Binding var title: String
    
    @State var showAlert = false
    @State var allSelected = false
    @State var selected1 = false
    @State var selected2 = false
    @State var selected3 = false
    @State var selected4 = false
    
    func checkAccept() {
        if (!selected1 || !selected2 || !selected3 || !selected4) {
            showAlert.toggle()
            return
        }
        
        self.step += 1
        self.title = "본인인증"
        
    }
    
    var body: some View {
        Group { // Step 1
            HStack(alignment: .center) {
                Toggle("", isOn: $allSelected)
                    .toggleStyle(ToggleCheckbox())
                    .font(.title)
                Text("약관 전체 동의하기")
                    .font(.headline)
                    .onTapGesture {
                        self.allSelected.toggle()
//                        self.selected1 = self.allSelected
//                        self.selected2 = self.allSelected
//                        self.selected3 = self.allSelected
//                        self.selected4 = self.allSelected
                    }
                Spacer()
            }
            .padding(.horizontal)
            .onChange(of: allSelected) { newValue in
                self.selected1 = newValue
                self.selected2 = newValue
                self.selected3 = newValue
                self.selected4 = newValue
            }
            DashedLine()
               .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
               .frame(height: 1)
               .foregroundColor(.yellow)
               .padding(.horizontal)
            HStack(alignment: .center) {
                Toggle("", isOn: $selected1)
                    .toggleStyle(ToggleCheckbox())
                    .font(.title)
                Text("개인정보 수집 ･ \n이용 및 제공 동의서")
                    .font(.headline)
                    .onTapGesture {
                        self.selected1.toggle()
                    }
                Spacer()
                NavigationLink("상세보기 >") {
                    simpleView(text: TERMS_PRIVATE_INFO)
                    
                }
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            HStack(alignment: .center) {
                Toggle("", isOn: $selected2)
                    .toggleStyle(ToggleCheckbox())
                    .font(.title)
                Text("위치기반서비스 이용약관")
                    .font(.headline)
                    .onTapGesture {
                        self.selected2.toggle()
                    }
                Spacer()
                NavigationLink("상세보기 >") {
                    simpleView(text: TERMS_MAP_SERVICE)
                    
                }
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            HStack(alignment: .center) {
                Toggle("", isOn: $selected3)
                    .toggleStyle(ToggleCheckbox())
                    .font(.title)
                Text("(주)애브체인 \n개인정보 처리방침")
                    .font(.headline)
                    .onTapGesture {
                        self.selected3.toggle()
                    }
                Spacer()
                NavigationLink("상세보기 >") {
                    simpleView(text: TERMS_SERVICE_PRIVATE_INFO)
                    
                }
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            HStack(alignment: .center) {
                Toggle("", isOn: $selected4)
                    .toggleStyle(ToggleCheckbox())
                    .font(.title)
                Text("휴대폰 본인 확인 서비스")
                    .font(.headline)
                    .onTapGesture {
                        self.selected4.toggle()
                    }
                Spacer()
                NavigationLink("상세보기 >") {
                    simpleView(text: TERMS_MOBILE)
                    
                }
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            
            Spacer()
            
            Button("다음") {
                checkAccept()
            }
            .frame(maxWidth: .infinity)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .background(.yellow)
            .cornerRadius(100)
            .foregroundColor(.black)
            .font(.system(size: 20, weight: .bold))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("모든 약관에 동의해주셔야 합니다."), dismissButton: .default(Text("확인")))
            }
        }
    }
}

struct EnrollStep2: View {
    
    @Binding var step: Int
    @Binding var title: String
    @State var showAlert = false
    @State var alertMsg = ""
    var capList = ["010", "011", "016", "018", "019"]
    @Binding var phoneCap: String
    @Binding var phone: String
    @State var code = ""
    @Binding var avatarId: String
    @State var code2 = "" // 코드번호 대조할 것
    @State var bottomMsg = "휴대폰번호 입력후 인증번호요청을 누르면 문자로 인증번호가 발송됩니다. 문자를 확인하시고 4자리 인증번호를 입력하세요."
    
    func sendCode() {
        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/member/\(self.phoneCap)\( self.phone)", method: .get, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value)
                        self.bottomMsg = "문자메시지를 발송했습니다. 문자함에서 인증번호를 확인하고 인증번호 입력란에 입력후 확인을 눌러주세요! (오랫동안 문자가 안오면 다시 인증번호요청을 눌러주세요.)"
                        // 서버 올릴때 확인해야 할 부분 ... JY
                        // 1205 현재 인증코드가 리턴값으로 오며, 리턴코드가 error인 상태임 ... JY
                        guard json["code"].string == "success" else {
                            if json["code"].string == "error" {
                                if json["data"] != nil {
                                    //avataID userDefaults에 저장
                                    self.avatarId = json["data"]["avatarId"].string ?? ""
                                    self.code = json["data"]["mobileAuthNumber"].string ?? ""
                                    self.code2 = json["data"]["mobileAuthNumber"].string ?? ""
                                    
                                    print(json["data"])
                                    UserDefaults.standard.setValue(self.avatarId, forKey: "avatarId")
                                }
                            }
                            
//                            self.alertMsg = json["message"].string ?? ""
//                            self.showAlert.toggle()
                            return
                        }
                        
                        
                    case .failure(_):
                        print("error...")
                        self.alertMsg = "인증코드 발송 중 에러발생"
                        self.showAlert.toggle()
                    }
                }
        } catch {
            print("인증코드 발송 에러")
            self.alertMsg = "인증코드 발송 중 에러발생"
            self.showAlert.toggle()
        }
    }
    
    func checkCode() {
        // 인증코드 체크
        // 데브서버라서 인증이 안됨, 실서버 올리기 전 적용해야함 ... JY
//        let params: [String: Any] = [
//            "avatarId": "\(self.avatarId)",
//            "mobileNumber": "\(self.phoneCap)\(self.phone)",
//            "mobileAuthNumber": "\(self.code)"
//        ]
//        Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/member/mobile/auth", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
//            .responseJSON{ (response) in
//                if let JSON = response.result {
//                    print(JSON)
//                }
//            }
        
        // 성공 시 ..
        // 이 부분도 실서버 올리기전에 통신결과 성공 부분으로 옮겨야함 ... JY
        if self.code == self.code2 {
            self.step += 1
            self.title = "회원가입"
        }
    }
    
    var body: some View {
        Group { // Step 2
            HStack {
                Picker(phoneCap, selection: $phoneCap) {
                    ForEach(capList, id: \.self) {
                        Text($0)
                    }
                }
                .foregroundColor(.gray)
                TextField("휴대폰번호(8자리)", text: $phone)
                    .padding()
            }
            .padding(.horizontal)
            .padding(.vertical, -3.0)
            .frame(height: 40)
            Divider()
                .background(.yellow)
            
            Button("인증번호 요청") {
                sendCode()
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
            
            HStack {
                TextField("인증번호 입력", text: $code)
                    .padding()
            }
            .padding(.horizontal)
            .padding(.vertical, -3.0)
            .frame(height: 40)
            Divider()
                .background(.yellow)
            
            VStack(alignment: .center) {
                Text(self.bottomMsg)
                    .foregroundColor(.brown)
            }
            .frame(maxWidth: .infinity)
            Button("확인 ") {
                checkCode()
            }
            .frame(maxWidth: .infinity)
            .padding(.all)
            .background(.yellow)
            .cornerRadius(100)
            .foregroundColor(.black)
            .font(.system(size: 20, weight: .bold))
            .padding(.vertical)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMsg), dismissButton: .default(Text("확인")))
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct EnrollStep3: View {
    
    @Binding var step: Int
    @Binding var title: String
    @Binding var phoneCap: String
    @Binding var phone: String
    @State var showAlert = false
    @Binding var name: String
    @State var items1 :[String] = ["남","여"]
    @Binding var gender: Int // 성별, 0 = 남, 1 = 여
    @Binding var birth: Date
    @Binding var email: String
    @Binding var password: String
    @State var passwordCheck = ""
    @State var alertMsg = ""
    
    func next() {
        // 값 유효 체크
        
        if (self.name.isEmpty || self.gender < 0 || self.email.isEmpty || self.password.isEmpty || self.passwordCheck.isEmpty) {
            self.showAlert.toggle()
            self.alertMsg = "필수항목을 모두 입력해주세요."
            return
        }
        
        if (self.password != self.passwordCheck) {
            self.showAlert.toggle()
            self.alertMsg = "비밀번호를 확인해주세요."
            return
        }
        
        self.step += 1
        self.title = "병원정보"
    }
    
    var body: some View {
        Group { // Step 3
            Group {
                HStack {
                    Text("이름")
                    TextField("이름 입력", text: $name)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
                
                Group {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("성별")
                            Spacer()
                            HStack {
                                ForEach(Array(items1.enumerated()), id: \.offset) { idx, item in
                                    CustomRadioButton(
                                        title: item,
                                        id:idx,
                                        callback: { selected in
                                            self.gender = selected
                                            print("\(selected)")
                                        },
                                        selectedID: self.gender
                                    )
                                    .foregroundColor(.white)
                                    
                                     //버튼 설정
                                }
                            }
                            .padding(.leading)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                    }
                }
                .frame(height: 40)
                
                
                Divider()
                    .background(.yellow)
                
                HStack {
                    DatePicker(
                        "생일",
                        selection: $birth,
                        displayedComponents: [.date]
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, -3.0)
                .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            
            Group {
                HStack {
                    Text("이메일")
                        
                    TextField("이메일", text: $email)
                        .padding()
                }
                .padding(.horizontal)
                .padding(.vertical, -3.0)
                .frame(height: 40)
                Divider()
                    .background(.yellow)
                
                HStack {
                    Text("비밀번호")
                        
                    SecureField("비밀번호", text: $password)
                        .padding()
                }
                .padding(.horizontal)
                .padding(.vertical, -3.0)
                .frame(height: 40)
                Divider()
                    .background(.yellow)
                
                HStack {
                    Text("비밀번호 확인")
                        
                    SecureField("비밀번호 확인", text: $passwordCheck)
                        .padding()
                }
                .padding(.horizontal)
                .padding(.vertical, -3.0)
                .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            
            Button("다음") {
                next()
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
            
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct EnrollStep4: View {
    
    @Binding var step:Int
    @Binding var title: String
    @Binding var phoneCap: String
    @Binding var phone: String
    @Binding var name: String
    @Binding var gender: Int // 성별, 0 = 남, 1 = 여
    @Binding var birth: Date
    @Binding var email: String
    @Binding var password: String
    @Binding var avatarId: String
    @State var showAlert = false
    @State var alertMsg = ""
    
    func next() {
        self.step += 1
    }
    
    func enroll() {
        // 통신 ..
        
        
        
        let dateParam = KoreanDate.dateParamFormat.string(from: self.birth)
        
        var model = EnrollModel(email: self.email, genderCode: self.gender == 0 ? "male" : "female", phone: "\(self.phoneCap + self.phone)", birth: dateParam, password: self.password, name: self.name, avatarId: UserDefaults.standard.string(forKey: "avatarId")!, fcmToken: "avchainFcm")
        
        var param = model.createEnrollModel()
        
        
        
        Alamofire.request(URLAddress.ADDRESS + "/join", method: .post, parameters: param, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseJSON{ (response) in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value)
                    res = json
                    guard json["code"].string == "success" else {
                        self.alertMsg = json["message"].string ?? ""
                        self.showAlert.toggle()
                        
                        return
                    }
                    
                    // 회원가입 후 처리
                    print(res)
                    //성공했다면..
                    //param을 userDefaults에 넣는다.
//                    UserDefaults.standard.set(try? PropertyListEncoder().encode(param), forKey:"user")
                    
                    // 병원등록은 별도 api를 사용한다.
                    
                    self.step += 2
                    self.title = ""
                    
                case .failure(_):
                    print("error...")
                }
            }
        
    }
    var body: some View {
        Group {
            VStack(alignment: .center) {
                Text("현재 다니시는 병원이나 의원이 있으십니까?")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding()
            }
            HStack {
                Button("예") {
                    next()
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
                Spacer()
                Button("아니오") {
                    enroll()
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
            Spacer()
        }
    }
}

struct EnrollStep5: View {
    
    @Binding var step:Int
    @Binding var title: String
    @Binding var phoneCap: String
    @Binding var phone: String
    @Binding var name: String
    @Binding var gender: Int // 성별, 0 = 남, 1 = 여
    @Binding var birth: Date
    @Binding var email: String
    @Binding var password: String
    @Binding var avatarId: String
    @State var showAlert = false
    @State var alertMsg = ""
    
    @State var hosName1 = ""
    @State var hosDep1 = ""
    @State var hosDis1 = ""
    @State var hosName2 = ""
    @State var hosDep2 = ""
    @State var hosDis2 = ""
    
    func enroll() {
        // 통신 ..
        
        let dateParam = KoreanDate.dateParamFormat.string(from: self.birth)
        
        var model = EnrollModel(email: self.email, genderCode: self.gender == 0 ? "male" : "female", phone: "\(self.phoneCap + self.phone)", birth: dateParam, password: self.password, name: self.name, avatarId: UserDefaults.standard.string(forKey: "avatarId")!, fcmToken: "avchainFcm")
        
        var param = model.createEnrollModel()
        
        
        
        Alamofire.request(URLAddress.ADDRESS + "/join", method: .post, parameters: param, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseJSON{ (response) in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value)
                    res = json
                    guard json["code"].string == "success" else {
                        self.alertMsg = json["message"].string ?? ""
                        self.showAlert.toggle()
                        
                        return
                    }
                    
                    // 회원가입 후 처리
//                    print(res)
                    
                    // 병원등록은 별도 api를 사용한다.
                    // 토큰은 없어도 됨.
                    do {
                        
                        let dateInputParam = KoreanDate.dateInputFormat.string(from: Date())
                        
                        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
                        
                        
                        var list: [[String: Any]] = []
                        
                        list.append(["category": "hospital_name", "created": dateInputParam, "input": hosName1])
                        list.append(["category" : "department_name",  "created" : dateInputParam , "input" : hosDep1])
                        list.append(["category" : "disease_name",  "created" : dateInputParam , "input" : hosDis1])
                        list.append(["category" : "hospital_name2",  "created" : dateInputParam , "input" : hosName2])
                        list.append(["category" : "department_name2",  "created" : dateInputParam , "input" : hosDep2])
                        list.append(["category" : "disease_name2",  "created" : dateInputParam , "input" : hosDis2])
                        
                        
                        let url = URL(string: "\(URLAddress.INPUT_PLATFORM_ADDRESS)/avatar/selfinput/\(avatarId)/hospitalUserInput")
                            var request = URLRequest(url: url!)
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.httpMethod = "POST"
                            request.httpBody = try! JSONSerialization.data(withJSONObject: list, options: [])

                            Alamofire.request(request).responseJSON { (response) in
    //                            print("ressss",response)
                            }
                    } catch {
                        print("error")
                    }

                    
                    self.step += 2
                    self.title = ""
                    
                case .failure(_):
                    print("error...")
                }
            }
        
    }
    
    var body: some View {
        Group {
            Group {
                HStack {
                    TextField("병원이름", text: $hosName1)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            Group {
                HStack {
                    TextField("진료과", text: $hosDep1)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            Group {
                HStack {
                    TextField("상병명", text: $hosDis1)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            .padding(.bottom)
            Group {
                HStack {
                    TextField("병원이름", text: $hosName2)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            Group {
                HStack {
                    TextField("진료과", text: $hosDep2)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            Group {
                HStack {
                    TextField("상병명", text: $hosDis2)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            
            Button("다음") {
                enroll()
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
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct EnrollStep6: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        Group {
            VStack(alignment: .center) {
                Spacer()
                Image("main_app_icon") // 로고 이미지로 변경!! ... JY
                    .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.brown)
                Spacer()
                Text("회원가입이\n완료되었습니다")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.brown)
                    .multilineTextAlignment(.center)
                    .lineLimit(20)
                Spacer()
                Text("아바타빈즈 회원가입을\n축하드리며 건강을 기원합니다")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(20)
                Spacer()
                VStack {
                    NavigationLink(destination: Login() ) {
                        Text("로그인 페이지로 이동")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(.yellow)
                    .cornerRadius(100)
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold))
//                    Button("홈으로") {
//                        self.mode.wrappedValue.dismiss()
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//                    .background(.yellow)
//                    .cornerRadius(100)
//                    .foregroundColor(.black)
//                    .font(.system(size: 20, weight: .bold))
                }
                .padding(/*@START_MENU_TOKEN@*/.bottom, 50.0/*@END_MENU_TOKEN@*/)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct Enroll_Previews: PreviewProvider {
    static var previews: some View {
        Enroll()
    }
}
