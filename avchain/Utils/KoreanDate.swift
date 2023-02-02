//
//  KoreanDate.swift
//  avchain
//

import Foundation

struct KoreanDate {
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월 dd일"
        return formatter
    }()
    
    static let dateInputFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let dateParamFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let dbDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmmss"
        return formatter
    }()
    
    static let hhmmssFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmmss"
        return formatter
    }()
    
    static let fullTimeFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
}
