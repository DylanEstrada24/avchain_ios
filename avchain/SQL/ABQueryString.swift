//
//  ABQueryString.swift
//  avchain
//

import Foundation

//MARK: - CREATE TABLE QUERY -
// MARK: 유저정보
/// 유저 정보
let AB_QUERY_CREATE_TABLE_USERINFO      = "CREATE TABLE IF NOT EXISTS User (" +
                                          " Idx INTEGER PRIMARY KEY AUTOINCREMENT," +
                                          " Email varchar(255) DEFAULT ('')," +
                                          " Password varchar(255) DEFAULT ('')," +
                                          " Name varchar(255) DEFAULT ('')," +
                                          " Gender varchar(255) DEFAULT ('')," +
                                          " Phone varchar(255) DEFAULT ('')," +
                                          " Birth varchar(255) DEFAULT ('')," +
                                          " Avatar_Id varchar(255) DEFAULT ('')," +
                                          " Token Text DEFAULT ('') )"

// MARK: 자기관리 목표
// 자기관리 목표
let AB_QUERY_CREATE_TABLE_TARGETS       = "CREATE TABLE IF NOT EXISTS Targets (" +
                                          " Idx integer PRIMARY KEY AUTOINCREMENT," +
                                          " Save_Date datetime DEFAULT ('0000.00.00')," + // 저장날짜
                                          " High_Blood integer DEFAULT ('0')," + // 혈압 - 이완기
                                          " Low_Blood integer DEFAULT ('0')," + // 혈압 - 수축기
                                          " Weight integer DEFAULT ('0')," + // 체중
                                          " Blood_Sugar integer DEFAULT ('0')," + // 혈당
                                          " Calorie integer DEFAULT ('0')," + // 열량
                                          " Protein integer DEFAULT ('0')," + // 단백질
                                          " Carbohydrate integer DEFAULT ('0')," + // 탄수화물
                                          " Fat integer DEFAULT ('0')," + // 지방
                                          " Potassium integer DEFAULT ('0')," + // 칼륨
                                          " Phosphorus integer DEFAULT ('0')," + // 인
                                          " Calcium integer DEFAULT ('0')," + // 칼슘
                                          " Sodium integer DEFAULT ('0') )" // 나트륨

// MARK: 매일 자가입력
// 매일 자가입력
let AB_QUERY_CREATE_TABLE_DAILYACTIVITY = "CREATE TABLE IF NOT EXISTS DailyActivity (" +
                                          " Idx integer PRIMARY KEY AUTOINCREMENT," +
                                          " Save_Date datetime DEFAULT ('0000.00.00')," + // 저장날짜
                                          " High_Blood integer DEFAULT ('0')," + // 혈압 - 이완기
                                          " Low_Blood integer DEFAULT ('0')," + // 혈압 - 수축기
                                          " Weight integer DEFAULT ('0')," + // 체중
                                          " Blood_Sugar integer DEFAULT ('0')," + // 혈당
                                          " Calorie integer DEFAULT ('0')," + // 열량
                                          " Protein integer DEFAULT ('0')," + // 단백질
                                          " Carbohydrate integer DEFAULT ('0')," + // 탄수화물
                                          " Fat integer DEFAULT ('0')," + // 지방
                                          " Potassium integer DEFAULT ('0')," + // 칼륨
                                          " Phosphorus integer DEFAULT ('0')," + // 인
                                          " Calcium integer DEFAULT ('0')," + // 칼슘
                                          " Sodium integer DEFAULT ('0') )" // 나트륨

// MARK: 검사결과
/// 검사결과
let AB_QUERY_CREATE_TABLE_RESULTS       = "CREATE TABLE IF NOT EXISTS Results (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Read_Flag varchar(2) DEFAULT('F')," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " User_Id varchar(255) DEFAULT(''), "  +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Testresult_Value varchar(255) DEFAULT ('')," +
                                          " AverageResultValue varchar(255) DEFAULT ('')," +
                                          " Testresult_Unit varchar(255) DEFAULT ('')," +
                                          " Datetime_Type varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0)," +
                                          " CCRDataObjectID varchar(255)  DEFAULT ('') unique," +
                                          " CodeValue varchar(255) DEFAULT ('')," +
                                          " CodeCodingSystem varchar(255) DEFAULT ('')  )"

let SQL_CREATE_RESULT_INDEX_USER_ID         = "CREATE INDEX IF NOT EXISTS Results_Index_User_Id On Results (User_Id) ";
let SQL_CREATE_RESULT_INDEX_DATETIME_VALUE  = "CREATE INDEX IF NOT EXISTS Results_Index_Datetime_Value On Results (Datetime_value) ";
let SQL_CREATE_RESULT_INDEX_DESCRIPTION     = "CREATE INDEX IF NOT EXISTS Results_Index_Description On Results (Description) ";


// MARK: 활력징후
/// 활력징후
let AB_QUERY_CREATE_TABLE_VITALSIGNS    = "CREATE TABLE IF NOT EXISTS VitalSigns (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Read_Flag varchar(2) DEFAULT('F')," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " User_Id varchar(255) DEFAULT(''), " +
                                          " Testresult_Value varchar(255) DEFAULT ('')," +
                                          " Testresult_Unit varchar(255) DEFAULT ('')," +
                                          " Datetime_Type varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00  00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0)," +
                                          " Exact_time varchar(255)  DEFAULT('')," +
                                          " CCRDataObjectID VARCHAR(255) DEFAULT  ('') unique," +
                                          " CodeValue VARCHAR(255) DEFAULT ('')," +
                                          " CodeCodingSystem VARCHAR(255) DEFAULT ('')  )"

let SQL_CREATE_VITALSIGNS_INDEX_USER_ID         = "CREATE INDEX IF NOT EXISTS VitalSigns_Index_User_Id On VitalSigns (User_Id) ";
let SQL_CREATE_VITALSIGNS_INDEX_DATETIME_VALUE  = "CREATE INDEX IF NOT EXISTS VitalSigns_Index_Datetime_Value On VitalSigns (Datetime_value) ";
let SQL_CREATE_VITALSIGNS_INDEX_DESCRIPTION     = "CREATE INDEX IF NOT EXISTS VitalSigns_Index_Description On VitalSigns (Description) ";

// MARK: 투약정보
/// 투약정보
let AB_QUERY_CREATE_TABLE_MEDICATIONS   = " CREATE TABLE IF NOT EXISTS Medications (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Read_Flag varchar(2) DEFAULT('F')," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Productname varchar(255) DEFAULT ('')," +
                                          " User_Id varchar(255) DEFAULT(''), " +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Route varchar(255) DEFAULT ('')," +
                                          " Frequency varchar(255) DEFAULT ('')," +
                                          " Quantity varchar(255) DEFAULT ('')," +
                                          " Manufacturer varchar(255) DEFAULT ('')," +
                                          " Instruction varchar(255) DEFAULT ('')," +
                                          " Datetime_Type varchar(255) DEFAULT ('')," +
                                          " Fulfillment varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0)," +
                                          " CCRDataObjectID VARCHAR(255) DEFAULT ('')  unique," +
                                          " CodeValue VARCHAR(255) DEFAULT ('')," +
                                          " CodeCodingSystem VARCHAR(255) DEFAULT ('')," +
                                          " PrescriptionNumber VARCHAR(255) DEFAULT ('')  )"

// MARK: 문제목록
/// 문제목록
let AB_QUERY_CREATE_TABLE_PROBLEMS      = "CREATE TABLE IF NOT EXISTS Problems (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Read_Flag varchar(2) DEFAULT('F')," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " AdditionalDescription varchar(255) DEFAULT ('')," +
                                          " User_Id varchar(255) DEFAULT(''), " +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Status varchar(255) DEFAULT ('')," +
                                          " Datetime_Type varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0)," +
                                          " CCRDataObjectID VARCHAR(255) DEFAULT ('') unique," +
                                          " CodeValue VARCHAR(255) DEFAULT ('')," +
                                          " CodeCodingSystem VARCHAR(255) DEFAULT ('')  )"

// MARK: 처치/시술
/// 처치/시술
let AB_QUERY_CREATE_TABLE_PROCEDURES    = "CREATE TABLE IF NOT EXISTS Procedures (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Read_Flag varchar(2) DEFAULT('F')," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " AdditionalDescription varchar(255) DEFAULT ('')," +
                                          " User_Id varchar(255) DEFAULT('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0)," +
                                          " CCRDataObjectID VARCHAR(255) DEFAULT ('') unique," +
                                          " CodeValue VARCHAR(255) DEFAULT ('')," +
                                          " CodeCodingSystem VARCHAR(255) DEFAULT (''))"

// MARK: 에이전트
/// 에이전트
let AB_QUERY_CREATE_TABLE_AGENT         = " CREATE TABLE IF NOT EXISTS [Agent] (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Agent_Name varchar(255) DEFAULT ('')," +
                                          " description varchar(255) DEFAULT ('')," +
                                          " User_Id varchar(255) DEFAULT ('')," +
                                          " Home_Delete varchar(255)," +
                                          " Agent_List_Delete varchar(255) DEFAULT ('')," +
                                          " Agent_Order varchar(255) DEFAULT ('')," +
                                          " Agent_Seq varchar(255) DEFAULT ('') unique)"

// MARK: Notification 알림
/// 알림
let AB_QUERY_CREATE_TABLE_NOTIFICATION  = "CREATE TABLE IF NOT EXISTS Notification (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Seq integer DEFAULT ('')," +
                                          " User_Id varchar(255) DEFAULT('')," +
                                          " Message varchar(255) DEFAULT('')," +
                                          " Read_Flag varchar(2) DEFAULT('F')," +
                                          " Message_ID varchar(255) DEFAULT('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00'))"

/*
// MARK: Payer?
/// payer?
let AB_QUERY_CREATE_TABLE_PAYERS        = "CREATE  TABLE IF NOT EXISTS  [Payers] (" +
                                          "Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          "Phr_Id integer DEFAULT ('0'), " +
                                          "Type varchar(255) DEFAULT (''), " +
                                          "Question_Name varchar(255) DEFAULT ('')," +
                                          "Question_Co varchar(255) DEFAULT (''), " +
                                          "Datetime_Value varchar(255) DEFAULT ('')," +
                                          "Subscriber varchar(255) DEFAULT (''), " +
                                          "PaymentProvider varchar(255) DEFAULT ('')," +
                                          "Question_No varchar(255) DEFAULT ('')," +
                                          "Actor_Id varchar(255) DEFAULT (''), " +
                                          "Actor_Role varchar(255) DEFAULT (''), " +
                                          "Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          "Last_Update datetime DEFAULT ('0000.00.00 00:00:00'), " +
                                          "Flag CHAR(2) DEFAULT (0), [CCRDataObjectID] VARCHAR(255) DEFAULT ('') unique)"
*/
// MARK: Functional status
/// functional status ?
let AB_QUERY_CREATE_TABLE_FUNCTIONALSTATUS = "CREATE TABLE IF NOT EXISTS [FunctionalStatus] (" +
                                             " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                             " Phr_Id integer DEFAULT ('0')," +
                                             " Problem_Desc varchar(255) DEFAULT ('')," +
                                             " Type varchar(255) DEFAULT ('')," +
                                             " Description varchar(255) DEFAULT ('')," +
                                             " Testresult_Value varchar(255) DEFAULT ('')," +
                                             " Testresult_Unit varchar(255) DEFAULT ('')," +
                                             " Problem_Actorid varchar(255) DEFAULT ('')," +
                                             " Problem_Actorrole varchar(255) DEFAULT ('')," +
                                             " Datetime_type varchar(255) DEFAULT ('')," +
                                             " Status varchar(255) DEFAULT ('')," +
                                             " Datetime_Value varchar(255) DEFAULT ('')," +
                                             " Actor_Id varchar(255) DEFAULT ('')," +
                                             " Actor_Role varchar(255) DEFAULT ('')," +
                                             " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                             " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                             " Flag CHAR(2) DEFAULT (0), [CCRDataObjectID] VARCHAR(255) DEFAULT ('') unique)"

// MARK: 가족 이력
/// 가족 이력
let AB_QUERY_CREATE_TABLE_FAMILYHISTORY = "CREATE TABLE IF NOT EXISTS [FamilyHistory] (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " Status varchar(255) DEFAULT ('')," +
                                          " Exactdatetime varchar(255) DEFAULT ('')," +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Familymember_Actorrole varchar(255) DEFAULT ('')," +
                                          " Familymember_Actorid varchar(255) DEFAULT ('')," +
                                          " Healthstatus varchar(255) DEFAULT ('')," +
                                          " Problem_Desc varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0), [CCRDataObjectID] VARCHAR(255) DEFAULT ('') unique)"

// MARK: 사회 이력
/// 사회 이력
let AB_QUERY_CREATE_TABLE_SOCIALHISTORY = "CREATE TABLE IF NOT EXISTS [SocialHistory] (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Datetime_Type varchar(255) DEFAULT ('')," +
                                          " Status varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0), [CCRDataObjectID] VARCHAR(255) DEFAULT ('') unique)"

// MARK:
///
let AB_QUERY_CREATE_TABLE_ALERTS        = "CREATE TABLE IF NOT EXISTS [Alerts] (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Status varchar(255) DEFAULT ('')," +
                                          " Datetime_Type varchar(255) DEFAULT ('')," +
                                          " Severity varchar(255) DEFAULT ('')," +
                                          " Reaction_Desc varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0), [CCRDataObjectID] VARCHAR(255) DEFAULT ('') unique)"

// MARK:
///
let AB_QUERY_CREATE_TABLE_IMMUNIZATIONS = "CREATE TABLE IF NOT EXISTS [Immunizations] (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Productname varchar(255) DEFAULT ('')," +
                                          " Manufacturer varchar(255) DEFAULT ('')," +
                                          " Route varchar(255) DEFAULT ('')," +
                                          " Site varchar(255) DEFAULT ('')," +
                                          " Datetime_Type varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0), [CCRDataObjectID] VARCHAR(255) DEFAULT ('') unique)"

// MARK:
///
let AB_QUERY_CREATE_TABLE_ENCOUNTERS    = "CREATE TABLE IF NOT EXISTS [Encounters] (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " Type varchar(255) DEFAULT ('')," +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " Datetime_Value varchar(255) DEFAULT ('')," +
                                          " Location varchar(255) DEFAULT ('')," +
                                          " Consent varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0), [CCRDataObjectID] VARCHAR(255) DEFAULT ('') unique)"


// MARK: 보험 > 재활이력
/// 검사결과
let AB_QUERY_CREATE_TABLE_PAYERS       = "CREATE TABLE IF NOT EXISTS Payers (" +
                                          " Section_Id integer PRIMARY KEY AUTOINCREMENT," +
                                          " Read_Flag varchar(2) DEFAULT('F')," +
                                          " Phr_Id integer DEFAULT ('0')," +
                                          " User_Id varchar(255) DEFAULT(''), "  +
                                          " Description varchar(255) DEFAULT ('')," +
                                          " AdditionalDescription varchar(255) DEFAULT ('')," +
                                          " AccidentDateTimeValue varchar(255) DEFAULT ('')," +
                                          " InDateTimeValue varchar(255) DEFAULT ('')," +
                                          " OutDateTimeValue varchar(255) DEFAULT ('')," +
                                          " InEndDateTimeValue varchar(255) DEFAULT ('')," +
                                          " OutEndDateTimeValue varchar(255) DEFAULT ('')," +
                                          " InOutIndicator varchar(255) DEFAULT ('')," +
                                          " Actor_Id varchar(255) DEFAULT ('')," +
                                          " Actor_Role varchar(255) DEFAULT ('')," +
                                          " Initial_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Last_Update datetime DEFAULT ('0000.00.00 00:00:00')," +
                                          " Flag CHAR(2) DEFAULT (0)," +
                                          " CCRDataObjectID varchar(255)  DEFAULT ('') unique," +
                                          " CodeValue varchar(255) DEFAULT ('')," +
                                          " CodeCodingSystem varchar(255) DEFAULT ('')  )"

let SQL_CREATE_PAYERS_INDEX_USER_ID         = "CREATE INDEX IF NOT EXISTS Payers_Index_User_Id On Payers (User_Id) ";
let SQL_CREATE_PAYERS_INDEX_AccidentDateTimeValue  = "CREATE INDEX IF NOT EXISTS Payers_Index_AccidentDateTimeValue On Payers (AccidentDateTimeValue) ";
let SQL_CREATE_PAYERS_INDEX_DESCRIPTION     = "CREATE INDEX IF NOT EXISTS Payers_Index_Description On Payers (Description) ";



// MARK:
///
let AB_QUERY_MASTER_TABLE               = "select name from sqlite_master where type='table'"



// MARK: - Table Name
let AB_TABLE_NAME_USER                  = "User"
let AB_TABLE_NAME_TARGETS               = "Targets"
let AB_TABLE_NAME_DAILYACTIVITY         = "DailyActivity"
let AB_TABLE_NAME_RESULT                = "Results"
let AB_TABLE_NAME_VITALSIGNS            = "VitalSigns"
let AB_TABLE_NAME_MEDICATIONS           = "Medications"
let AB_TABLE_NAME_PROBLEMS              = "Problems"
let AB_TABLE_NAME_PROCEDURES            = "Procedures"
let AB_TABLE_NAME_AGENTS                = "Agent"
let AB_TABLE_NAME_NOTIFICATION          = "Notification"
let AB_TABLE_NAME_PAYERS                = "Payers"

// MARK: -
///
let AB_QUERY_GET_TABLE_USER             = "select * from User"
let AB_QUERY_GET_TABLE_RESULT           = "select * from Results"
let AB_QUERY_GET_TABLE_VITALSIGNS       = "select * from VitalSigns"
let AB_QUERY_GET_TABLE_MEDICATIONS      = "select * from Medications"
let AB_QUERY_GET_TABLE_PROBLEMS         = "select * from Problems"
let AB_QUERY_GET_TABLE_PROCEDURES       = "select * from Procedures"
let AB_QUERY_GET_TABLE_AGENT            = "select * from Agent"
let AB_QUERY_GET_TABLE_NOTIFICATION     = "select * from Notification"
let AB_QUERY_GET_TABLE_PAYER            = "select * from Payers"
let AB_QUERY_GET_TABLE_FUNCTIONALSTATUS = "select * from FunctionalStatus"
let AB_QUERY_GET_TABLE_FAMILYHISTORY    = "select * from FamilyHistory"
let AB_QUERY_GET_TABLE_SOCIALHISTORY    = "select * from SocialHistory"
let AB_QUERY_GET_TABLE_ALERT            = "select * from Alerts"
let AB_QUERY_GET_TABLE_IMMUNIZATION     = "select * from Immunizations"
let AB_QUERY_GET_TABLE_ENCOUNTERS       = "select * from Encounters"
let AB_QUERY_GET_TABLE_PAYERS           = "select * from Payers"

let AB_QUERY_DELETE_AGENTS              = "DELETE From Agent"


// MARK: - For Test
let AB_QUERY_DELETE_ELEMENTS_TABLE_NOTIFICATION = "DELETE From Notification"


let POPUP_RESET = "UPDATE mypopup SET program_status=stop, attend_flag=false, program_input_flag=false, program_education_flag=false WHERE popup_id=9999"

