

import Foundation

// ===================에이전트 리스트=========================
// ============================================
//// MARK: - AgentResult
//struct AgentResult: Codable {
//    let code: String
//    let data: [AgentDatum]
//    let message: String
//    let token: String
//
//    enum CodingKeys: String, CodingKey {
//        case code = "code"
//        case data = "data"
//        case message = "message"
//        case token = "token"
//    }
//}
//
//// MARK: - AgentDatum
//struct AgentDatum: Codable {
//    let creator: JSONNull?
//    let created: DatumCreated
//    let updater: JSONNull?
//    let updated: DatumUpdated
//    let contractSeq: Int
//    let avatarID: AvatarID
//    let agentSeq: String
//    let agentServiceAvatar: AgentServiceAvatar
//    let agentServicePHRs: [Agent]?
//    let agentAgreement: Agent?
//    let avatarTypeCode: AvatarTypeCode
//    let agentOrdinal: Int
//    let isShowInAvatarHome: Int
//    let valid: DatumValid
//
//    enum CodingKeys: String, CodingKey {
//        case creator = "creator"
//        case created = "created"
//        case updater = "updater"
//        case updated = "updated"
//        case contractSeq = "contractSeq"
//        case avatarID = "avatarId"
//        case agentSeq = "agentSeq"
//        case agentServiceAvatar = "agentServiceAvatar"
//        case agentServicePHRs = "agentServicePHRs"
//        case agentAgreement = "agentAgreement"
//        case avatarTypeCode = "avatarTypeCode"
//        case agentOrdinal = "agentOrdinal"
//        case isShowInAvatarHome = "isShowInAvatarHome"
//        case valid = "valid"
//    }
//}
//
//// MARK: - Agent
//struct Agent: Codable {
//    let creator: ClsAgentPHRCreator
//    let created: String
//    let updater: ClsAgentPHRCreator
//    let updated: String
//    let agentAgreementSeq: Int?
//    let avatarID: AvatarID?
//    let agentSeq: Int
//    let valid: ClsAgentPHRValid
//    let agentServicePhrSeq: Int?
//    let clsAgentPHR: ClsAgentPHR?
//
//    enum CodingKeys: String, CodingKey {
//        case creator = "creator"
//        case created = "created"
//        case updater = "updater"
//        case updated = "updated"
//        case agentAgreementSeq = "agentAgreementSeq"
//        case avatarID = "avatarId"
//        case agentSeq = "agentSeq"
//        case valid = "valid"
//        case agentServicePhrSeq = "agentServicePhrSeq"
//        case clsAgentPHR = "clsAgentPHR"
//    }
//}
//
//enum AvatarID: String, Codable {
//    case id201907261011123989 = "ID201907261011123989"
//}
//
//// MARK: - ClsAgentPHR
//struct ClsAgentPHR: Codable {
//    let creator: ClsAgentPHRCreator
//    let created: ClsAgentPHRCreated
//    let updater: ClsAgentPHRCreator
//    let updated: ClsAgentPHRUpdated
//    let agentPhrSeq: Int
//    let entity: Entity
//    let target: String
//    let valid: ClsAgentPHRValid
//
//    enum CodingKeys: String, CodingKey {
//        case creator = "creator"
//        case created = "created"
//        case updater = "updater"
//        case updated = "updated"
//        case agentPhrSeq = "agentPhrSeq"
//        case entity = "entity"
//        case target = "target"
//        case valid = "valid"
//    }
//}
//
//enum ClsAgentPHRCreated: String, Codable {
//    case the20211026130000 = "2021-10-26 13:00:00"
//}
//
//enum ClsAgentPHRCreator: String, Codable {
//    case creatorDefault = "default"
//    case xanitus = "xanitus"
//}
//
//enum Entity: String, Codable {
//    case results = "results"
//    case vitalsigns = "vitalsigns"
//}
//
//enum ClsAgentPHRUpdated: String, Codable {
//    case the20211026040000 = "2021-10-26 04:00:00"
//}
//
//enum ClsAgentPHRValid: String, Codable {
//    case v = "V"
//}
//
//// MARK: - AgentServiceAvatar
//struct AgentServiceAvatar: Codable {
//    let creator: AgentServiceAvatarCreator
//    let created: AgentServiceAvatarCreated
//    let updater: AgentServiceAvatarCreator
//    let updated: AgentServiceAvatarUpdated
//    let agentSeq: String
//    let agentTypeCode: AgentTypeCode
//    let agentName: String
//    let classCode: ClassCode
//    let diseaseCode: DiseaseCode
//    let categoryCode: JSONNull?
//    let categoryCodeSub: String
//    let formID: String
//    let location: String
//    let agentServiceAvatarDescription: String
//
//    enum CodingKeys: String, CodingKey {
//        case creator = "creator"
//        case created = "created"
//        case updater = "updater"
//        case updated = "updated"
//        case agentSeq = "agentSeq"
//        case agentTypeCode = "agentTypeCode"
//        case agentName = "agentName"
//        case classCode = "classCode"
//        case diseaseCode = "diseaseCode"
//        case categoryCode = "categoryCode"
//        case categoryCodeSub = "categoryCodeSub"
//        case formID = "formId"
//        case location = "location"
//        case agentServiceAvatarDescription = "description"
//    }
//}
//
//enum AgentTypeCode: String, Codable {
//    case formagent = "formagent"
//    case free = "free"
//}
//
//enum ClassCode: String, Codable {
//    case aclass = "aclass"
//}
//
//enum AgentServiceAvatarCreated: String, Codable {
//    case the20180517053230 = "2018-05-17 05:32:30"
//    case the20190424023546 = "2019-04-24 02:35:46"
//}
//
//enum AgentServiceAvatarCreator: String, Codable {
//    case snubi = "SNUBI"
//}
//
//enum DiseaseCode: String, Codable {
//    case none = "none"
//}
//
//enum AgentServiceAvatarUpdated: String, Codable {
//    case the20180516203230 = "2018-05-16 20:32:30"
//    case the20190423173546 = "2019-04-23 17:35:46"
//}
//
//enum AvatarTypeCode: String, Codable {
//    case beans = "beans"
//}
//
//enum DatumCreated: String, Codable {
//    case the20220405224548 = "2022-04-05 22:45:48"
//}
//
//enum DatumUpdated: String, Codable {
//    case the20220405134548 = "2022-04-05 13:45:48"
//}
//
//enum DatumValid: String, Codable {
//    case valid = "valid"
//}
//
//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
// ============================================
// ============================================


// ====================에이전트 인포========================
// ============================================
// MARK: - AgentInfoResult
struct AgentInfoResult: Codable {
    let code: String
    let data: [AgentInfoDatum]
    let message: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
        case token = "token"
    }
}

// MARK: - AgentInfoDatum
struct AgentInfoDatum: Codable {
    let creator: String
    let created: String
    let updater: String
    let updated: String
    let agentSeq: Int
    let agentTypeCode: String
    let agentName: String
    let classCode: String
    let diseaseCode: String
    let categoryCode: String
    let categoryCodeSub: String
    let formID: String
    let location: String
    let datumDescription: String
    let encodedContractSeq: String

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case updater = "updater"
        case updated = "updated"
        case agentSeq = "agentSeq"
        case agentTypeCode = "agentTypeCode"
        case agentName = "agentName"
        case classCode = "classCode"
        case diseaseCode = "diseaseCode"
        case categoryCode = "categoryCode"
        case categoryCodeSub = "categoryCodeSub"
        case formID = "formId"
        case location = "location"
        case datumDescription = "description"
        case encodedContractSeq = "encodedContractSeq"
    }
}
// ============================================
// ============================================




// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let agentInfo = try? JSONDecoder().decode(AgentInfo.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAgentInfoElement { response in
//     if let agentInfoElement = response.result.value {
//       ...
//     }
//   }

// MARK: - AgentInfoElement
struct AgentInfoElement: Codable {
    let updated: AgentInfoUpdated
    let isShowInAvatarHome: Int
    let agentOrdinal: Int
    let contractSeq: Int
    let agentServicePHRs: [Agent]?
    let updater: JSONNull?
    let avatarID: AvatarID
    let creator: JSONNull?
    let agentSeq: String
    let valid: AgentInfoValid
    let agentAgreement: Agent?
    let created: AgentInfoCreated
    let avatarTypeCode: AvatarTypeCode
    let agentServiceAvatar: AgentServiceAvatar

    enum CodingKeys: String, CodingKey {
        case updated = "updated"
        case isShowInAvatarHome = "isShowInAvatarHome"
        case agentOrdinal = "agentOrdinal"
        case contractSeq = "contractSeq"
        case agentServicePHRs = "agentServicePHRs"
        case updater = "updater"
        case avatarID = "avatarId"
        case creator = "creator"
        case agentSeq = "agentSeq"
        case valid = "valid"
        case agentAgreement = "agentAgreement"
        case created = "created"
        case avatarTypeCode = "avatarTypeCode"
        case agentServiceAvatar = "agentServiceAvatar"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAgent { response in
//     if let agent = response.result.value {
//       ...
//     }
//   }

// MARK: - Agent
struct Agent: Codable {
    let creator: ClsAgentPHRCreator
    let created: String
    let agentSeq: Int
    let valid: ClsAgentPHRValid
    let updater: ClsAgentPHRCreator
    let avatarID: AvatarID?
    let agentAgreementSeq: Int?
    let updated: String
    let agentServicePhrSeq: Int?
    let clsAgentPHR: ClsAgentPHR?

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case agentSeq = "agentSeq"
        case valid = "valid"
        case updater = "updater"
        case avatarID = "avatarId"
        case agentAgreementSeq = "agentAgreementSeq"
        case updated = "updated"
        case agentServicePhrSeq = "agentServicePhrSeq"
        case clsAgentPHR = "clsAgentPHR"
    }
}

enum AvatarID: String, Codable {
    case id202208031328462207 = "ID202208031328462207"
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseClsAgentPHR { response in
//     if let clsAgentPHR = response.result.value {
//       ...
//     }
//   }

// MARK: - ClsAgentPHR
struct ClsAgentPHR: Codable {
    let target: String
    let valid: ClsAgentPHRValid
    let creator: ClsAgentPHRCreator
    let updater: ClsAgentPHRCreator
    let created: ClsAgentPHRCreated
    let updated: ClsAgentPHRUpdated
    let entity: Entity
    let agentPhrSeq: Int

    enum CodingKeys: String, CodingKey {
        case target = "target"
        case valid = "valid"
        case creator = "creator"
        case updater = "updater"
        case created = "created"
        case updated = "updated"
        case entity = "entity"
        case agentPhrSeq = "agentPhrSeq"
    }
}

enum ClsAgentPHRCreated: String, Codable {
    case the20211026000000 = "2021-10-26 00:00:00"
}

enum ClsAgentPHRCreator: String, Codable {
    case creatorDefault = "default"
    case xanitus = "xanitus"
}

enum Entity: String, Codable {
    case results = "results"
    case vitalsigns = "vitalsigns"
}

enum ClsAgentPHRUpdated: String, Codable {
    case the20211025150000 = "2021-10-25 15:00:00"
}

enum ClsAgentPHRValid: String, Codable {
    case v = "V"
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAgentServiceAvatar { response in
//     if let agentServiceAvatar = response.result.value {
//       ...
//     }
//   }

// MARK: - AgentServiceAvatar
struct AgentServiceAvatar: Codable {
    let updater: AgentServiceAvatarCreator
    let agentName: String
    let creator: AgentServiceAvatarCreator
    let diseaseCode: DiseaseCode
    let classCode: ClassCode
    let agentTypeCode: AgentTypeCode
    let location: String
    let created: AgentServiceAvatarCreated
    let categoryCode: JSONNull?
    let agentSeq: String
    let updated: AgentServiceAvatarUpdated
    let formID: String
    let description: String
    let categoryCodeSub: String

    enum CodingKeys: String, CodingKey {
        case updater = "updater"
        case agentName = "agentName"
        case creator = "creator"
        case diseaseCode = "diseaseCode"
        case classCode = "classCode"
        case agentTypeCode = "agentTypeCode"
        case location = "location"
        case created = "created"
        case categoryCode = "categoryCode"
        case agentSeq = "agentSeq"
        case updated = "updated"
        case formID = "formId"
        case description = "description"
        case categoryCodeSub = "categoryCodeSub"
    }
}

enum AgentTypeCode: String, Codable {
    case formagent = "formagent"
    case free = "free"
}

enum ClassCode: String, Codable {
    case aclass = "aclass"
}

enum AgentServiceAvatarCreated: String, Codable {
    case the20180516163230 = "2018-05-16 16:32:30"
    case the20190423133546 = "2019-04-23 13:35:46"
}

enum AgentServiceAvatarCreator: String, Codable {
    case snubi = "SNUBI"
}

enum DiseaseCode: String, Codable {
    case none = "none"
}

enum AgentServiceAvatarUpdated: String, Codable {
    case the20180516073230 = "2018-05-16 07:32:30"
    case the20190423043546 = "2019-04-23 04:35:46"
}

enum AvatarTypeCode: String, Codable {
    case beans = "beans"
}

enum AgentInfoCreated: String, Codable {
    case the20230121124651 = "2023-01-21 12:46:51"
}

enum AgentInfoUpdated: String, Codable {
    case the20230121034651 = "2023-01-21 03:46:51"
}

enum AgentInfoValid: String, Codable {
    case valid = "valid"
}

typealias AgentInfo = [AgentInfoElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
