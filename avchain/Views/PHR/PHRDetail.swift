//
//  PHRDetail.swift
//  avchain
//

import SwiftUI

struct PHRDetail: View {
    @State private var expandedIndex: Int? = nil
    @State var title: String = "PHR데이터"
    @State var id: Int = 0
    
    // 처방약샘플값
    // 리스트 불러온 뒤 dict 만들면 될듯?
    @State var sections:[AccordionItem] = []
    
    func getDetailData(){
        
        print("title :::",self.id)
        
        switch self.id {
        case 0 :
            getMedDetail()
            break
        case 1 :
            print("dataDetail")
            getResultDetail()
            break
        case 2:
            print("payer? // encounter?")
            break
        case 3:
            getProcedureDetail()
            break
        case 4:
            getVitalSignDetail()
            break
        case 6:
            getProblemDetail()
            break
        default:
            break
        }
        
        
    }
    
    func getMedDetail(){
        let mediDetail = ABSQLite.select("*", table: "Medications")
        let subTitleDetail = ["설명","용법","처방","기간","제조사","출처"]
        
        for i in 0 ... mediDetail.count-1 {
//            print(mediDetail[i])
            print("0",mediDetail[i]["Productname"] as! String)
            print("1",mediDetail[i]["Type"] as! String)
            print("2",mediDetail[i]["Route"] as! String)
            print("3",mediDetail[i]["Instruction"] as! String)
            print("4",mediDetail[i]["Datetime_Value"] as! String)
            print("5",mediDetail[i]["Manufacturer"] as! String)
            print("6",mediDetail[i]["Actor_Role"] as! String)
            print(" ")
            print(" ")
            sections.append(AccordionItem(title: mediDetail[i]["Productname"] as! String, number: "1", subTitle: subTitleDetail, content: [mediDetail[i]["Type"] as! String, mediDetail[i]["Route"] as! String, mediDetail[i]["Instruction"] as! String, mediDetail[i]["Datetime_Value"] as! String, mediDetail[i]["Manufacturer"] as! String, mediDetail[i]["Actor_Role"] as! String]))
            
        }
        print(sections.count)
    }
    
    func getResultDetail(){
        let dataDetail = ABSQLite.select("*", table: "Results")
        
        let subTitleDetail = ["결과", "측정일", "출처"]
        for i in 0 ... dataDetail.count-1 {
//            print(mediDetail[i])
            let valueParam = "\(dataDetail[i]["Testresult_Value"] as! String) \(dataDetail[i]["Testresult_Unit"] as! String)"
            print("0",dataDetail[i]["Description"] as! String)
            print("1",dataDetail[i]["Testresult_Value"] as! String)
            print("2",dataDetail[i]["Testresult_Unit"] as! String)
            print("3",dataDetail[i]["Datetime_Value"] as! String)
            print("4",dataDetail[i]["Actor_Role"] as! String)
            print("5",valueParam)
            print(" ")
            print(" ")
            
            sections.append(AccordionItem(title: dataDetail[i]["Description"] as! String, number: "1", subTitle: subTitleDetail, content: [valueParam, dataDetail[i]["Datetime_Value"] as! String, dataDetail[i]["Actor_Role"] as! String]))
            
        }
        print(sections.count)
    }
    
    func getProcedureDetail(){
        let dataDetail = ABSQLite.select("*", table: "Procedures")

        var subTitleDetail = [ "측정일", "출처"]


        for i in 0 ... dataDetail.count-1 {
            print("0",dataDetail[i]["Description"] as! String)
            print("1",dataDetail[i]["Datetime_Value"] as! String)
            print("2",dataDetail[i]["Actor_Role"] as! String)
            print(" ")
            print(" ")


            sections.append(AccordionItem(title: dataDetail[i]["Description"] as! String, number: "1", subTitle: subTitleDetail, content: [ dataDetail[i]["Datetime_Value"] as! String, dataDetail[i]["Actor_Role"] as! String]))

        }
        print("finish")
    }
    
    func getVitalSignDetail(){
        let dataDetail = ABSQLite.select("*", table: "VitalSigns")

        var subTitleDetail = ["결과", "측정일", "출처"]


        for i in 0 ... dataDetail.count-1 {
//            print(mediDetail[i])
            var valueParam = "\(dataDetail[i]["Testresult_Value"] as! String) \(dataDetail[i]["Testresult_Unit"] as! String)"
            print("0",dataDetail[i]["Description"] as! String)
            print("1",dataDetail[i]["Testresult_Value"] as! String)
            print("2",dataDetail[i]["Testresult_Unit"] as! String)
            print("3",dataDetail[i]["Datetime_Value"] as! String)
            print("4",dataDetail[i]["Actor_Role"] as! String)
            print("5",valueParam)
            print(" ")
            print(" ")


            sections.append(AccordionItem(title: dataDetail[i]["Description"] as! String, number: "1", subTitle: subTitleDetail, content: ["\(dataDetail[i]["Testresult_Value"] as! String) \(dataDetail[i]["Testresult_Unit"] as! String)", dataDetail[i]["Datetime_Value"] as! String, dataDetail[i]["Actor_Role"] as! String]))

        }
        print("finish")
    }
    
    func getProblemDetail(){
        let dataDetail = ABSQLite.select("*", table: "Problems")
        
        let subTitleDetail = ["설명", "상세설명", "검사방법", "발생일", "출처"]
        for i in 0 ... dataDetail.count-1 {
            print("-",dataDetail[i]["CCRDataObjectID"] as! String)
            print("0",dataDetail[i]["Description"] as! String)
            print("1",dataDetail[i]["AdditionalDescription"] as! String)
            print("2",dataDetail[i]["Type"] as! String)
            print("3",dataDetail[i]["Datetime_Value"] as! String)
            print("4",dataDetail[i]["Actor_Role"] as! String)
            print(" ")
            print(" ")
            
            sections.append(AccordionItem(title: dataDetail[i]["CCRDataObjectID"] as! String, number: "1", subTitle: subTitleDetail, content: [dataDetail[i]["Description"] as! String, dataDetail[i]["AdditionalDescription"] as! String,dataDetail[i]["Type"] as! String, dataDetail[i]["Datetime_Value"] as! String, dataDetail[i]["Actor_Role"] as! String]))
            
        }
        print(sections.count)
    }
    
    var body: some View {
        VStack {
            Text(title)
                .bold()
                .foregroundColor(darkBrown)
                .font(.title2)
            Divider()
            ScrollView {
                AccordionView(
                    expandedIndex: $expandedIndex,
                    sectionCount: sections.count,
                    label: { index in
                        HStack {
                            Text(sections[index].title)
                                .bold()
                                .foregroundColor(darkBrown)
                                .font(.headline)
                                .lineLimit(1)
                            Text("\(sections[index].number ?? "")")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(.gray)
                        }
                        
                    },
                    content: { index in
                        Divider()
                        VStack(alignment: .leading) {
                            Text(sections[index].title)
                                .bold()
                                .foregroundColor(darkBrown)
                                .font(.subheadline)
                                .padding(.bottom, 10)
                            HStack {
                                VStack(spacing: 5) {
                                    ForEach(sections[index].subTitle ?? [], id: \.self) { symbol in
                                        Text(symbol)
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                }
                                VStack(spacing: 5) {
                                    ForEach(sections[index].content ?? [], id: \.self) { content in
                                        Text(content)
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        
                        
                    })
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .padding()
        .onAppear(){
            self.getDetailData()
        }
    }
}

struct PHRDetail_Previews: PreviewProvider {
    static var previews: some View {
        PHRDetail()
    }
}
