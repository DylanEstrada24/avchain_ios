//
//  PHR.swift
//  avchain
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct PHRItem: View {
    var id: Int
    var title: String // 좌측상단
    var image: String // 이미지 에셋 이름
    var alarm: String? // 우측상단 회색숫자
    var alarm2: String? // 우측상단 회색숫자
    var alert: String? // 좌측하단 빨간숫자
//    var destination: String // PHRDetail로 보낼 제목
    
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @EnvironmentObject var settings: UserSettings
    
    
    private func toggleAlert(msg: String) {
        self.showAlert.toggle()
        self.alertMsg = msg
    }
    
    var body: some View {
        Group {
            VStack {
                HStack(alignment: .top) {
                    Text(title)
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                    VStack(){
                        if alarm != nil && alarm != "" {
                            Text("\(alarm ?? "")")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 8)
                                .background(.gray)
                                .cornerRadius(10)
                        }
                        if alarm2 != nil && alarm2 != "" {
                            Text("\(alarm2 ?? "")")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 8)
                                .background(.gray)
                                .cornerRadius(10)
                        }
                    }
                }
                Spacer()
                HStack(alignment: .bottom) {
                    if alert != nil && alert != "" {
                        Text("\(alert ?? "")")
                            .foregroundColor(.white)
                            .padding(4)
                            .background(.red)
                            .font(.caption2)
                            .cornerRadius(5)
                    }
                    Spacer()
                    Image(image)
                        .resizable()
                        .frame(width: 40, height: 50)
                }
            }
            .padding(10)
        }
        .border(Color(white: 0.8))
        .background(Color.white
            .shadow(radius: 2)
        )
        .frame(height: 130)
        .onTapGesture {
            if (id == 9999 ) {
                self.toggleAlert(msg: "준비중 기능입니다..")
            } else {
                settings.screen = AnyView(PHRDetail(title: title, id: id))
            }
            
        }
    }
}


struct PHR: View {
    
    @State var medicationCount:Int32 = 0
    @State var problemsCount:Int32 = 0
    @State var vitalsignsCount:Int32 = 0
    @State var resultsCount:Int32 = 0
    @State var proceduresCount:Int32 = 0
    @State var encountersCount:Int32 = 0
    
    func getDbCcrList() {
        
        let mediCount = ABSQLite.select("count(*) as count", table: "Medications")
        self.medicationCount = mediCount[0]["count"] as! Int32
        
        let problemsCount = ABSQLite.select("count(*) as count", table: "Problems")
        self.problemsCount = problemsCount[0]["count"] as! Int32
        
        let vitalsignsCount = ABSQLite.select("count(*) as count", table: "Vitalsigns")
        self.vitalsignsCount = vitalsignsCount[0]["count"] as! Int32
        
        let resultsCount = ABSQLite.select("count(*) as count", table: "Results")
        self.resultsCount = resultsCount[0]["count"] as! Int32
        
        let proceduresCount = ABSQLite.select("count(*) as count", table: "Procedures")
        self.proceduresCount = proceduresCount[0]["count"] as! Int32
        
        let encountersCount = ABSQLite.select("count(*) as count", table: "Encounters")
        self.encountersCount = encountersCount[0]["count"] as! Int32
        
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Group {
                    // itemp의 id는 실제 서버 데이터를 받게 될때 agentSeq
                    HStack {
                        PHRItem(id: 0, title: "처방약", image: "icon_medic", alarm: String(medicationCount))
                        Spacer()
                        PHRItem(id: 1, title: "검사결과", image: "icon_checkup_result", alarm: String(resultsCount))
                        Spacer()
                        PHRItem(id: 9999, title: "투석정보/재활이력", image: "icon_payer", alarm: "0")
                    }
                    HStack {
                        PHRItem(id: 3, title: "처치/시술", image: "icon_procedure", alarm: String(proceduresCount))
                        Spacer()
                        PHRItem(id: 4, title: "활력징후", image: "icon_vitality", alarm: String(vitalsignsCount))
                        Spacer()
                        //실행시 앱 다운됨... 확인 불가
                        PHRItem(id: 9999, title: "의료기관 방문기록", image: "icon_hospital_visit", alarm: "0")
                    }
                    HStack {
                        PHRItem(id: 9999, title: "알레르기 부작용", image: "icon_allergie", alarm: "0")
                        Spacer()
                        PHRItem(id: 9999, title: "예방접종", image: "icon_vaccination", alarm: "0")
                        Spacer()
                        PHRItem(id: 9999, title: "사전의료 지시", image: "icon_pre_medical", alarm: "0")
                    }
                    HStack {
                        PHRItem(id: 9999, title: "개인정보 보험정보", image: "icon_privacy", alarm: "0", alarm2: "0")
                        Spacer()
                        PHRItem(id: 6, title: "문제목록 기능평가", image: "icon_problem_list", alarm: String(problemsCount), alarm2: "0")
                        Spacer()
                        PHRItem(id: 9999, title: "가족력 사회력", image: "icon_family", alarm: "0", alarm2: "0")
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(true)
                Spacer()
                
            }.onAppear(){
                self.getDbCcrList()
    //            self.getDownloadCcr()
            }
        }
        
    }
}

struct PHR_Previews: PreviewProvider {
    static var previews: some View {
        PHR()
    }
}
