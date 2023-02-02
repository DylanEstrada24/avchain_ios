//
//  CCRResult.swift
//  AvatarBeans
//

import UIKit
//import EXBinder

class CCRResult: CCRModel {
    var Section_Id          = EXProperty(String.self)
    var Phr_Id              = EXProperty(String.self)
    var actorID             = EXProperty(String.self)
    var actorRole           = EXProperty(String.self)
    var codeValue           = EXProperty(String.self)
    var codeCodingSystem    = EXProperty(String.self)
    var dateTimeType        = EXProperty(String.self)
    var dateTimeValue       = EXProperty(String.self)
    var objectID            = EXProperty(String.self)
    var testResultValue     = EXProperty(String.self)
    var testResultUnit      = EXProperty(String.self)
    var type                = EXProperty(String.self)
    var ccrDescription      = EXProperty(String.self)
    var readFlag            = EXProperty(String.self)
    var averageResultValue  = EXProperty(String.self)
    
    override func setData(_ dic: [AnyHashable : Any]) {
        super.setData(dic)
        
        if dic[Constants.DBKey.Section_Id] != nil {
            Section_Id.value = dic[Constants.DBKey.Section_Id] as? String
            
        } else {
            Section_Id.value = ""
        }
        
        if dic[Constants.DBKey.Phr_Id] != nil {
            Phr_Id.value = dic[Constants.DBKey.Phr_Id] as? String
            
        } else {
            Phr_Id.value = ""
        }
        
        if dic[Constants.DBKey.Actor_Id] != nil {
            actorID.value = dic[Constants.DBKey.Actor_Id] as? String
            
        } else {
            actorID.value = ""
        }
        
        if dic[Constants.DBKey.Actor_Role] != nil {
            actorRole.value = dic[Constants.DBKey.Actor_Role] as? String
            
        } else {
            actorRole.value = ""
        }
        
        if dic[Constants.DBKey.CodeValue] != nil {
            codeValue.value = dic[Constants.DBKey.CodeValue] as? String
            
        } else {
            codeValue.value = ""
        }
        
        if dic[Constants.DBKey.CodeCodingSystem] != nil {
            codeCodingSystem.value = dic[Constants.DBKey.CodeCodingSystem] as? String
            
        } else {
            codeCodingSystem.value = ""
        }
        
        if dic[Constants.DBKey.Description] != nil {
            ccrDescription.value = dic[Constants.DBKey.Description] as? String
            
        } else {
            ccrDescription.value = ""
        }
        
        if dic[Constants.DBKey.Datetime_Type] != nil {
            dateTimeType.value = dic[Constants.DBKey.Datetime_Type] as? String
            
        } else {
            dateTimeType.value = ""
        }
        
        if dic[Constants.DBKey.Datetime_Value] != nil {
            dateTimeValue.value = dic[Constants.DBKey.Datetime_Value] as? String
            
        } else {
            dateTimeValue.value = ""
        }
        
        if dic[Constants.DBKey.CCRDataObjectID] != nil {
            objectID.value = dic[Constants.DBKey.CCRDataObjectID] as? String
            
        } else {
            objectID.value = ""
        }
        
        if dic[Constants.DBKey.Testresult_Value] != nil {
            testResultValue.value = dic[Constants.DBKey.Testresult_Value] as? String
            
        } else {
            testResultValue.value = ""
        }
        
        if dic[Constants.DBKey.Testresult_Unit] != nil {
            testResultUnit.value = dic[Constants.DBKey.Testresult_Unit] as? String
            
        } else {
            testResultUnit.value = ""
        }
        
        if dic[Constants.DBKey.Read_Flag] != nil {
            readFlag.value = dic[Constants.DBKey.Read_Flag] as? String
            
        } else {
            readFlag.value = Constants.DBValue.False
            
        }
        
        if dic[Constants.DBKey.type] != nil {
            type.value = dic[Constants.DBKey.type] as? String
            
        } else {
            type.value = ""
        }
        
        if dic[Constants.DBKey.AverageResultValue] != nil {
            averageResultValue.value = dic[Constants.DBKey.AverageResultValue] as? String
            
        } else {
            averageResultValue.value = ""
        }
    }
    
    override var dbDic: [AnyHashable: Any] {
        get {
            var dic: [AnyHashable: Any] = [:]
            dic = [Constants.DBKey.User_Id: "",
                   Constants.DBKey.Description: ccrDescription.value ?? "",
                   Constants.DBKey.type: type.value ?? "",
                   Constants.DBKey.Testresult_Value: testResultValue.value ?? "",
                   Constants.DBKey.AverageResultValue: averageResultValue.value ?? "",
                   Constants.DBKey.Testresult_Unit: testResultUnit.value ?? "",
                   Constants.DBKey.Datetime_Type: dateTimeType.value ?? "",
                   Constants.DBKey.Datetime_Value: dateTimeValue.value ?? "",
                   Constants.DBKey.Actor_Id: actorID.value ?? "",
                   Constants.DBKey.Actor_Role: actorRole.value ?? "",
                   Constants.DBKey.Initial_Update: "",
                   Constants.DBKey.Flag: "",
                   Constants.DBKey.CCRDataObjectID: objectID.value ?? "",
                   Constants.DBKey.CodeValue: codeValue.value ?? "",
                   Constants.DBKey.CodeCodingSystem: codeCodingSystem.value ?? "",
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
        
        tableName = Constants.DBName.Results
    }
}
