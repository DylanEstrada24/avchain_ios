//
//  CCRMedications.swift
//  AvatarBeans
//

import UIKit
//import EXBinder

class CCRMedication: CCRModel {
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
    
    var frequency           = EXProperty(String.self)
    var instruction         = EXProperty(String.self)
    var manufacturer        = EXProperty(String.self)
    var prescriptionNumber  = EXProperty(String.self)
    var productName         = EXProperty(String.self)
    var quantity            = EXProperty(String.self)
    var route               = EXProperty(String.self)
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
        if dic[Constants.DBKey.Datetime_Type] != nil { dateTimeType.value = dic[Constants.DBKey.Datetime_Type] as? String }
        if dic[Constants.DBKey.Datetime_Value] != nil { dateTimeValue.value = dic[Constants.DBKey.Datetime_Value] as? String }
        if dic[Constants.DBKey.CCRDataObjectID] != nil { objectID.value = dic[Constants.DBKey.CCRDataObjectID] as? String }
        if dic[Constants.DBKey.type] != nil { type.value = dic[Constants.DBKey.type] as? String }
        if dic[Constants.DBKey.Frequency] != nil { frequency.value = dic[Constants.DBKey.Frequency] as? String }
        if dic[Constants.DBKey.Instruction] != nil { instruction.value = dic[Constants.DBKey.Instruction] as? String }
        if dic[Constants.DBKey.Manufacturer] != nil { manufacturer.value = dic[Constants.DBKey.Manufacturer] as? String }
        if dic[Constants.DBKey.PrescriptionNumber] != nil { prescriptionNumber.value = dic[Constants.DBKey.PrescriptionNumber] as? String }
        if dic[Constants.DBKey.Productname] != nil { productName.value = dic[Constants.DBKey.Productname] as? String }
        if dic[Constants.DBKey.Quantity] != nil { quantity.value = dic[Constants.DBKey.Quantity] as? String }
        if dic[Constants.DBKey.Read_Flag] != nil { readFlag.value = dic[Constants.DBKey.Read_Flag] as? String }
                              else { readFlag.value = Constants.DBValue.False }
        if dic[Constants.DBKey.Route] != nil { route.value = dic[Constants.DBKey.Route] as? String }
    }
    
    override var dbDic: [AnyHashable: Any] {
        get {
            var dic: [AnyHashable: Any] = [:]
            dic = [Constants.DBKey.Productname:productName.value ?? "",
                   Constants.DBKey.User_Id:"",
                   Constants.DBKey.type:type.value ?? "",
                   Constants.DBKey.Route:route.value ?? "",
                   Constants.DBKey.Frequency:frequency.value ?? "",
                   Constants.DBKey.Quantity:quantity.value ?? "",
                   Constants.DBKey.Manufacturer:manufacturer.value ?? "",
                   Constants.DBKey.Instruction:instruction.value ?? "",
                   Constants.DBKey.Datetime_Type:dateTimeType.value ?? "",
                   Constants.DBKey.Fulfillment:"",
                   Constants.DBKey.Datetime_Value:dateTimeValue.value ?? "",
                   Constants.DBKey.Actor_Id:actorID.value ?? "",
                   Constants.DBKey.Actor_Role:actorRole.value ?? "",
                   Constants.DBKey.Initial_Update:"",
                   Constants.DBKey.Last_Update:"",
                   Constants.DBKey.Flag:"",
                   Constants.DBKey.CCRDataObjectID:objectID.value ?? "",
                   Constants.DBKey.CodeValue:codeValue.value ?? "",
                   Constants.DBKey.CodeCodingSystem:codeCodingSystem.value ?? "",
                   Constants.DBKey.PrescriptionNumber:prescriptionNumber.value ?? "",
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
        
        tableName = Constants.DBName.Medications
    }
}
