//
//  UserInfo.swift
//  avchain
//

import Foundation

class UserInfo: NSObject {
    
    public var Idx: Int?
    public var email: String?
    public var password: String?
    public var name: String?
    public var gender: String?
    public var phone: String?
    public var birth: String?
    public var avatarId: String?
    public var token: String?

    init(Idx: Int? = nil, email: String? = nil, password: String? = nil, name: String? = nil, gender: String? = nil, phone: String? = nil, birth: String? = nil, avatarId: String? = nil, token: String? = nil) {
        self.Idx = Idx
        self.email = email
        self.password = password
        self.name = name
        self.gender = gender
        self.phone = phone
        self.birth = birth
        self.avatarId = avatarId
        self.token = token
    }
    
    override init() {
        super.init()
    }
    
}
