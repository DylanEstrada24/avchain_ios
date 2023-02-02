//
//  Login.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON

var res:Any = ""

struct Login: View {
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var settings: UserSettings
    
    @State var email:String = ""
    @State var password:String = ""
    @State var showAlert:Bool = false
    @State var alertMsg:String = ""
    @State var autoLogin:Bool = false
    @State var isLogin:Bool = false
    
    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
    
    func login() {
        print("1111")
//        settings.isLogin=true
        guard !self.email.isEmpty else {
            self.alertMsg = "이메일을 입력해주세요"
            self.showAlert.toggle()
            return
        }
        
        print("2222")
        
        guard !self.password.isEmpty else {
            self.alertMsg = "비밀번호를 입력해주세요"
            self.showAlert.toggle()
            return
        }
        
        let params: [String: Any] = [
            "id": "", // nil
            "email": self.email,
            "password": self.password,
            "deviceId": ""
        ]
        
        res = params
        
        print("3333")
        do {
            Alamofire.request("\(URLAddress.ADDRESS)/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .responseJSON{ (response) in
                    print("44444, \(response)")
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value)
                        res = json
                        guard json["code"].string == "success" else {
                            print("success but error")
                            print("res",response)
                            self.alertMsg = json["message"].string ?? ""
                            self.showAlert.toggle()
                            return
                        }
                        
                        let token = json["token"].string ?? ""
                        let jwt = decode(jwtToken: token)
                        var tempArr = jwt["device-id"] as! NSArray
                        print("jwwttw0", tempArr[0])
                        print("jwwttw0", jwt["id"] as! String)
                        
                        UserDefaults.standard.setValue(token, forKey: "token")
                        UserDefaults.standard.setValue(self.email, forKey: "email")
                        UserDefaults.standard.setValue(self.password, forKey: "password")
                        UserDefaults.standard.setValue(self.autoLogin, forKey: "autoLogin")
                        UserDefaults.standard.setValue(jwt["id"] as! String, forKey: "avatarId")
                        UserDefaults.standard.setValue(jwt["name"] as! String, forKey: "name")
                        //일단 저장
                        UserDefaults.standard.set(tempArr, forKey: "device-id")
                        settings.isLogin=true
                        
                    case .failure(_):
                        print("error...")
                    }
                }
        } catch {
            print("로그인 에러")
            self.alertMsg = "로그인 중 에러가 발생했습니다."
            self.showAlert.toggle()
        }
        
    }
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Group {
                    HStack {
                        Text("로그인")
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
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top, 30)
                }
                Group {
                    Group {
                        VStack(alignment: .leading) {
                            Text("이메일")
                                .foregroundColor(.gray)
                            TextField("이메일", text: $email)
                                .padding(.horizontal)
                                .padding(.vertical, -3.0)
                                .frame(height: 40)
                            Divider()
                                .background(.yellow)
                        }
                    }
                    Group {
                        VStack(alignment: .leading) {
                            Text("비밀번호")
                                .foregroundColor(.gray)
                            SecureField("비밀번호", text: $password)
                                .padding(.horizontal)
                                .padding(.vertical, -3.0)
                                .frame(height: 40)
                            Divider()
                                .background(.yellow)
                        }
                    }
                    Group {
                        HStack(alignment: .center) {
                            Toggle("", isOn: $autoLogin)
                                .toggleStyle(ToggleCheckbox())
                                .font(.title)
                            Text("자동 로그인")
                                .font(.headline)
                                .onTapGesture {
                                    self.autoLogin.toggle()
                                }
                        }
                        .padding()
                    }
                    Group {
                        Text("로그인")
                            .frame(maxWidth: .infinity)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .background(.yellow)
                            .cornerRadius(100)
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                            .onTapGesture {
                                print("loginnn")
                                login()
                            }
                        HStack {
                            Spacer()
                            NavigationLink("회원가입 >") {
                                Enroll()
                            }
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.brown)
                            Spacer()
                            NavigationLink("비밀번호/이메일 찾기 >") {
                                FindPW()
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    
                }
                .padding(.horizontal)
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
