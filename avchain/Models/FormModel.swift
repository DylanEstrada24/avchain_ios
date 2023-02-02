//
//
//import Foundation
//
//
//// ==================설문일정 등록==========================
//// ============================================
//// MARK: - FormParams
//struct FormParams: Codable {
//    let formSubmissionScheduleSeq: Int
//    let hospitalSeq: String
//    let avatarID: String
//    let agentSeq: String
//    let repeatUnit: String
//    let nextDate: String
//    let lastStatus: String
//    let creationDate: String
//    let creationID: String
//    let updateDate: String
//    let updateID: String
//    let valid: String
//    let startDate: String
//    let endDate: String
//    let repeatedDate: String
//    let repeatedTime: String
//    let repeatedWeekDay: String
//    let repeatedAgentCount: Int
//    let systemCode: String
//    let systemTypeCode: String
//    let systemTypeVersion: String
//
//    enum CodingKeys: String, CodingKey {
//        case formSubmissionScheduleSeq = "formSubmissionScheduleSeq"
//        case hospitalSeq = "hospitalSeq"
//        case avatarID = "avatarId"
//        case agentSeq = "agentSeq"
//        case repeatUnit = "repeatUnit"
//        case nextDate = "nextDate"
//        case lastStatus = "lastStatus"
//        case creationDate = "creationDate"
//        case creationID = "creationId"
//        case updateDate = "updateDate"
//        case updateID = "updateId"
//        case valid = "valid"
//        case startDate = "startDate"
//        case endDate = "endDate"
//        case repeatedDate = "repeatedDate"
//        case repeatedTime = "repeatedTime"
//        case repeatedWeekDay = "repeatedWeekDay"
//        case repeatedAgentCount = "repeatedAgentCount"
//        case systemCode = "systemCode"
//        case systemTypeCode = "systemTypeCode"
//        case systemTypeVersion = "systemTypeVersion"
//    }
//}
//
//// ============================================
//// ============================================
//
//
//
//// ===================설문리스트=========================
//// ============================================
//// MARK: - FormResult
//struct FormResult: Codable {
//    let code: String
//    let data: [FormDatum]
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
//// MARK: - FormDatum
//struct FormDatum: Codable {
//    let formSubmissionScheduleSeq: Int
//    let hospitalSeq: Int
//    let avatarID: String
//    let agentSeq: Int
//    let agentServiceAvatar: FormAgentServiceAvatar
//    let repeatUnit: String
//    let nextDate: String?
//    let lastStatus: String
//    let creationDate: String
//    let creationID: String
//    let updateDate: String
//    let updateID: String
//    let valid: String
//    let startDate: String
//    let endDate: String
//    let repeatedDate: String
//    let repeatedTime: String
//    let repeatedWeekDay: String
//    let repeatedAgentCount: Int
//    let systemCode: String
//    let systemTypeCode: String
//    let listSetFormSubmissionStage: [ListSetFormSubmissionStage]
//
//    enum CodingKeys: String, CodingKey {
//        case formSubmissionScheduleSeq = "formSubmissionScheduleSeq"
//        case hospitalSeq = "hospitalSeq"
//        case avatarID = "avatarId"
//        case agentSeq = "agentSeq"
//        case agentServiceAvatar = "agentServiceAvatar"
//        case repeatUnit = "repeatUnit"
//        case nextDate = "nextDate"
//        case lastStatus = "lastStatus"
//        case creationDate = "creationDate"
//        case creationID = "creationId"
//        case updateDate = "updateDate"
//        case updateID = "updateId"
//        case valid = "valid"
//        case startDate = "startDate"
//        case endDate = "endDate"
//        case repeatedDate = "repeatedDate"
//        case repeatedTime = "repeatedTime"
//        case repeatedWeekDay = "repeatedWeekDay"
//        case repeatedAgentCount = "repeatedAgentCount"
//        case systemCode = "systemCode"
//        case systemTypeCode = "systemTypeCode"
//        case listSetFormSubmissionStage = "listSetFormSubmissionStage"
//    }
//}
//
//// MARK: - FormAgentServiceAvatar
//struct FormAgentServiceAvatar: Codable {
//    let creator: String
//    let created: String
//    let updater: String
//    let updated: String
//    let agentSeq: Int
//    let agentTypeCode: String
//    let agentName: String
//    let classCode: String
//    let diseaseCode: String
//    let categoryCode: String
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
//// MARK: - ListSetFormSubmissionStage
//struct ListSetFormSubmissionStage: Codable {
//    let formSubmissionStageSeq: Int
//    let formSubmissionStage: SubmissionStage
//    let creationDate: String
//    let updateDate: String
//    let listSetFormSubmissionStageLog: [ListSetFormSubmissionStageLog]
//
//    enum CodingKeys: String, CodingKey {
//        case formSubmissionStageSeq = "formSubmissionStageSeq"
//        case formSubmissionStage = "formSubmissionStage"
//        case creationDate = "creationDate"
//        case updateDate = "updateDate"
//        case listSetFormSubmissionStageLog = "listSetFormSubmissionStageLog"
//    }
//}
//
//enum SubmissionStage: String, Codable {
//    case completed = "completed"
//    case stopped = "stopped"
//    case waiting = "waiting"
//}
//
//// MARK: - ListSetFormSubmissionStageLog
//struct ListSetFormSubmissionStageLog: Codable {
//    let formSubmissionStageLogSeq: Int
//    let requestSubmissionStage: SubmissionStage
//    let submissionUserAgent: String
//    let submissionDate: String
//
//    enum CodingKeys: String, CodingKey {
//        case formSubmissionStageLogSeq = "formSubmissionStageLogSeq"
//        case requestSubmissionStage = "requestSubmissionStage"
//        case submissionUserAgent = "submissionUserAgent"
//        case submissionDate = "submissionDate"
//    }
//}
//
//// ============================================
//// ============================================
//
//
//
//// =====================설문상태리스트=======================
//// ============================================
//
//// MARK: - FormInfoListResult
//struct FormInfoListResult: Codable {
//    let code: String
//    let data: [JSONAny]
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
//// ============================================
//// ============================================
//
//
//
//// =====================설문일정수정=======================
//// ============================================
//// MARK: - FormUpdateParams
//struct FormUpdateParams: Codable {
//    let formSubmissionScheduleSeq: Int
//    let hospitalSeq: String
//    let avatarID: String
//    let agentSeq: String
//    let repeatUnit: String
//    let nextDate: String
//    let lastStatus: String
//    let creationDate: String
//    let creationID: String
//    let updateDate: String
//    let updateID: String
//    let valid: String
//    let startDate: String
//    let endDate: String
//    let repeatedDate: String
//    let repeatedTime: String
//    let repeatedWeekDay: String
//    let repeatedAgentCount: Int
//    let systemCode: String
//    let systemTypeCode: String
//    let systemTypeVersion: String
//
//    enum CodingKeys: String, CodingKey {
//        case formSubmissionScheduleSeq = "formSubmissionScheduleSeq"
//        case hospitalSeq = "hospitalSeq"
//        case avatarID = "avatarId"
//        case agentSeq = "agentSeq"
//        case repeatUnit = "repeatUnit"
//        case nextDate = "nextDate"
//        case lastStatus = "lastStatus"
//        case creationDate = "creationDate"
//        case creationID = "creationId"
//        case updateDate = "updateDate"
//        case updateID = "updateId"
//        case valid = "valid"
//        case startDate = "startDate"
//        case endDate = "endDate"
//        case repeatedDate = "repeatedDate"
//        case repeatedTime = "repeatedTime"
//        case repeatedWeekDay = "repeatedWeekDay"
//        case repeatedAgentCount = "repeatedAgentCount"
//        case systemCode = "systemCode"
//        case systemTypeCode = "systemTypeCode"
//        case systemTypeVersion = "systemTypeVersion"
//    }
//}
//
//
//// ============================================
//// ============================================
//
//
//
//// ====================설문상태수정========================
//// ============================================
//// MARK: - FormStateUpdateParams
//struct FormStateUpdateParams: Codable {
//    let formSubmissionStageSeq: Int
//    let formSubmissionStage: String
//    let creationDate: String
//    let updateDate: String
//
//    enum CodingKeys: String, CodingKey {
//        case formSubmissionStageSeq = "formSubmissionStageSeq"
//        case formSubmissionStage = "formSubmissionStage"
//        case creationDate = "creationDate"
//        case updateDate = "updateDate"
//    }
//}
//
//// ============================================
//// ============================================
//
