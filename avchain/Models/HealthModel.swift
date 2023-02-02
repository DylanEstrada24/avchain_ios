

import Foundation


// ===================건강자료 백업 복구=========================
// ============================================
// MARK: - HealthBackupResult
struct HealthBackupResult: Codable {
    let code: String
    let data: HealthBackupDataClass
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// MARK: - HealthBackupDataClass
struct HealthBackupDataClass: Codable {
    let creator: String
    let created: String
    let updater: String
    let updated: String
    let avatarBackupSeq: Int
    let avatarID: String
    let host: String
    let encKey: String
    let valid: String
    let fileHash: String

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case updater = "updater"
        case updated = "updated"
        case avatarBackupSeq = "avatarBackupSeq"
        case avatarID = "avatarId"
        case host = "host"
        case encKey = "encKey"
        case valid = "valid"
        case fileHash = "fileHash"
    }
}

// ============================================
// ============================================




// ====================건강자료 백업 요청========================
// ============================================

// 해당 기능은 GET Param으로 AvataID전송으로 종료

// ============================================
// ============================================






// ===================건강자료 백업후 정보 갱신=========================
// ============================================

// 해당 기능은 GET Param으로 AvataID전송으로 종료

// ============================================
// ============================================

