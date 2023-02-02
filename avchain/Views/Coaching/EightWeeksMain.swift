//
//  EightWeeksMain.swift
//  avchain
//

import SwiftUI

struct EightWeeksMain: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var settings: UserSettings
    @State var score = 0 // 출첵점수 ... JY
    
    private func getData() {
        // 점수 가져옴
        do {
            let data: [Dictionary<AnyHashable, Any>] = ABSQLite.select(" count(*) as score ", table: " myPoint where flag = '1' ")
            
            if data.count > 0 {
                let scoreData = data[0]["score"]! as! Int32
                self.score = Int(scoreData)
                print("점수 불러오기 성공")
            }
        } catch {
            print("점수 불러오기 실패")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Image("icon_checkup_result")
                        .resizable()
                        .frame(width: 30, height: 40)
                    Text("콩팥콩팥!")
                        .bold()
                        .font(.title)
                        .foregroundColor(darkBrown)
                }
                
                Text("콩팥건강 8주 코칭 프로그램에 참여하세요!")
                    .bold()
                    .font(.title2)
                    .foregroundColor(darkBrown)
                    .onTapGesture {
                        settings.screen = AnyView(EightWeeksTarget())
                    }
                
                NavigationLink(destination: EightWeeksTarget()) {
                    Text("콩팥건강 목표를 설정하세요")
                }
                    .frame(maxWidth: .infinity)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(lightBlue)
                    .cornerRadius(100)
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.vertical)
                
                Text("나의 현재 출첵점수 : \(score)점")
                    .bold()
                    .font(.title2)
                    .foregroundColor(darkBrown)
                
            }
            
            VStack(alignment: .leading) {
                Text("[콩팥콩팥 8주 코칭 안내]")
                    .font(.title2)
                    .foregroundColor(darkBrown)
                Text(" ⃝ 월,수,금 : 교육자료")
                    .font(.title2)
                    .foregroundColor(darkBrown)
                Text(" ⃝ 화 : 주간평가, 5주차 월간평가")
                    .font(.title2)
                    .foregroundColor(darkBrown)
                Text(" ⃝ 목 : 상담, 화상세미나")
                    .font(.title2)
                    .foregroundColor(darkBrown)
                Text(" ⃝ 토 : 설문지")
                    .font(.title2)
                    .foregroundColor(darkBrown)
                Text(" ⃝ 일 : 건강목표평가, 8주차 종합평가")
                    .font(.title2)
                    .foregroundColor(darkBrown)
            }
            .padding(.top)
            
            Group {
                Text("취소")
                    .frame(maxWidth: .infinity)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(.yellow)
                    .cornerRadius(100)
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.vertical)
                    .onTapGesture {
                        settings.screen = AnyView(Home())
                    }
            }
            .onAppear {
                getData()
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct EightWeeksMain_Previews: PreviewProvider {
    static var previews: some View {
        EightWeeksMain()
    }
}
