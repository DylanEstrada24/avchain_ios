// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let surveyFormData = try? JSONDecoder().decode(SurveyFormData.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSurveyFormDatum { response in
//     if let surveyFormDatum = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - SurveyFormDatum
struct SurveyFormDatum: Codable {
    let repeatedDate: String
    let creationID: String
    let repeatedWeekDay: String
    let repeatUnit: String
    let listSetFormSubmissionStage: [ListSetFormSubmissionStage]
    let valid: String
    let hospitalSeq: Int
    let systemCode: String
    let startDate: String
    let agentSeq: Int
    let formSubmissionScheduleSeq: Int
    let systemTypeCode: String
    let updateID: String
    let agentServiceAvatar: AgentFormServiceAvatar
    let lastStatus: String
    let nextDate: String?
    let repeatedAgentCount: Int
    let creationDate: String
    let updateDate: String
    let repeatedTime: String
    let endDate: String
    let avatarID: String

    enum CodingKeys: String, CodingKey {
        case repeatedDate = "repeatedDate"
        case creationID = "creationId"
        case repeatedWeekDay = "repeatedWeekDay"
        case repeatUnit = "repeatUnit"
        case listSetFormSubmissionStage = "listSetFormSubmissionStage"
        case valid = "valid"
        case hospitalSeq = "hospitalSeq"
        case systemCode = "systemCode"
        case startDate = "startDate"
        case agentSeq = "agentSeq"
        case formSubmissionScheduleSeq = "formSubmissionScheduleSeq"
        case systemTypeCode = "systemTypeCode"
        case updateID = "updateId"
        case agentServiceAvatar = "agentServiceAvatar"
        case lastStatus = "lastStatus"
        case nextDate = "nextDate"
        case repeatedAgentCount = "repeatedAgentCount"
        case creationDate = "creationDate"
        case updateDate = "updateDate"
        case repeatedTime = "repeatedTime"
        case endDate = "endDate"
        case avatarID = "avatarId"
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
struct AgentFormServiceAvatar: Codable {
    let updater: String
    let categoryCodeSub: String
    let formID: String
    let creator: String
    let diseaseCode: String
    let agentSeq: Int
    let agentTypeCode: String
    let agentName: String
    let description: String
    let created: String
    let classCode: String
    let categoryCode: String
    let updated: String
    let location: String

    enum CodingKeys: String, CodingKey {
        case updater = "updater"
        case categoryCodeSub = "categoryCodeSub"
        case formID = "formId"
        case creator = "creator"
        case diseaseCode = "diseaseCode"
        case agentSeq = "agentSeq"
        case agentTypeCode = "agentTypeCode"
        case agentName = "agentName"
        case description = "description"
        case created = "created"
        case classCode = "classCode"
        case categoryCode = "categoryCode"
        case updated = "updated"
        case location = "location"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseListSetFormSubmissionStage { response in
//     if let listSetFormSubmissionStage = response.result.value {
//       ...
//     }
//   }

// MARK: - ListSetFormSubmissionStage
struct ListSetFormSubmissionStage: Codable {
    let updateDate: String
    let formSubmissionStageSeq: Int
    let formSubmissionStage: SubmissionStage
    let creationDate: String
    let listSetFormSubmissionStageLog: [ListSetFormSubmissionStageLog]

    enum CodingKeys: String, CodingKey {
        case updateDate = "updateDate"
        case formSubmissionStageSeq = "formSubmissionStageSeq"
        case formSubmissionStage = "formSubmissionStage"
        case creationDate = "creationDate"
        case listSetFormSubmissionStageLog = "listSetFormSubmissionStageLog"
    }
}

enum SubmissionStage: String, Codable {
    case completed = "completed"
    case stopped = "stopped"
    case waiting = "waiting"
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseListSetFormSubmissionStageLog { response in
//     if let listSetFormSubmissionStageLog = response.result.value {
//       ...
//     }
//   }

// MARK: - ListSetFormSubmissionStageLog
struct ListSetFormSubmissionStageLog: Codable {
    let submissionUserAgent: String
    let requestSubmissionStage: SubmissionStage
    let formSubmissionStageLogSeq: Int
    let submissionDate: String

    enum CodingKeys: String, CodingKey {
        case submissionUserAgent = "submissionUserAgent"
        case requestSubmissionStage = "requestSubmissionStage"
        case formSubmissionStageLogSeq = "formSubmissionStageLogSeq"
        case submissionDate = "submissionDate"
    }
}

typealias SurveyFormData = [SurveyFormDatum]
