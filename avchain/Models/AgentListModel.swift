// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let agentListData = try? JSONDecoder().decode(AgentListData.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAgentListDatum { response in
//     if let agentListDatum = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - AgentListDatum
struct AgentListDatum: Codable {
    let contractSeq: Int
    let updated: String
    let isShowInAvatarHome: Int
    let updater: JSONNull?
    let created: String
    let avatarID: AvatarID
    let agentSeq: String
    let creator: JSONNull?
    let agentServiceAvatar: AgentListServiceAvatar
    let agentServicePHRs: [Agent]?
    let agentOrdinal: Int
    let valid: String
    let agentAgreement: AgentListAgent
    let avatarTypeCode: AvatarTypeCode

    enum CodingKeys: String, CodingKey {
        case contractSeq = "contractSeq"
        case updated = "updated"
        case isShowInAvatarHome = "isShowInAvatarHome"
        case updater = "updater"
        case created = "created"
        case avatarID = "avatarId"
        case agentSeq = "agentSeq"
        case creator = "creator"
        case agentServiceAvatar = "agentServiceAvatar"
        case agentServicePHRs = "agentServicePHRs"
        case agentOrdinal = "agentOrdinal"
        case valid = "valid"
        case agentAgreement = "agentAgreement"
        case avatarTypeCode = "avatarTypeCode"
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
struct AgentListAgent: Codable {
    let creator: ClsAgentPHRCreator
    let created: String
    let updated: String
    let avatarID: AvatarID?
    let valid: ClsAgentPHRValid
    let agentAgreementSeq: Int?
    let agentSeq: Int
    let updater: ClsAgentPHRCreator
    let clsAgentPHR: ClsAgentListPHR?
    let agentServicePhrSeq: Int?

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case created = "created"
        case updated = "updated"
        case avatarID = "avatarId"
        case valid = "valid"
        case agentAgreementSeq = "agentAgreementSeq"
        case agentSeq = "agentSeq"
        case updater = "updater"
        case clsAgentPHR = "clsAgentPHR"
        case agentServicePhrSeq = "agentServicePhrSeq"
    }
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
struct ClsAgentListPHR: Codable {
    let updated: ClsAgentPHRUpdated
    let updater: ClsAgentPHRCreator
    let agentPhrSeq: Int
    let valid: ClsAgentPHRValid
    let created: ClsAgentPHRCreated
    let target: String
    let entity: Entity
    let creator: ClsAgentPHRCreator

    enum CodingKeys: String, CodingKey {
        case updated = "updated"
        case updater = "updater"
        case agentPhrSeq = "agentPhrSeq"
        case valid = "valid"
        case created = "created"
        case target = "target"
        case entity = "entity"
        case creator = "creator"
    }
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
struct AgentListServiceAvatar: Codable {
    let agentSeq: String
    let categoryCodeSub: String
    let categoryCode: JSONNull?
    let description: String
    let updated: AgentServiceAvatarUpdated
    let location: String
    let created: AgentServiceAvatarCreated
    let updater: AgentServiceAvatarCreator
    let agentTypeCode: AgentTypeCode
    let formID: String
    let classCode: ClassCode
    let agentName: String
    let creator: AgentServiceAvatarCreator
    let diseaseCode: DiseaseCode

    enum CodingKeys: String, CodingKey {
        case agentSeq = "agentSeq"
        case categoryCodeSub = "categoryCodeSub"
        case categoryCode = "categoryCode"
        case description = "description"
        case updated = "updated"
        case location = "location"
        case created = "created"
        case updater = "updater"
        case agentTypeCode = "agentTypeCode"
        case formID = "formId"
        case classCode = "classCode"
        case agentName = "agentName"
        case creator = "creator"
        case diseaseCode = "diseaseCode"
    }
}

typealias AgentListData = [AgentListDatum]
