//
//  ChangePW.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ChangePW: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var current = ""
    @State var newPW = ""
    @State var newPW2 = ""
    @State var showAlert:Bool = false
    @State var alertMsg:String = ""
    
    private func changePW() {
        if newPW != newPW2 {
            print("did not match")
            return
        }
        
        let passOrigin = UserDefaults.standard.string(forKey: "password") ?? ""
        if passOrigin == current {
            
            //core에 obj 호출
            if var savedData = UserDefaults.standard.object(forKey: "userData") as? Data {
                let decoder = JSONDecoder()
                if var savedObject = try? decoder.decode(MemberInfo.self, from: savedData) {
                    
                    savedObject.name = self.newPW
                    
                    
                    let optionalDict = savedObject.dictionary
                    
                    let headers: HTTPHeaders = [
                        "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token")!)",
                        "Accept": "application/json",
                        "Content-Type":"application/json"
                    ]
                    
                    
                    do {
                        Alamofire.request("\(URLAddress.ADDRESS)/member", method: .put, parameters: optionalDict!, encoding: JSONEncoding.default, headers: headers)
                            .responseJSON{ (response) in
                                switch response.result {
                                case .success:
                                    let json = JSON(response.result.value)
                                    guard json["code"].string == "success" else {
                                        print("error")
                                        return
                                    }
                                    
                                    UserDefaults.standard.setValue(self.newPW, forKey: "password")

                                case .failure(_):
                                    print("error...")
                                }
                            }
                    } catch {
                        print("통신에러")
                    }
                }
            }
            
        } else {
            print("did not match")
        }
        
        

    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Image(systemName: "multiply")
                    .font(.title)
                    .onTapGesture {
                        self.mode.wrappedValue.dismiss()
                    }
            }
            Group {
                Text("비밀번호 변경")
                    .bold()
                    .foregroundColor(darkBrown)
                Text("비밀번호는 숫자 또는 문자 최소10자 이상 또는\n숫자+문자조합 최소8자 이상 20자 이하로 만들어 주세요")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            
            VStack {
                VStack(alignment: .leading) {
                    Text("현재 비밀번호")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    SecureField("", text: $current)
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                    Divider()
                        .background(.yellow)
                }
                VStack(alignment: .leading) {
                    Text("새 비밀번호")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    SecureField("", text: $newPW)
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                    Divider()
                        .background(.yellow)
                }
                VStack(alignment: .leading) {
                    Text("새 비밀번호 확인")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    SecureField("", text: $newPW2)
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                    Divider()
                        .background(.yellow)
                }
            }
            .padding(.bottom, 30)
            
            Group {
                Text("비밀번호 변경")
                .frame(maxWidth: .infinity)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .background(darkBrown)
                .cornerRadius(100)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
            }
            .onTapGesture {
                // 비밀번호 변경 처리
                changePW()
            }
            
            Group {
                Text("취소")
                .frame(maxWidth: .infinity)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .background(.yellow)
                .cornerRadius(100)
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold))
            }
            .onTapGesture {
                self.mode.wrappedValue.dismiss()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
    }
}

struct ChangePW_Previews: PreviewProvider {
    static var previews: some View {
        ChangePW()
    }
}
