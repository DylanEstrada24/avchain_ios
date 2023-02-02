import Foundation

// ================로그인(POST)========================
// ============================================
// MARK: - LoginParams
struct LoginParams: Codable {
    let id: String
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case password = "password"
    }
}

// MARK: - LoginResult
struct LoginResult: Codable {
    let code: String
    let data: String
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// ============================================
// ============================================



// ================회원가입(POST)======================
// ============================================


// MARK: - JoinParams
struct JoinParams: Codable {
    let id: String
    let departmentCode: String
    let genderCode: String
    let updated: String
    let mobile: String
    let valid: String
    let birth: String
    let organizationCode: String
    let titleCode: String
    let membershipCode: String
    let listAuthMemberRole: [ListJoinAuthMemberRole]
    let listAuthMemberDevice: [ListJoinAuthMemberDevice]
    let password: String
    let creator: String
    let created: String
    let updater: String
    let email: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case departmentCode = "departmentCode"
        case genderCode = "genderCode"
        case updated = "updated"
        case mobile = "mobile"
        case valid = "valid"
        case birth = "birth"
        case organizationCode = "organizationCode"
        case titleCode = "titleCode"
        case membershipCode = "membershipCode"
        case listAuthMemberRole = "listAuthMemberRole"
        case listAuthMemberDevice = "listAuthMemberDevice"
        case password = "password"
        case creator = "creator"
        case created = "created"
        case updater = "updater"
        case email = "email"
        case name = "name"
    }
}

// MARK: - ListJoinAuthMemberDevice
struct ListJoinAuthMemberDevice: Codable {
    let mobile: String
    let deviceID: String
    let updater: String
    let id: String
    let updated: String
    let valid: String
    let created: String
    let creator: String
    let systemCode: String
    let seq: String
    let osCode: String
    let systemTypeCode: String
    let systemTypeVersion: String

    enum CodingKeys: String, CodingKey {
        case mobile = "mobile"
        case deviceID = "deviceId"
        case updater = "updater"
        case id = "id"
        case updated = "updated"
        case valid = "valid"
        case created = "created"
        case creator = "creator"
        case systemCode = "systemCode"
        case seq = "seq"
        case osCode = "osCode"
        case systemTypeCode = "systemTypeCode"
        case systemTypeVersion = "systemTypeVersion"
    }
}

// MARK: - ListAuthMemberRole
struct ListJoinAuthMemberRole: Codable {
    let seq: String
    let updated: String
    let id: String
    let valid: String
    let created: String
    let roleCode: String
    let creator: String
    let systemCode: String
    let updater: String

    enum CodingKeys: String, CodingKey {
        case seq = "seq"
        case updated = "updated"
        case id = "id"
        case valid = "valid"
        case created = "created"
        case roleCode = "roleCode"
        case creator = "creator"
        case systemCode = "systemCode"
        case updater = "updater"
    }
}

// ============================================
// ============================================



// ==============ID,비밀번호 찾기(GET)==================
// ============================================
// MARK: - FindEmailResult
struct FindEmailResult: Codable {
    let code: String
    let data: String
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// MARK: - FindPassResult
struct FindPassResult: Codable {
    let code: String
    let data: String
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// ============================================
// ============================================



// ===============비밀번호 변경 파라미터(PUT)==================
// ============================================
// MARK: - PutPassParams
struct PutPassParams: Codable {
    let id: String
    let departmentCode: String
    let genderCode: String
    let phone: String
    let updated: String
    let mobile: String
    let valid: String
    let birth: String
    let organizationCode: String
    let titleCode: String
    let membershipCode: String
    let listAuthMemberRole: [ListFindPassAuthMemberRole]
    let listAuthMemberDevice: [ListFindPassAuthMemberDevice]
    let password: String
    let creator: String
    let created: String
    let updater: String
    let email: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case departmentCode = "departmentCode"
        case genderCode = "genderCode"
        case phone = "phone"
        case updated = "updated"
        case mobile = "mobile"
        case valid = "valid"
        case birth = "birth"
        case organizationCode = "organizationCode"
        case titleCode = "titleCode"
        case membershipCode = "membershipCode"
        case listAuthMemberRole = "listAuthMemberRole"
        case listAuthMemberDevice = "listAuthMemberDevice"
        case password = "password"
        case creator = "creator"
        case created = "created"
        case updater = "updater"
        case email = "email"
        case name = "name"
    }
}

// MARK: - ListFindPassAuthMemberDevice
struct ListFindPassAuthMemberDevice: Codable {
    let mobile: String
    let deviceID: String
    let updater: String
    let id: String
    let updated: String
    let valid: String
    let created: String
    let creator: String
    let systemCode: String
    let seq: String
    let osCode: String
    let systemTypeCode: String
    let systemTypeVersion: String

    enum CodingKeys: String, CodingKey {
        case mobile = "mobile"
        case deviceID = "deviceId"
        case updater = "updater"
        case id = "id"
        case updated = "updated"
        case valid = "valid"
        case created = "created"
        case creator = "creator"
        case systemCode = "systemCode"
        case seq = "seq"
        case osCode = "osCode"
        case systemTypeCode = "systemTypeCode"
        case systemTypeVersion = "systemTypeVersion"
    }
}

// MARK: - ListFindPassAuthMemberRole
struct ListFindPassAuthMemberRole: Codable {
    let seq: String
    let updated: String
    let id: String
    let valid: String
    let created: String
    let roleCode: String
    let creator: String
    let systemCode: String
    let updater: String

    enum CodingKeys: String, CodingKey {
        case seq = "seq"
        case updated = "updated"
        case id = "id"
        case valid = "valid"
        case created = "created"
        case roleCode = "roleCode"
        case creator = "creator"
        case systemCode = "systemCode"
        case updater = "updater"
    }
}

// ============================================
// ============================================



// ============로그인 유저 정보 (GET)====================
// ============================================
// MARK: - UserInfoResult
struct UserInfoResult: Codable {
    let code: String
    let data: DataClass
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let creator: String
    let created: String
    let departmentCode: String
    let count: Int
    let mobile: String
    let birth: String
    let membershipCode: String
    let cryptographicAlgorithm: String
    let titleCode: String
    let digested: Bool
    let updater: String
    let valid: String
    let password: String
    let genderCode: String
    let listAuthMemberRole: [ListUserInfoAuthMemberRole]
    let listAuthMemberDevice: [ListUserInfoAuthMemberDevice]
    let organizationCode: String
    let phone: String
    let name: String
    let id: String
    let updated: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case departmentCode = "departmentCode"
        case count = "count"
        case mobile = "mobile"
        case birth = "birth"
        case membershipCode = "membershipCode"
        case cryptographicAlgorithm = "cryptographicAlgorithm"
        case titleCode = "titleCode"
        case digested = "digested"
        case updater = "updater"
        case valid = "valid"
        case password = "password"
        case genderCode = "genderCode"
        case listAuthMemberRole = "listAuthMemberRole"
        case listAuthMemberDevice = "listAuthMemberDevice"
        case organizationCode = "organizationCode"
        case phone = "phone"
        case name = "name"
        case id = "id"
        case updated = "updated"
        case email = "email"
    }
}

// MARK: - ListUserInfoAuthMemberDevice
struct ListUserInfoAuthMemberDevice: Codable {
    let valid: String
    let creator: String
    let systemCode: String
    let created: String
    let mobile: String
    let id: String
    let deviceID: String
    let updated: String
    let seq: Int
    let updater: String
    let systemTypeCode: String?
    let osCode: String?
    let systemTypeVersion: String?

    enum CodingKeys: String, CodingKey {
        case valid = "valid"
        case creator = "creator"
        case systemCode = "systemCode"
        case created = "created"
        case mobile = "mobile"
        case id = "id"
        case deviceID = "deviceId"
        case updated = "updated"
        case seq = "seq"
        case updater = "updater"
        case systemTypeCode = "systemTypeCode"
        case osCode = "osCode"
        case systemTypeVersion = "systemTypeVersion"
    }
}

// MARK: - ListUserInfoAuthMemberRole
struct ListUserInfoAuthMemberRole: Codable {
    let valid: String
    let creator: String
    let systemCode: String
    let created: String
    let roleCode: String
    let id: String
    let updated: String
    let seq: Int
    let updater: String

    enum CodingKeys: String, CodingKey {
        case valid = "valid"
        case creator = "creator"
        case systemCode = "systemCode"
        case created = "created"
        case roleCode = "roleCode"
        case id = "id"
        case updated = "updated"
        case seq = "seq"
        case updater = "updater"
    }
}

// ============================================
// ============================================



// ==============핸드폰 번호 확인(GET)===================
// ============================================

// MARK: - CheckPhoneResult
struct CheckPhoneResult: Codable {
    let code: String
    let data: String
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// ============================================
// ============================================



// ================병원정보 찾기(GET)=================
// ============================================
// MARK: - CheckHospitalResult
struct CheckHospitalResult: Codable {
    let code: String
    let data: [Datum]
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let creator: String
    let created: String
    let updater: String
    let updated: String
    let seq: Int
    let hospitalCode: String
    let departmentCode: String
    let avatarID: String
    let avatarMobile: String
    let xnetTypeCode: String
    let avatarTypeCode: String
    let agreement: String

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case updater = "updater"
        case updated = "updated"
        case seq = "seq"
        case hospitalCode = "hospitalCode"
        case departmentCode = "departmentCode"
        case avatarID = "avatarId"
        case avatarMobile = "avatarMobile"
        case xnetTypeCode = "xnetTypeCode"
        case avatarTypeCode = "avatarTypeCode"
        case agreement = "agreement"
    }
}

// ============================================
// ============================================



// =============핸드폰 인증번호 호출(POST)================
// ============================================
// MARK: - CheckPhoneParams
struct CheckPhoneParams: Codable {
    let avatarID: String
    let mobileNumber: String
    let mobileAuthNumber: String

    enum CodingKeys: String, CodingKey {
        case avatarID = "avatarId"
        case mobileNumber = "mobileNumber"
        case mobileAuthNumber = "mobileAuthNumber"
    }
}

// MARK: - CheckAuthPhoneResult
struct CheckAuthPhoneResult: Codable {
    let code: String
    let data: String
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// ============================================
// ============================================

