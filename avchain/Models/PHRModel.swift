

import Foundation



// ==================PHR공유항목 설정==========================
// ============================================
// MARK: - PHRContractParam
struct PHRContractParam: Codable {
    let agentSeq: Int
    let agentPHRSeq: Int
    let agreement: String

    enum CodingKeys: String, CodingKey {
        case agentSeq = "agentSeq"
        case agentPHRSeq = "agentPHRSeq"
        case agreement = "agreement"
    }
}

typealias PHRContractParams = [PHRContractParam]
// ============================================
// ============================================



// ====================에이전트 사용동의========================
// ============================================
// MARK: - PHRAgreementParams
struct PHRAgreementParams: Codable {
    let agentAgreementSeq: Int
    let avatarID: String
    let agentSeq: Int
    let valid: String

    enum CodingKeys: String, CodingKey {
        case agentAgreementSeq = "agentAgreementSeq"
        case avatarID = "avatarId"
        case agentSeq = "agentSeq"
        case valid = "valid"
    }
}

// ============================================
// ============================================



// ===================에이전트 기준정보=========================
// ============================================
// MARK: - PHRListResult
struct PHRListResult: Codable {
    let code: String
    let data: [PHRListDatum]
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// MARK: - PHRListDatum
struct PHRListDatum: Codable {
    let creator: Creator
    let created: Created
    let updater: Creator
    let updated: Updated
    let agentServicePhrSeq: Int
    let agentSeq: Int
    let clsAgentPHR: PHRListClsAgentPHR
    let valid: Valid

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case updater = "updater"
        case updated = "updated"
        case agentServicePhrSeq = "agentServicePhrSeq"
        case agentSeq = "agentSeq"
        case clsAgentPHR = "clsAgentPHR"
        case valid = "valid"
    }
}

// MARK: - ClsAgentPHR
struct PHRListClsAgentPHR: Codable {
    let creator: Creator
    let created: Created
    let updater: Creator
    let updated: Updated
    let agentPhrSeq: Int
    let entity: PHRListEntity
    let target: String
    let valid: Valid

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case updater = "updater"
        case updated = "updated"
        case agentPhrSeq = "agentPhrSeq"
        case entity = "entity"
        case target = "target"
        case valid = "valid"
    }
}

enum Created: String, Codable {
    case the20211026130000 = "2021-10-26 13:00:00"
}

enum Creator: String, Codable {
    case xanitus = "xanitus"
}

enum PHRListEntity: String, Codable {
    case results = "results"
    case vitalsigns = "vitalsigns"
}

enum Updated: String, Codable {
    case the20211026040000 = "2021-10-26 04:00:00"
}

enum Valid: String, Codable {
    case v = "V"
}


// ============================================
// ============================================
