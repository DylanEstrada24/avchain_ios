//
//  CCRAgent.swift
//  AvatarBeans
//

import UIKit
//import EXBinder

class CCRAgent: CCRModel {
    var agentName               = EXProperty(String.self)
    var homeDelete              = EXProperty(String.self)
    var agentListDelete         = EXProperty(String.self)
    var agentOrder              = EXProperty(String.self)
    var agentSeq                = EXProperty(String.self)
    var agentDescription        = EXProperty(String.self)
    
    var agentTypeCode           = EXProperty(String.self) // jth add
    
    override func setData(_ dic: [AnyHashable : Any]) {
        super.setData(dic)
        
       // print("CCRAgent ### ","setData()")
        
        if dic[Constants.DBKey.Agent_Name] != nil { agentName.value = dic[Constants.DBKey.Agent_Name] as? String }
        if dic[Constants.DBKey.Home_Delete] != nil { homeDelete.value = dic[Constants.DBKey.Home_Delete] as? String }
        if dic[Constants.DBKey.Agent_List_Delete] != nil { agentListDelete.value = dic[Constants.DBKey.Agent_List_Delete] as? String }
        if dic[Constants.DBKey.Agent_Order] != nil { agentOrder.value = dic[Constants.DBKey.Agent_Order] as? String }
        if dic[Constants.DBKey.Agent_Seq] != nil { agentSeq.value = dic[Constants.DBKey.Agent_Seq] as? String }
        if dic[Constants.APIKey.agentDescription] != nil { agentDescription.value = dic[Constants.APIKey.agentDescription] as? String }
        /*
        print("agentSeq.value",agentSeq.value)
        if agentSeq.value! != "1" {
            if dic[Constants.DBKey.Home_Delete] == nil { homeDelete.value = "T" }
        }
        */
        guard let dic = dic[Constants.DBKey.agentServiceAvatar] as? [AnyHashable: Any] else { return }
        
        if dic[Constants.APIKey.agentName] != nil { agentName.value = dic[Constants.APIKey.agentName] as? String }
        if dic[Constants.APIKey.agentDescription] != nil { agentDescription.value = dic[Constants.APIKey.agentDescription] as? String }
        if dic[Constants.APIKey.agentTypeCode] != nil { agentTypeCode.value = dic[Constants.APIKey.agentTypeCode] as? String } // jth add
        
        super.setData(dic)
    }
    
    override func doUpdateQuery() {
        
         //print("CCRAgent ### ","doUpdateQuery()")
        
        super.doUpdateQuery()
    }
    
    override var dbDic: [AnyHashable: Any] {
        get {
            var dic = [Constants.DBKey.Agent_Name:agentName.value ?? "",
                       Constants.DBKey.Agent_Seq:agentSeq.value ?? "",
                       Constants.APIKey.agentDescription:agentDescription.value ?? ""]
            //print("CCRAgent ### ","agentName.value ", agentName.value)
            if homeDelete.value != nil {
                dic.updateValue(homeDelete.value, forKey: Constants.DBKey.Home_Delete)
            }
            if agentOrder.value != nil {
                dic.updateValue(agentOrder.value, forKey: Constants.DBKey.Agent_Order)
            }
            //print("CCRAgent ### ","dic ", dic)
            return dic
        }
    }
    
    override init() {
        super.init()
        
        tableName = Constants.DBName.Agent
    }
    
}
