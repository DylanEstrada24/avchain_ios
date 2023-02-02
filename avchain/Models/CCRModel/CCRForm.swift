//
//  CCRAgent.swift
//  AvatarBeans
//

import UIKit
//import EXBinder

class CCRForm {
    
    var formId                = EXProperty(String.self)
    var formName              = EXProperty(String.self)
    var formSeq               = EXProperty(Int.self)
    var formLocation          = EXProperty(String.self)
    
    var formSubmissionStageSeq  = EXProperty(Int.self)
    var formSubmissionStage     = EXProperty(String.self)
    var creationDate            = EXProperty(String.self)
    var updateDate              = EXProperty(String.self)
    
    func setData(_ dic: [AnyHashable : Any]) {        
        guard let dic = dic[Constants.DBKey.agentServiceAvatar] as? [AnyHashable: Any] else { return }
        
        //print("CCRForm : agentServiceAvatar " , dic)
        if dic[Constants.APIKey.formId] != nil { formId.value = dic[Constants.APIKey.formId] as? String }
        if dic[Constants.APIKey.agentName] != nil { formName.value = dic[Constants.APIKey.agentName] as? String }
        if dic[Constants.APIKey.agentSeq] != nil { formSeq.value = dic[Constants.APIKey.agentSeq] as? Int }
        if dic[Constants.APIKey.location] != nil { formLocation.value = dic[Constants.APIKey.location] as? String }
    }
    
    func setData2(_ dic: [AnyHashable : Any]) {
        if dic[Constants.APIKey.formSubmissionStageSeq] != nil { formSubmissionStageSeq.value = dic[Constants.APIKey.formSubmissionStageSeq] as? Int }
        if dic[Constants.APIKey.formSubmissionStage] != nil { formSubmissionStage.value = dic[Constants.APIKey.formSubmissionStage] as? String }
        if dic[Constants.APIKey.creationDate] != nil { creationDate.value = dic[Constants.APIKey.creationDate] as? String }
        if dic[Constants.APIKey.updateDate] != nil { updateDate.value = dic[Constants.APIKey.updateDate] as? String }
    }
    
}

