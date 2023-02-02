//
//  AlarmTime.swift
//  avchain
//

import Foundation

struct AlarmTime: Hashable {
    enum ampm: String {
        case AM, PM
    }
    var ampm: ampm
    var time:String
    var label:String
    
    static var allAlarmTime:[AlarmTime] {
        [
            AlarmTime(ampm: .AM, time: "05:00", label: "오전 5시"),
            AlarmTime(ampm: .AM, time: "05:30", label: "오전 5시 30분"),
            AlarmTime(ampm: .AM, time: "06:00", label: "오전 6시"),
            AlarmTime(ampm: .AM, time: "06:30", label: "오전 6시 30분"),
            AlarmTime(ampm: .AM, time: "07:00", label: "오전 7시"),
            AlarmTime(ampm: .AM, time: "07:30", label: "오전 7시 30분"),
            AlarmTime(ampm: .AM, time: "08:00", label: "오전 8시"),
            AlarmTime(ampm: .AM, time: "08:30", label: "오전 8시 30분"),
            AlarmTime(ampm: .AM, time: "09:00", label: "오전 9시"),
            AlarmTime(ampm: .AM, time: "09:30", label: "오전 9시 30분"),
            AlarmTime(ampm: .AM, time: "10:00", label: "오전 10시"),
            AlarmTime(ampm: .AM, time: "10:30", label: "오전 10시 30분"),
            AlarmTime(ampm: .AM, time: "11:00", label: "오전 11시"),
            AlarmTime(ampm: .AM, time: "11:30", label: "오전 11시 30분"),
            AlarmTime(ampm: .AM, time: "12:00", label: "오전 12시"),
            AlarmTime(ampm: .AM, time: "12:30", label: "오전 12시 30분"),
            AlarmTime(ampm: .PM, time: "13:00", label: "오후 1시"),
            AlarmTime(ampm: .PM, time: "13:30", label: "오후 1시 30분"),
            AlarmTime(ampm: .PM, time: "14:00", label: "오후 2시"),
            AlarmTime(ampm: .PM, time: "14:30", label: "오후 2시 30분"),
            AlarmTime(ampm: .PM, time: "15:00", label: "오후 3시"),
            AlarmTime(ampm: .PM, time: "15:30", label: "오후 3시 30분"),
            AlarmTime(ampm: .PM, time: "16:00", label: "오후 4시"),
            AlarmTime(ampm: .PM, time: "16:30", label: "오후 4시 30분"),
            AlarmTime(ampm: .PM, time: "17:00", label: "오후 5시"),
            AlarmTime(ampm: .PM, time: "17:30", label: "오후 5시 30분"),
            AlarmTime(ampm: .PM, time: "18:00", label: "오후 6시"),
            AlarmTime(ampm: .PM, time: "18:30", label: "오후 6시 30분"),
            AlarmTime(ampm: .PM, time: "19:00", label: "오후 7시"),
            AlarmTime(ampm: .PM, time: "19:30", label: "오후 7시 30분"),
            AlarmTime(ampm: .PM, time: "20:00", label: "오후 8시"),
            AlarmTime(ampm: .PM, time: "20:30", label: "오후 8시 30분"),
            AlarmTime(ampm: .PM, time: "21:00", label: "오후 9시"),
            AlarmTime(ampm: .PM, time: "21:30", label: "오후 9시 30분"),
            AlarmTime(ampm: .PM, time: "22:00", label: "오후 10시"),
            AlarmTime(ampm: .PM, time: "22:30", label: "오후 10시 30분"),
            AlarmTime(ampm: .PM, time: "23:00", label: "오후 11시"),
            AlarmTime(ampm: .PM, time: "23:30", label: "오후 11시 30분"),
            AlarmTime(ampm: .PM, time: "24:00", label: "오후 12시")
        ]
    }
}
