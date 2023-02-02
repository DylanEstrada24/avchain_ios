//
//  Constants.swift
//  avchain
//

import Foundation
class Constants {
    static let EmptyString = ""
    
    class TableName {
        static let Result = "Results"
        static let VitalSign = "VitalSigns"
        static let Medication = "Medications"
        static let Problem = "Problems"
        static let Procedure = "Procedures"
    }
    
    class Keys {
        static let data = "data"
        static let table = "table"
        static let name = "name"
        static let id = "id"
        
        static let columnName = "columnName"
        static let columns = "columns"
        static let columnValue = "columnValue"
        static let columnOperator = "columnOperator"
        static let operatorStirng = "operator"
        static let queryInfo = "queryInfo"
        
        static let ccrData = "ccrData"
        static let deviceType = "deviceType"
    }
    
    class Values {
        static let avatar = "avatar"
    }
    
    class Operator {
        static let AND = " AND "
        static let WHERE = " WHERE "
    }
    
    class HTTP_Header_Keys {
        static let contentType = "content-type"
    }
    
    class HTTP_Header_Values {
        static let applicationJSON = "application/json;charset=UTF-8"
        static let bearer = "Bearer  "
    }
    
    class SQLite3 {
        class query {
            static let selectAll = "SELECT * FROM "
        }
    }
    
    class UserDefaults_Key {
        static let name = "USER_NAME"
        static let birth = "USER_BIRTH"
        static let gender = "USER_GENDER"
        static let nick = "USER_NICK"
        static let email = "USER_EMAIL"
        static let phone = "USER_PHONE"
        static let image = "USER_IMAGE"
        static let autoLogin = "AUTO_LOGIN"
        static let loginEmail = "EMAIL"
        static let loginPassword = "PASS"
    }
    
    class UserDefaults_Value {
        static let male = "male"
        static let female = "female"
    }
    
    class ModelKey {
        static let readFlag = "readFlag"
    }
    
    class APIKey {
        static let actorRole = "actorRole"
        static let actorID = "actorID"
        static let dateTimeValue = "dateTimeValue"
        static let objectID = "objectID"
        static let ccrDescription = "ccrDescription"
        static let codeValue = "codeValue"
        static let description = "description"
        static let additionalDescription = "additionalDescription"
        static let codeCodingSystem = "codeCodingSystem"
        static let testResultValue = "testResultValue"
        static let type = "type"
        static let testResultUnit = "testResultUnit"
        static let dateTimeType = "dateTimeType"
        static let status = "status"
        static let productName = "productName"
        static let manufacturer = "manufacturer"
        static let quantity = "quantity"
        static let prescriptionNumber = "prescriptionNumber"
        static let frequency = "frequency"
        static let instruction = "instruction"
        static let route = "route"
        
        static let procedures = "procedures"
        static let vitalsigns = "vitalsigns"
        static let results = "results"
        static let problems = "problems"
        static let medications = "medications"
        static let payers = "payers"
        
        static let mobileAuthNumber = "mobileAuthNumber"
        static let avatarId = "avatarId"
        static let mobileNumber = "mobileNumber"
        static let mobileAuthFlag = "mobileAuthFlag"
        
        static let code = "code"
        static let token = "token"
        static let encodedContractSeq = "encodedContractSeq"
        static let location = "location"
        
        static let Authorization = "Authorization"
        static let avatar_id = "avatar_id"
        static let DeviceType = "DeviceType"
        static let page_type = "page_type"
        
        static let agentSeq = "agentSeq"
        static let agentName = "agentName"
        static let agentDescription = "description"
        
        static let formId = "formId"                                // jth add
        static let formName = "formName"                            // jth add
        static let formSeq = "formSeq"                              // jth add
        static let formLocation = "formLocation"                    // jth add
        static let agentTypeCode = "agentTypeCode"                      // jth add
        static let formSubmissionStageSeq = "formSubmissionStageSeq" // jth add
        static let formSubmissionStage = "formSubmissionStage"      // jth add
        static let creationDate = "creationDate"                    // jth add
        static let updateDate = "updateDate"                        // jth add
        
       
        static let accidentDateTimeValue = "accidentDateTimeValue"          // jth add
        static let inDateTimeValue = "inDateTimeValue"                      // jth add
        static let outDateTimeValue = "outDateTimeValue"                    // jth add
        static let inEndDateTimeValue = "inEndDateTimeValue"                // jth add
        static let outEndDateTimeValue = "outEndDateTimeValue"              // jth add
        static let inOutIndicator = "inOutIndicator"                        // jth add
        
    }
    
    class APIValue {
        static let success = "success"
        static let avatar = "avatar"
        static let graph = "graph"
        static let dashboard = "dashboard"
        static let input = "input"
        
        static let insert = "insert"
        static let update = "update"
        static let delete = "delete"
    }
    
    class DBName {
        static let Results = "Results"
        static let VitalSigns = "VitalSigns"
        static let Medications = "Medications"
        static let Problems = "Problems"
        static let Procedures = "Procedures"
        static let Agent = "Agent"
        static let Notification = "Notification"
        static let Payers = "Payers"
    }
    
    class DBKey {
        static let Section_Id = "Section_Id"
        static let Phr_Id = "Phr_Id"
        static let User_Id = "User_Id"
        static let Actor_Id = "Actor_Id"
        static let Actor_Role = "Actor_Role"
        static let CodeValue = "CodeValue"
        static let CodeCodingSystem = "CodeCodingSystem"
        static let Description = "Description"
        static let Datetime_Type = "Datetime_Type"
        static let Datetime_Value = "Datetime_Value"
        static let CCRDataObjectID = "CCRDataObjectID"
        static let Testresult_Value = "Testresult_Value"
        static let Testresult_Unit = "Testresult_Unit"
        static let Read_Flag = "Read_Flag"
        static let type = "Type"
        static let Frequency = "Frequency"
        static let Instruction = "Instruction"
        static let Manufacturer = "Manufacturer"
        static let PrescriptionNumber = "PrescriptionNumber"
        static let Productname = "Productname"
        static let Quantity = "Quantity"
        static let Route = "Route"
        static let AdditionalDescription = "AdditionalDescription"
        static let Initial_Update = "Initial_Update"
        static let Last_Update = "Last_Update"
        static let Status = "Status"
        static let Agent_Name = "Agent_Name"
        static let Agent_List_Delete = "Agent_List_Delete"
        static let Agent_Seq = "Agent_Seq"
        static let Home_Delete = "Home_Delete"
        static let Agent_Order = "Agent_Order"
        static let Seq = "Seq"
        static let Message = "Message"
        static let message = "message"
        static let Message_ID = "Message_ID"
        static let agentServiceAvatar = "agentServiceAvatar"
        static let Flag = "Flag"
        static let Fulfillment = "Fulfillment"
        static let AverageResultValue = "AverageResultValue"
        
        static let ListSetFormSubmissionStage = "listSetFormSubmissionStage" // jth add
        static let additionalDescription = "AdditionalDescription"          // jth add
        static let accidentDateTimeValue = "AccidentDateTimeValue"          // jth add
        static let inDateTimeValue = "InDateTimeValue"                      // jth add
        static let outDateTimeValue = "OutDateTimeValue"                    // jth add
        static let inEndDateTimeValue = "InEndDateTimeValue"                // jth add
        static let outEndDateTimeValue = "OutEndDateTimeValue"              // jth add
        static let inOutIndicator = "InOutIndicator"                        // jth add
    }
    
    class DBValue {
        static let False = "F"
        static let True = "T"
    }
    
    class AgentSequence {
        static let BloodPresure = "3"
        static let BloodSugar = "7"
        static let Weight = "5"
        static let Health = "36"
    }
    
    // MARK: - Need to Localizing
//    static let confirm = NSLocalizedString("확인", comment: "")
    class DateFormat {
        static let FullDate = "yyyy.MM.dd HH:mm:ss"
        static let YearMonthDay = "yyyy-MM-dd"
        static let Year = "yyyy"
        static let Month = "MM"
        static let Day = "dd"
        
        static let SingleMonth = "M"
        static let SingleDay = "d"
        
        static let printYearMonthDay = "yyyy년 M월 d일"
    }
    
    class StringValue {
        static let confirm = "확인"
        static let cancel = "취소"
        
        static let ShowAtHome = "홈 보이기"
        static let HideAtHome = "홈 숨기기"
        
        static let TakePicture = "사진 촬영"
        static let GetPicture = "앨범에서 사진 선택"
        
        static let Name = "이름"
        static let Birth = "생일"
        static let Nick = "별명"
        static let Email = "이메일"
        static let Phone = "연락처"
        
        static let Version = "버전 "
    }
    
    class ErrorMessage {
        static let NeedToAgree = "이용약관에 동의해 주세요."
        static let NeedName = "이름을 입력해 주세요."
        static let NeedEmail = "이메일을 입력해 주세요."
        static let WrongEmail = "이메일이 올바르지 않습니다."
        static let NeedPassword = "비밀번호를 입력해 주세요."
        static let NeedPasswordConfirm = "비밀번호 확인을 입력해 주세요."
        static let Fail_Join = "회원가입에 실패하였습니다."
        static let NeedBirth = "생년월일을 입력해 주세요."
        static let NeedGender = "성별을 선택해 주세요."
        static let WrongPhoneNumber = "올바른 전화번호를 입력해 주세요."
        static let CkeckPrivacy = "이용약관을 확인해 주세요."
        static let NeedAuth = "인증번호를 요청해 주세요."
        static let CheckAuth = "인증번호를 입력해 주세요."
        static let WrongAuth = "입력하신 인증번호가 올바르지 않습니다."
        static let IncorrectUserInfo = "사용자 정보가 일치하지 않습니다."
        static let RequestFail = "요청에 실패했습니다."
        static let CannotFindInfo = "일치하는 정보를 찾을 수 없습니다."
        static let ErrorCamera = "카메라를 호출할 수 없습니다."
        
        static let NeedCurrentPassword = "현재 비밀번호를 입력해 주세요."
        static let WrongCurrentPassword = "현재 비밀번호가 올바르지 않습니다."
        
        static let PasswordOrigin = "비밀번호는 영문 대소문자, 숫자, 특수문자를 조합하여 최소 6자리이상, 20자리 이하로 만들어 주세요."
        static let WrongNewPassword = "새로 바꾸실 비밀번호가 일치하지 않습니다."
        
        static let FailChangePassword = "비밀번호 변경에 실패하였습니다."
    }
    
    class PopupMessage {
        static let ContinueJoin = "본인 인증되었습니다. \n회원가입 하시겠습니까?"
    }
    
    class AgentDescription {
        static let Diet = "혈액 검사결과를 요약해주고, 결과에 따른 식이조절 방법을 알려줍니다."
        static let Weight = "체중기록을 관리하고 지난 기록을 그래프로 볼 수 있습니다."
        static let BloodPresure = "혈압 기록을 관리하고, 지난 기록을 그래프로 볼 수 있습니다."
        static let BloodSugar = "혈당 기록을 관리하고 지난 기록을 그래프로 볼 수 있습니다."
        static let Food = "음식을 검색하여 칼륨, 칼슘, 인 등의 주요 성분의 함량정보를 확인합니다."
    }
    
    class HealthHistoryName {
        static let Medication = "투약"
        static let Result = "검사결과"
        static let Payers = "재활이력"
        static let Procedures = "처치/시술"
        static let VitalSigns = "활력징후"
        static let VisitHistory = "의료기관\n방문기록"
        static let Alerge = "알레르기\n부작용"
        static let Immunizations = "예방접종"
        static let MedicalInstruction = "사전의료\n지시"
        static let PersonalInformation = "개인정보"
        static let InsuerenceInformation = "보험정보"
        static let Problems = "문제목록"
        static let FunctionalEvaluation = "기능평가"
        static let FamilyHistory = "가족력"
        static let SocietyHistory = "사회력"
    }
    
    class HealthTableLabel_Title {
        static let Result = "결과"
        static let From = "출처"
        static let Description = "처방"
        static let Term = "기간"
    }
    
    class CCRDownloadManager {
        static let ObjectDownloading = "의료정보를 받는 중입니다."
        static let ListDownloading = "의료정보리스트를 받는 중입니다."
        static let ListDownloaded = "의료정보리스트 다운로드 완료."
    }
    
    class CCRDownloadManager_Error {
        static let UnLogined = "can't define User's avatar ID"
        static let UndefinedID = "sequence does not exist"
    }
}
