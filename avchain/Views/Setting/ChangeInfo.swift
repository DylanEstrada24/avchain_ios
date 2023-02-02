//
//  ChangeInfo.swift
//  avchain
//

import Foundation

import UIKit
import SwiftUI
import Alamofire
import SwiftyJSON

struct ChangeInfo: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var settings = UserSettings()
    
    @State var name = UserDefaults.standard.string(forKey: "name") ?? ""
    @State var birth = (UserDefaults.standard.string(forKey: "birth") ?? "").toDateForUserInfo()!
    @State var genderStr = UserDefaults.standard.string(forKey: "gender") ?? ""
    @State var nickName = UserDefaults.standard.string(forKey: "nickName") ?? ""
    @State var mobile = UserDefaults.standard.string(forKey: "mobile") ?? ""
    @State var items1 :[String] = ["남","여"]
    @State var date = Date()
    
    @State var gender:Int = 0 // 0 male , 1 female
//    @State var birth = Date()
    
    func putUserInfo(){
        
        
        //core에 obj 호출
        if var savedData = UserDefaults.standard.object(forKey: "userData") as? Data {
            let decoder = JSONDecoder()
            if var savedObject = try? decoder.decode(MemberInfo.self, from: savedData) {
                
                savedObject.name = self.name
                savedObject.birth = self.birth.toStringForUserInfo()
                savedObject.genderCode = self.gender == 0 ? "male" : "female"
                savedObject.mobile = self.mobile
                savedObject.password = UserDefaults.standard.string(forKey: "password") ?? ""
                
                
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
                                
                                UserDefaults.standard.setValue(self.name, forKey: "name")
                                UserDefaults.standard.setValue(self.birth.toStringForUserInfo(), forKey: "birth")
                                UserDefaults.standard.setValue(self.gender == 0 ? "male" : "female", forKey: "gender")
                                UserDefaults.standard.setValue(self.nickName, forKey: "nickName")
                                UserDefaults.standard.setValue(self.mobile, forKey: "mobile")

                            case .failure(_):
                                print("error...")
                            }
                        }
                } catch {
                    print("통신에러")
                }
            }
        }
        
        
    }
    
    var body: some View {
        ScrollView{
            Spacer()
            Text("정보 변경")
                .foregroundColor(.brown)
                .padding(.top, 50)
            Spacer()
            Group{
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
            }
            
            Group{
                HStack {
                    Text("별명")
                    TextField("별명 입력", text: $nickName)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            Group{
                HStack {
                    Text("연락처")
                    TextField(mobile, text: $mobile)
                        .padding()
                }
                    .padding(.horizontal)
                    .padding(.vertical, -3.0)
                    .frame(height: 40)
                Divider()
                    .background(.yellow)
            }
            Group{
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
                
            }
            Divider()
                .background(.yellow)
            
            Group{
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
//            Group{
//                HStack(spacing: 50) {
//                    Button("취소") {
//                        self.mode.wrappedValue.dismiss()
//                    }.buttonStyle(NormalButtonStyle(labelColor: .white, backgroundColor: .brown))
//                    Button("수정") {
//                        print("name",self.name)
//                        print("nick",self.nickName)
//                        print("mobile",self.mobile)
//                        print("gender",self.gender)
//                        print("date",self.birth.toStringForUserInfo())
//
//                        putUserInfo()
//                        self.mode.wrappedValue.dismiss()
//                    }.buttonStyle(NormalButtonStyle(labelColor: .white, backgroundColor: .brown))
//                }
//                .padding(.horizontal, 30)
//                .padding(.top, 10)
//
//            }
            
            Group {
                Group {
                    Text("취소")
                    .frame(maxWidth: .infinity)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(darkBrown)
                    .cornerRadius(100)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                }
                .onTapGesture {
                    self.mode.wrappedValue.dismiss()
                }
                
                Group {
                    Text("수정")
                    .frame(maxWidth: .infinity)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(.yellow)
                    .cornerRadius(100)
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold))
                }
                .onTapGesture {
                    print("name",self.name)
                    print("nick",self.nickName)
                    print("mobile",self.mobile)
                    print("gender",self.gender)
                    print("date",self.birth.toStringForUserInfo())

                    putUserInfo()
                    self.mode.wrappedValue.dismiss()
                }
            }
                
        }
        .padding(.horizontal,10)
        .navigationBarHidden(true)
        
    }
}

struct ChangeInfo_Previews: PreviewProvider {
    static var previews: some View {
        ChangeInfo()
    }
}
