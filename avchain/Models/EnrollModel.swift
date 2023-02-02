//
//  EnrollModel.swift
//  avchain
//
import Foundation

class EnrollModel: NSObject, Codable{
    public var email: String
    public var genderCode: String // male / female
    public var phone: String // 01000001234
    public var birth: String // 1234-12-34
    public var password: String
    public var name: String
    public var avatarId: String
    public var fcmToken: String // 구글 토큰 추가 ... 임시로 더미 스트링 넣어져있음
    
    init(email: String, genderCode: String, phone: String, birth: String, password: String, name: String, avatarId: String, fcmToken: String) {
        self.email = email
        self.genderCode = genderCode
        self.phone = phone
        self.birth = birth
        self.password = password
        self.name = name
        self.avatarId = avatarId
        self.fcmToken = fcmToken
    }
    
    func createEnrollModel() -> [String: Any] {
        return [
            "id": UserDefaults.standard.string(forKey: "avatarId"),
            "departmentCode": "dialysis",
            "genderCode": self.genderCode,
            "phone": self.phone,
            "updated": "",
            "mobile": self.phone,
            "valid": "",
            "birth": self.birth,
            "organizationCode": "snubi",
            "titleCode": "patient",
            "membershipCode": "active",
            "password": self.password,
            "creator": "",
            "created": "",
            "updater": "",
            "email": self.email,
            "name": self.name,
            "listAuthMemberRole": [[
                "seq": "",
                "updated": "",
                "id": UserDefaults.standard.string(forKey: "avatarId"),
                "valid": "",
                "created": "",
                "roleCode": "user",
                "creator": "",
                "systemCode": "avatar",
                "updater": ""
            ]],
            "listAuthMemberDevice": [
            [
                "mobile": self.phone,
                "deviceId": self.fcmToken,
                "updater": "",
                "id": UserDefaults.standard.string(forKey: "avatarId"),
                "updated": "",
                "valid": "",
                "created": "",
                "creator": "",
                "systemCode": "avatar",
                "seq": "",
                "osCode": "android",
                "systemTypeCode": "beans",
                "systemTypeVersion": "1.2"
            ],
            [
                "mobile": self.phone,
                "deviceId": self.fcmToken,
                "updater": "",
                "id": UserDefaults.standard.string(forKey: "avatarId"),
                "updated": "",
                "valid": "",
                "created": "",
                "creator": "",
                "systemCode": "avatar",
                "seq": "",
                "osCode": "ios",
                "systemTypeCode": "beans",
                "systemTypeVersion": "1.2"
            ]]
        ]
    }
    
    
}

//        [
//            "id": self.email,
//            "departmentCode": "dialysis",
//            "genderCode": self.gender == 0 ? "male" : "female",
//            "phone": "",
//            "updated": "\(self.phoneCap + self.phone)",
//            "mobile": "\(self.phoneCap + self.phone)",
//            "valid": "",
//            "birth": dateParam,
//            "organizationCode": "snubi",
//            "titleCode": "patient",
//            "membershipCode": "active",
//            "password": self.password,
//            "creator": "",
//            "created": "",
//            "updater": "",
//            "email": self.email,
//            "name": self.name,
//            "listAuthMemberRole": [[
//                "seq": "",
//                "updated": "",
//                "id": self.avatarId,
//                "valid": "",
//                "created": "",
//                "roleCode": "user",
//                "creator": "",
//                "systemCode": "avatar",
//                "updater": ""
//            ]],
//            "listAuthMemberDevice": [[],
//            [
//                "mobile": "\(self.phoneCap + self.phone)",
//                "deviceId": "", // fcm토큰??
//                "updater": "",
//                "id": self.avatarId,
//                "updated": "",
//                "valid": "",
//                "created": "",
//                "creator": "",
//                "systemCode": "avatar",
//                "seq": "",
//                "osCode": "ios",
//                "systemTypeCode": "beans",
//                "systemTypeVersion": "1.2"
//            ]]
//        ]
//        param["listAuthMemberDevice"] = [[],
//        [
//            "mobile": "\(self.phoneCap + self.phone)",
//            "deviceId": "", // fcm토큰??
//            "updater": "",
//            "id": self.avatarId,
//            "updated": "",
//            "valid": "",
//            "created": "",
//            "creator": "",
//            "systemCode": "avatar",
//            "seq": "",
//            "osCode": "ios",
//            "systemTypeCode": "beans",
//            "systemTypeVersion": "1.2"
//        ]]
