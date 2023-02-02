//
//  FindPW.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON

class NumbersOnly: ObservableObject {
//    let limit: Int
//    init(
//        limit: Int
//    ) {
//        self.limit = limit
//    }
    
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}

var url = ""

struct FindPW: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var category = ["비밀번호 찾기", "이메일 찾기"]
    @State var selected = "비밀번호 찾기"
    @State var name = ""
    @State var email = ""
    @State var birth = Date()
    @State var items1 :[String] = ["남","여"]
    @State var itemSelected: Int = -1 // 성별, 0 = 남, 1 = 여
    @State var completed: Bool = false
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var msg:String = ""
    @State var msg2:String = ""
    
    func submit() {
        if self.name.isEmpty || self.itemSelected < 0 {
            self.showAlert.toggle()
            return
        }
        
        if self.selected == "이메일 찾기" {
            self.msg = "가입하신 이메일 주소"
            let dateParam = KoreanDate.dateParamFormat.string(from: self.birth)
            url = URLAddress.ADDRESS + "/find/email?name=\(self.name)&genderCode=\(self.itemSelected == 0 ? "male" : "female")&birth=\(dateParam)"
        } else {
            self.msg = "설정한 비밀번호"
            if self.email.isEmpty {
                self.showAlert.toggle()
                return
            }
            url = URLAddress.ADDRESS + "/find/password?name=\(self.name)&genderCode=\(self.itemSelected == 0 ? "male" : "female")&email=\(self.email)"
        }
        
        do {
            Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", method: .get, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .responseJSON{ (response) in
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value)
                        guard json["code"].string == "success" else {
                            self.alertMsg = json["message"].string ?? ""
                            self.showAlert.toggle()
                            return
                        }
                        self.msg2 = json["data"].string ?? ""
                        if selected == "비밀번호 찾기" {
                            self.msg2 = "이메일로 임시 비밀번호를 발송했습니다."
                        }
                        self.completed.toggle()
                    case .failure(_):
                        print("error...")
                    }
                }
        } catch {
            print("서버통신 에러")
            self.alertMsg = "서버통신 중 에러 발생"
            self.showAlert.toggle()
        }
        
    }
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("비밀번호 ･ 이메일 찾기")
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
                }
                .padding(.vertical)
            }
            // 카테고리 끝
            if self.completed {
                Spacer()
                Group {
                    VStack {
                        Text(msg)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(msg2)
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .underline(true, color: .yellow)
                    }
                }
                Spacer()
                Group {
                    VStack {
                        NavigationLink("로그인 페이지로 이동") {
                            Login()
                        }
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth:.infinity, maxHeight: .none)
                            .background(
                                Color.yellow
                            )
                            .cornerRadius(25)
                            .font(.system(size: 20, weight: .bold))
                        
                        Text("취소")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth:.infinity, maxHeight: .none)
                            .background(
                                Color.yellow
                            )
                            .cornerRadius(25)
                            .font(.system(size: 20, weight: .bold))
                            .onTapGesture {
                                self.name = ""
                                self.itemSelected = -1
                                self.email = ""
                                self.birth = Date()
                                self.completed.toggle()
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text(alertMsg), dismissButton: .default(Text("확인")))
                            }
                    }
                }
            } else {
                // 텍스트 인풋 시작
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
//                        .padding(.vertical, -5.0)
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
                                                self.itemSelected = selected
                                                print("\(selected)")
                                            },
                                            selectedID: self.itemSelected
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
//                        .padding(.vertical, -5.0)
                    // 분기
                    if (selected == "비밀번호 찾기") {
                        HStack {
                            Text("이메일")
                                
                            TextField("이메일", text: $email)
                                .padding()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, -3.0)
                        .frame(height: 40)
                    } else {
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
                    }
                    Divider()
                        .background(.yellow)
//                        .padding(.vertical, -5.0)
                }
                .padding(.horizontal)
                // 텍스트 인풋 끝
                Spacer()
                Group {
                    VStack {
                        Text("확인")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth:.infinity, maxHeight: .none)
                            .background(
                                Color.yellow
                            )
                            .cornerRadius(25)
                            .font(.system(size: 20, weight: .bold))
                            .onTapGesture {
                                submit()
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text(alertMsg), dismissButton: .default(Text("확인")))
                            }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarHidden(true)

    }
}

struct FindPW_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FindPW()
                .previewDevice("iPhone 12")
        }
    }
}
