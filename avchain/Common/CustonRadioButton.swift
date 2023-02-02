//
//  CustomRadioButton.swift
//  UITest
//

import SwiftUI

struct CustomRadioButton: View {
    let window = UIScreen.main.bounds.size
    let id:Int
    let title:String
    let callback: (Int)->()
    let selectedId:Int
    init(
        title:String,
        id: Int,
        callback: @escaping (Int)->(),
        selectedID: Int
    ) {
        self.title = title
        self.id = id
        self.selectedId = selectedID
        self.callback = callback
    }
    
    var body: some View {
        
        Button {
         
            self.callback(id)
            
            
        } label: {
            
            Text(title)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .tracking(4) //자간 간격 4 만큼
                .padding(5)
            
            
            //글자 색
                .foregroundColor(.black)
            
            //배경색
                .background(self.selectedId != self.id
//                            ? Color(red: 229/255, green: 229/255, blue: 229/255)
                            ? Color(.white)
                            : Color(red: 254/255, green: 198/255, blue: 17/255))
                .cornerRadius(10)
            //테두리 설정
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.black),lineWidth: 1))
        }.frame(alignment: .center)
            //최종 크기
        
        
        
    }
}
