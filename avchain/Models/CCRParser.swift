//
//  CCRParser.swift
//  AvatarBeans
//

import UIKit

class CCRParser: NSObject {
    class func parseProcedures(_ data: Dictionary<AnyHashable, Any>) -> [CCRProcedure] {
        var array: [CCRProcedure] = []
        
        guard let procedures = data[Constants.APIKey.procedures] as? [Dictionary<AnyHashable, Any>] else { return array}
        
        for procedure in procedures {
            guard let actorRole = procedure[Constants.APIKey.actorRole] as? [String] else { continue }
            guard let codeValue = procedure[Constants.APIKey.codeValue] as? [String] else { continue }
            guard let actorID = procedure[Constants.APIKey.actorID] as? [String] else { continue }
            guard let description = procedure[Constants.APIKey.description] as? [String] else { continue }
            guard let additionalDescription = procedure[Constants.APIKey.additionalDescription] as? [String] else { continue }
            guard let codeCodingSystem = procedure[Constants.APIKey.codeCodingSystem] as? [String] else { continue }
            guard let dateTimeValue = procedure[Constants.APIKey.dateTimeValue] as? [String] else { continue }
            guard let objectID = procedure[Constants.APIKey.objectID] as? [String] else { continue }
            
            for i in 0..<objectID.count {
                let dic = [Constants.APIKey.actorRole : actorRole[i],
                           Constants.APIKey.codeValue:codeValue[i],
                           Constants.APIKey.actorID:actorID[i],
                           Constants.APIKey.ccrDescription:description[i],
                           Constants.APIKey.additionalDescription:additionalDescription[i],
                           Constants.APIKey.codeCodingSystem:codeCodingSystem[i],
                           Constants.APIKey.dateTimeValue:dateTimeValue[i],
                           Constants.APIKey.objectID:objectID[i] ]
                let object = CCRProcedure()
                object.setData(dic)
                
                array.append(object)
            }
        }
        
        return array
    }
    
    class func parseVitalSigns(_ data: Dictionary<AnyHashable, Any>) -> [CCRVitalSign] {
        var array: [CCRVitalSign] = []
        
        guard let vitalSigns = data[Constants.APIKey.vitalsigns] as? [Dictionary<AnyHashable, Any>] else { return array }
        for sign in vitalSigns {
            guard let actorID = sign[Constants.APIKey.actorID] as? [String] else { continue }
            guard let codeCodingSystem = sign[Constants.APIKey.codeCodingSystem] as? [String] else { continue }
            guard let description = sign[Constants.APIKey.description] as? [String] else { continue }
            guard let testResultValue = sign[Constants.APIKey.testResultValue] as? [String] else { continue }
            guard let type = sign[Constants.APIKey.type] as? [String] else { continue }
            guard let objectID = sign[Constants.APIKey.objectID] as? [String] else { continue }
            guard let codeValue = sign[Constants.APIKey.codeValue] as? [String] else { continue }
            guard let testResultUnit = sign[Constants.APIKey.testResultUnit] as? [String] else { continue }
            guard let dateTimeType = sign[Constants.APIKey.dateTimeType] as? [String] else { continue }
            guard let dateTimeValue = sign[Constants.APIKey.dateTimeValue] as? [String] else { continue }
            guard let actorRole = sign[Constants.APIKey.actorRole] as? [String] else { continue }
            
            for i in 0..<objectID.count {
                let dic = [Constants.APIKey.actorID : actorID[i],
                           Constants.APIKey.codeCodingSystem:codeCodingSystem[i],
                           Constants.APIKey.ccrDescription:description[i],
                           Constants.APIKey.testResultValue:testResultValue[i],
                           Constants.APIKey.type:type[i],
                           Constants.APIKey.objectID:objectID[i],
                           Constants.APIKey.codeValue:codeValue[i],
                           Constants.APIKey.testResultUnit:testResultUnit[i],
                           Constants.APIKey.dateTimeType:dateTimeType[i],
                           Constants.APIKey.dateTimeValue:dateTimeValue[i],
                           Constants.APIKey.actorRole:actorRole[i] ]
                let object = CCRVitalSign()
                object.setData(dic)
                
                array.append(object)
            }
        }
        
        return array
    }
    
    class func parseResults(_ data: Dictionary<AnyHashable, Any>) -> [CCRResult] {
        var array: [CCRResult] = []
        
        
        guard let results = data[Constants.APIKey.results] as? [Dictionary<AnyHashable, Any>] else { return array }
        for result in results {
            guard let testResultValue = result[Constants.APIKey.testResultValue] as? [String] else { continue }
            guard let codeValue = result[Constants.APIKey.codeValue] as? [String] else { continue }
            guard let dateTimeType = result[Constants.APIKey.dateTimeType] as? [String] else { continue }
            guard let dateTimeValue = result[Constants.APIKey.dateTimeValue] as? [String] else { continue }
            guard let actorID = result[Constants.APIKey.actorID] as? [String] else { continue }
            guard let description = result[Constants.APIKey.description] as? [String] else { continue }
            guard let codeCodingSystem = result[Constants.APIKey.codeCodingSystem] as? [String] else { continue }
            guard let actorRole = result[Constants.APIKey.actorRole] as? [String] else { continue }
            guard let objectID = result[Constants.APIKey.objectID] as? [String] else { continue }
            guard let testResultUnit = result[Constants.APIKey.testResultUnit] as? [String] else { continue }
            
            for i in 0..<objectID.count {
                let dic = [Constants.APIKey.testResultValue : testResultValue[i],
                           Constants.APIKey.codeValue:codeValue[i],
                           Constants.APIKey.dateTimeType:dateTimeType[i],
                           Constants.APIKey.dateTimeValue:dateTimeValue[i],
                           Constants.APIKey.actorID:actorID[i],
                           Constants.APIKey.ccrDescription:description[i],
                           Constants.APIKey.codeCodingSystem:codeCodingSystem[i],
                           Constants.APIKey.actorRole:actorRole[i],
                           Constants.APIKey.objectID:objectID[i],
                           Constants.APIKey.testResultUnit:testResultUnit[i] ]
                let object = CCRResult()
                object.setData(dic)
                
                array.append(object)
            }
        }
        
        return array
    }
    
    class func parseProblems(_ data: Dictionary<AnyHashable, Any>) -> [CCRProblem] {
        var array: [CCRProblem] = []
        
        guard let problems = data[Constants.APIKey.problems] as? [Dictionary<AnyHashable, Any>] else { return array }
        for problem in problems {
            guard let type = problem[Constants.APIKey.type] as? [String] else { continue }
            guard let objectID = problem[Constants.APIKey.objectID] as? [String] else { continue }
            guard let description = problem[Constants.APIKey.description] as? [String] else { continue }
            guard let codeValue = problem[Constants.APIKey.codeValue] as? [String] else { continue }
            guard let dateTimeValue = problem[Constants.APIKey.dateTimeValue] as? [String] else { continue }
            guard let status = problem[Constants.APIKey.status] as? [String] else { continue }
            guard let dateTimeType = problem[Constants.APIKey.dateTimeType] as? [String] else { continue }
            guard let actorID = problem[Constants.APIKey.actorID] as? [String] else { continue }
            guard let codeCodingSystem = problem[Constants.APIKey.codeCodingSystem] as? [String] else { continue }
            guard let actorRole = problem[Constants.APIKey.actorRole] as? [String] else { continue }
            guard let additionalDescription = problem[Constants.APIKey.additionalDescription] as? [String] else { continue }
            
            for i in 0..<objectID.count {
                var dic: [AnyHashable: Any] = [:]
                if type.count != 0
                    { dic.updateValue(type[i], forKey: Constants.APIKey.type) }
                if objectID.count != 0
                    { dic.updateValue(objectID[i], forKey: Constants.APIKey.objectID) }
                if description.count != 0
                    { dic.updateValue(description[i], forKey: Constants.APIKey.description) }
                if codeValue.count != 0
                    { dic.updateValue(codeValue[i], forKey: Constants.APIKey.codeValue) }
                if dateTimeValue.count != 0
                    { dic.updateValue(dateTimeValue[i], forKey: Constants.APIKey.dateTimeValue) }
                if status.count != 0
                    { dic.updateValue(status[i], forKey: Constants.APIKey.status) }
                if dateTimeType.count != 0
                    { dic.updateValue(dateTimeType[i], forKey: Constants.APIKey.dateTimeType) }
                if codeCodingSystem.count != 0
                    { dic.updateValue(codeCodingSystem[i], forKey: Constants.APIKey.codeCodingSystem) }
                if actorID.count != 0
                    { dic.updateValue(actorID[i], forKey: Constants.APIKey.actorID) }
                if actorRole.count != 0
                    { dic.updateValue(actorRole[i], forKey: Constants.APIKey.actorRole) }
                if additionalDescription.count != 0
                    { dic.updateValue(additionalDescription[i], forKey: Constants.APIKey.additionalDescription) }
                
                let object = CCRProblem()
                object.setData(dic)
                
                array.append(object)
            }
        }
        
        return array
    }
    
    class func parseMedications(_ data: Dictionary<AnyHashable, Any>) -> [CCRMedication] {
        var array: [CCRMedication] = []
        
        guard let medications = data[Constants.APIKey.medications] as? [Dictionary<AnyHashable, Any>] else { return array }
        for medication in medications {
            guard let productName = medication[Constants.APIKey.productName] as? [String] else { continue }
            guard let dateTimeValue = medication[Constants.APIKey.dateTimeValue] as? [String] else { continue }
            guard let codeValue = medication[Constants.APIKey.codeValue] as? [String] else { continue }
            guard let actorID = medication[Constants.APIKey.actorID] as? [String] else { continue }
            guard let actorRole = medication[Constants.APIKey.actorRole] as? [String] else { continue }
            guard let manufacturer = medication[Constants.APIKey.manufacturer] as? [String] else { continue }
            guard let quantity = medication[Constants.APIKey.quantity] as? [String] else { continue }
            guard let prescriptionNumber = medication[Constants.APIKey.prescriptionNumber] as? [String] else { continue }
            guard let type = medication[Constants.APIKey.type] as? [String] else { continue }
            guard let frequency = medication[Constants.APIKey.frequency] as? [String] else { continue }
            guard let dateTimeType = medication[Constants.APIKey.dateTimeType] as? [String] else { continue }
            guard let codeCodingSystem = medication[Constants.APIKey.codeCodingSystem] as? [String] else { continue }
            guard let objectID = medication[Constants.APIKey.objectID] as? [String] else { continue }
            guard let instruction = medication[Constants.APIKey.instruction] as? [String] else { continue }
            guard let route = medication[Constants.APIKey.route] as? [String] else { continue }
            
            for i in 0..<objectID.count {
                let dic = [Constants.APIKey.productName : productName[i],
                           Constants.APIKey.dateTimeValue:dateTimeValue[i],
                           Constants.APIKey.codeValue:codeValue[i],
                           Constants.APIKey.actorID:actorID[i],
                           Constants.APIKey.actorRole:actorRole[i],
                           Constants.APIKey.manufacturer:manufacturer[i],
                           Constants.APIKey.quantity:quantity[i],
                           Constants.APIKey.prescriptionNumber:prescriptionNumber[i],
                           Constants.APIKey.type:type[i],
                           Constants.APIKey.frequency:frequency[i],
                           Constants.APIKey.dateTimeType:dateTimeType[i],
                           Constants.APIKey.codeCodingSystem:codeCodingSystem[i],
                           Constants.APIKey.objectID:objectID[i],
                           Constants.APIKey.instruction:instruction[i],
                           Constants.APIKey.route:route[i] ]
                let object = CCRMedication()
                object.setData(dic)
                
                array.append(object)
            }
        }
        
        return array
    }
    
    
    class func parsePayers(_ data: Dictionary<AnyHashable, Any>) -> [CCRPayer] {
        var array: [CCRPayer] = []
        
        
        guard let results = data[Constants.APIKey.payers] as? [Dictionary<AnyHashable, Any>] else { return array }
        print("results",results)
        for result in results {
            print("result",result)
            guard let additionalDescription = result[Constants.APIKey.additionalDescription] as? [String] else { continue }
            guard let accidentDateTimeValue = result[Constants.APIKey.accidentDateTimeValue] as? [String] else { continue }
            guard let inDateTimeValue = result[Constants.APIKey.inDateTimeValue] as? [String] else { continue }
            guard let outDateTimeValue = result[Constants.APIKey.outDateTimeValue] as? [String] else { continue }
            guard let inEndDateTimeValue = result[Constants.APIKey.inEndDateTimeValue] as? [String] else { continue }
            guard let outEndDateTimeValue = result[Constants.APIKey.outEndDateTimeValue] as? [String] else { continue }
            guard let inOutIndicator = result[Constants.APIKey.inOutIndicator] as? [String] else { continue }
            guard let codeValue = result[Constants.APIKey.codeValue] as? [String] else { continue }
            guard let actorID = result[Constants.APIKey.actorID] as? [String] else { continue }
            guard let description = result[Constants.APIKey.description] as? [String] else { continue }
            guard let codeCodingSystem = result[Constants.APIKey.codeCodingSystem] as? [String] else { continue }
            guard let actorRole = result[Constants.APIKey.actorRole] as? [String] else { continue }
            guard let objectID = result[Constants.APIKey.objectID] as? [String] else { continue }
            
            for i in 0..<objectID.count {
                let dic = [Constants.APIKey.additionalDescription : additionalDescription[i],
                           Constants.APIKey.accidentDateTimeValue:accidentDateTimeValue[i],
                           Constants.APIKey.inDateTimeValue:inDateTimeValue[i],
                           Constants.APIKey.outDateTimeValue:outDateTimeValue[i],
                           Constants.APIKey.inEndDateTimeValue:inEndDateTimeValue[i],
                           Constants.APIKey.outEndDateTimeValue:outEndDateTimeValue[i],
                           Constants.APIKey.codeValue:codeValue[i],
                           Constants.APIKey.actorID:actorID[i],
                           Constants.APIKey.ccrDescription:description[i],
                           Constants.APIKey.codeCodingSystem:codeCodingSystem[i],
                           Constants.APIKey.actorRole:actorRole[i],
                           Constants.APIKey.objectID:objectID[i],
                           Constants.APIKey.inOutIndicator:inOutIndicator[i] ]
                let object = CCRPayer()
                object.setData(dic)
                
                array.append(object)
            }
        }
        
        return array
    }
}
