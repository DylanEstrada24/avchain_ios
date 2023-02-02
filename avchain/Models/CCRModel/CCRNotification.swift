//
//  CCRNotification.swift
//  AvatarBeans
//

import UIKit
//import EXBinder

class CCRNotification: CCRModel {
    var Section_Id  = EXProperty(Int32.self)
    var Seq         = EXProperty(String.self)
    var User_Id     = EXProperty(String.self)
    var Message_ID  = EXProperty(String.self)
    var Message     = EXProperty(String.self)
    var Read_Flag   = EXProperty(String.self)
    var Initial_Update = EXProperty(String.self)
    
    override var dbDic: [AnyHashable: Any] {
        get {
            var returnDic: [AnyHashable: Any] = [ Constants.DBKey.Seq:Seq.value ?? "",
                                                  Constants.DBKey.User_Id:User_Id.value ?? "",
                                                  Constants.DBKey.Message:Message.value ?? "",
                                                  Constants.DBKey.Message_ID:Message_ID.value ?? "",
                                                  Constants.DBKey.Read_Flag:Read_Flag.value ?? "",
                                                  Constants.DBKey.Initial_Update: Initial_Update.value ?? ""]
            if Section_Id.value != nil {
                returnDic.updateValue(Section_Id.value!, forKey: Constants.DBKey.Section_Id)
            }
            
            return returnDic
        }
    }
    
    override init() {
        super.init()
        
        tableName = Constants.DBName.Notification
    }
}
