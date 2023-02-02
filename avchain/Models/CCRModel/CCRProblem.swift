//
//  CCRProblems.swift
//  AvatarBeans
//

import UIKit
//import EXBinder

class CCRProblem: CCRModel {
    var Section_Id          = EXProperty(Int32.self)
    var Phr_Id              = EXProperty(Int.self)
    var actorID             = EXProperty(String.self)
    var actorRole           = EXProperty(String.self)
    var codeValue           = EXProperty(String.self)
    var codeCodingSystem   = EXProperty(String.self)
    var dateTimeType        = EXProperty(String.self)
    var dateTimeValue       = EXProperty(String.self)
    var objectID            = EXProperty(String.self)
    var type                = EXProperty(String.self)
    var additionalDescription = EXProperty(String.self)
    var status              = EXProperty(String.self)
    var ccrDescription      = EXProperty(String.self)
    var readFlag            = EXProperty(String.self)
    
    override func setData(_ dic: [AnyHashable : Any]) {
        super.setData(dic)
        
        if dic[Constants.DBKey.Section_Id] != nil { Section_Id.value = dic[Constants.DBKey.Section_Id] as? Int32 }
        if dic[Constants.DBKey.Phr_Id] != nil { Phr_Id.value = dic[Constants.DBKey.Phr_Id] as? Int }
        if dic[Constants.DBKey.Actor_Id] != nil { actorID.value = dic[Constants.DBKey.Actor_Id] as? String }
        if dic[Constants.DBKey.Actor_Role] != nil { actorRole.value = dic[Constants.DBKey.Actor_Role] as? String }
        if dic[Constants.DBKey.CodeValue] != nil { codeValue.value = dic[Constants.DBKey.CodeValue] as? String }
        if dic[Constants.DBKey.CodeCodingSystem] != nil { codeCodingSystem.value = dic[Constants.DBKey.CodeCodingSystem] as? String }
        if dic[Constants.DBKey.Description] != nil { ccrDescription.value = dic[Constants.DBKey.Description] as? String }
        if dic[Constants.DBKey.Datetime_Type] != nil { dateTimeType.value = dic[Constants.DBKey.Datetime_Type] as? String }
        if dic[Constants.DBKey.Datetime_Value] != nil { dateTimeValue.value = dic[Constants.DBKey.Datetime_Value] as? String }
        if dic[Constants.DBKey.CCRDataObjectID] != nil { objectID.value = dic[Constants.DBKey.CCRDataObjectID] as? String }
        if dic[Constants.DBKey.type] != nil { type.value = dic[Constants.DBKey.type] as? String }
        if dic[Constants.DBKey.AdditionalDescription] != nil { additionalDescription.value = dic[Constants.DBKey.AdditionalDescription] as? String }
        if dic[Constants.DBKey.Status] != nil { status.value = dic[Constants.DBKey.Status] as? String }
        if dic[Constants.DBKey.Read_Flag] != nil { readFlag.value = dic[Constants.DBKey.Read_Flag] as? String }
                              else { readFlag.value = Constants.DBValue.False }
    }
    
    override var dbDic: [AnyHashable: Any] {
        get {
            var dic: [AnyHashable: Any] = [:]
            dic = [Constants.DBKey.Description:ccrDescription.value ?? "",
                   Constants.DBKey.AdditionalDescription:additionalDescription.value ?? "",
                   Constants.DBKey.User_Id:"",
                   Constants.DBKey.type:type.value ?? "",
                   Constants.DBKey.Status:status.value ?? "",
                   Constants.DBKey.Datetime_Type:dateTimeType.value ?? "",
                   Constants.DBKey.Datetime_Value:dateTimeValue.value ?? "",
                   Constants.DBKey.Actor_Id:actorID.value ?? "",
                   Constants.DBKey.Actor_Role:actorRole.value ?? "",
                   Constants.DBKey.Initial_Update:"",
                   Constants.DBKey.Last_Update:"",
                   Constants.DBKey.Flag:"",
                   Constants.DBKey.CCRDataObjectID:objectID.value ?? "",
                   Constants.DBKey.CodeValue:codeValue.value ?? "",
                   Constants.DBKey.CodeCodingSystem:codeCodingSystem.value ?? "",
                   Constants.DBKey.Read_Flag: readFlag.value ?? ""]
            if Phr_Id.value != nil {
                dic.updateValue(Phr_Id.value as Any, forKey: Constants.DBKey.Phr_Id)
            }
            if Section_Id.value != nil {
                dic.updateValue(Section_Id.value as Any, forKey: Constants.DBKey.Section_Id)
            }
            return dic
        }
    }
    
    override init() {
        super.init()
        
        tableName = Constants.DBName.Problems
    }
}
