

import Foundation

import UIKit


class ABSocketDataParser: NSObject {
    
    private class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private class func parseColumn(dic: [AnyHashable: Any]) -> String {
        guard var columnName = dic[Constants.Keys.columnName] as? String else { return Constants.EmptyString }
        guard let columnValue = dic[Constants.Keys.columnValue] as? String else { return Constants.EmptyString }
        let columnOperator = dic[Constants.Keys.columnOperator]
        
        if columnName == Constants.APIKey.description {
            columnName = Constants.DBKey.Description
        }
        
        var op = Constants.EmptyString
        
        if (columnOperator as? String) != nil {
            let columnOperator = (columnOperator as! String)
            if columnOperator == "!"                                          { op = "!="}
            else if columnOperator == "" || columnOperator == "<null>"        { op = "="}
            else                                                              { op = columnOperator }
        }
        else {
            op = "="
        }
        
        return "\(columnName) \(op) \"\(columnValue)\""
    }
    
    private class func parseInfo(dic: [AnyHashable: Any]) -> String {
        guard let columns = dic[Constants.Keys.columns] as? [[AnyHashable: Any]] else { return Constants.EmptyString }
        var units: [String] = []
        for column in columns {
            let unitString = parseColumn(dic: column)
            if unitString != Constants.EmptyString {
                units.append(unitString)
            }
        }
        
        var op = Constants.EmptyString
        if dic[Constants.Keys.operatorStirng] as? String != nil {
            op = dic[Constants.Keys.operatorStirng] as! String
        }
        else {
            op = Constants.Operator.AND
        }
        
        return units.joined(separator: " \(op) ")
    }
    
    /// get table name in string
    class func getTableName(_ string: String) -> String {
        guard let dic = convertToDictionary(text: string) else { return Constants.EmptyString }
        guard let tableName = dic[Constants.Keys.table] as? String else { return Constants.EmptyString }
        
        return tableName
    }
    
    class func getQueryString(_ dic: [AnyHashable: Any]) -> String {
        var queryString = Constants.SQLite3.query.selectAll
//        guard let data = dic[Constants.Keys.data] as? [AnyHashable: Any] else { return Constants.EmptyString}
        guard let tableName = dic[Constants.Keys.table] as? String else { return Constants.EmptyString }
        queryString += tableName
        
        guard let queryInfo = dic[Constants.Keys.queryInfo] as? [[AnyHashable: Any]] else { return queryString }
        
        var operations: [String] = []
        for info in queryInfo {
            let operation = parseInfo(dic: info)
            if operation != "" {
                operations.append(operation)
            }
        }
        
        for i in (0..<operations.count) {
            var operation = operations[i]
            operation = "(" + operation + ")"
            operations[i] = operation
        }
        
        let whereUnitString = operations.joined(separator: Constants.Operator.AND)
        
        if whereUnitString != "" {
            queryString += Constants.Operator.WHERE
            queryString += whereUnitString
        }
        return queryString
    }
    
    /// received string to db query
    class func parseStringToQuery(_ string: String) -> String {
        guard let dic = convertToDictionary(text: string) else { return Constants.EmptyString }
        return getQueryString(dic)
    }
    
    class func prepareSocketDictionary(_ dic: [[AnyHashable: Any]], tableName: String) -> [[AnyHashable: Any]] {
        var array: [CCRModel] = []
        switch tableName {
        case Constants.TableName.Result:
            for data in dic {
                let obj = CCRResult()
                obj.setData(data)
                array.append(obj)
            }
        case Constants.TableName.VitalSign:
            for data in dic {
                let obj = CCRVitalSign()
                obj.setData(data)
                array.append(obj)
            }
        case Constants.TableName.Medication:
            for data in dic {
                let obj = CCRMedication()
                obj.setData(data)
                array.append(obj)
            }
        case Constants.TableName.Problem:
            for data in dic {
                let obj = CCRProblem()
                obj.setData(data)
                array.append(obj)
            }
        case Constants.TableName.Procedure:
            for data in dic {
                let obj = CCRProcedure()
                obj.setData(data)
                array.append(obj)
            }
        default:
            break
        }
        
        var returnArray: [[AnyHashable: Any]] = []
        for obj in array {
            returnArray.append(obj.getSocketDic())
        }
        return returnArray
    }
    
    class func parseDicToJSONString(_ dic: [AnyHashable: Any]) -> String {
        var returnString = Constants.EmptyString
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            guard let value = String(data: jsonData, encoding: .utf8) else { return Constants.EmptyString }
            returnString = value
        } catch {
            print(error)
        }
        return returnString
    }
    
    class func createCCRData(_ dic: [[AnyHashable: Any]], tableName: String) -> [AnyHashable: Any] {
        let data = convertDictionaryFormat(dic)
        return [tableName.lowercased(): [data]]
    }
    
    class func createSocketData(_ ccrData: [AnyHashable: Any]) -> [AnyHashable: Any] {
        let data: [AnyHashable: Any] = [Constants.Keys.ccrData: ccrData]
        return data
    }
    
    /// parse dictionary to json
    //  [dic, dic, dic] 형태를 [key:[value, value, value], key:[value, value, value, ...] 형태로 전환
    private class func convertDictionaryFormat(_ dicArray: [[AnyHashable: Any]]) -> [AnyHashable: [Any]] {
        var parsedDic: [AnyHashable: [Any]] = [:]
        for dic in dicArray {
            for key in dic.keys {
                var array = parsedDic[key]
                if array == nil {
                    array = []
                }
                let value = dic[key] as Any
                array?.append(value)
                parsedDic.updateValue(array!, forKey: key)
            }
        }
        
        return parsedDic
    }
}

