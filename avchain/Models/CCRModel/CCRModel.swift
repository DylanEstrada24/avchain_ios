//
//  CCRModel.swift
//  AvatarBeans
//

import UIKit

class CCRModel: EXModel {
    var tableName: String? = "Default Table Name"
    
    override func setData(_ dic: [AnyHashable : Any]) {
        super.setData(dic)
    }
    
    open var dbDic: [AnyHashable: Any] {
        get {
            return [:]
        }
    }
    
    
    func doDeleteQuery(){
        DispatchQueue.main.async {
            guard let query = self.getDeleteQuery() else { return }
            ABSQLite.delete(query)
        }
    }
    
    func getDeleteQuery() -> String? {
        guard let tableName = tableName else { return nil }
        let dic = self.dbDic
        
        guard dic.keys.count > 0 else { return nil }
        
        // create temp dic
        var tempDic: [AnyHashable: AnyObject] = [:]
        for key in dic.keys {
            guard let key = key as? String else { continue }
            let value = dic[key] as AnyObject
            
            tempDic.updateValue(value, forKey: key)
        }
        
        guard tempDic.keys.count > 0 else { return nil }
        
        var keyString = Constants.EmptyString
        var valueString = Constants.EmptyString
        
        
        var query = "DELETE FROM " + tableName
        query += " WHERE "
        
        for key in tempDic.keys {
            guard let key = key as? String else { continue }
            if (tempDic[key] as? String) != nil || (tempDic[key] as? Int32) != nil {}
            else { continue }
            
            if(key == "CCRDataObjectID"){
                keyString = key
                if tempDic[key] as? String != nil {
                    let value = tempDic[key] as! String
                    valueString = value
                }
                else {
                    let value = tempDic[key] as! Int32
                    valueString = String(format: "%d", value)
                }
            }
        }
        
        query += keyString + " = '" + valueString + "'"
        print("delete query ", query)
        
        return query
    }
    
    func doUpdateQuery() {
        DispatchQueue.main.async {
            guard let query = self.getUpdateQuery() else { return }
            ABSQLite.insert(query)
            print("insert query ", query)
//            CCRManager.shared.loadAllData()
        }
    }
    
    func getUpdateQuery() -> String? {
        guard let tableName = tableName else { return nil }
        let dic = self.dbDic
        
        guard dic.keys.count > 0 else { return nil }
        
        // create temp dic
        var tempDic: [AnyHashable: AnyObject] = [:]
        for key in dic.keys {
            guard let key = key as? String else { continue }
            let value = dic[key] as AnyObject
            
            tempDic.updateValue(value, forKey: key)
        }
        
        guard tempDic.keys.count > 0 else { return nil }
        
        var keyString = Constants.EmptyString
        var valueString = Constants.EmptyString
        
        
        var query = "INSERT OR REPLACE INTO " + tableName
        query += " ( "
        
        for key in tempDic.keys {
            guard let key = key as? String else { continue }
            if (tempDic[key] as? String) != nil || (tempDic[key] as? Int32) != nil {}
            else { continue }
            
            keyString += key
            keyString += ", "
            valueString += "\""
            if tempDic[key] as? String != nil {
                let value = tempDic[key] as! String
                valueString += value
            }
            else {
                let value = tempDic[key] as! Int32
                valueString += String(format: "%d", value)
            }
            
            valueString += "\""
            valueString += ", "
        }
        
        guard let keyCommaIndex = keyString.lastIndex(of: ",") else { return nil }
        keyString.remove(at: keyCommaIndex)
        guard let valueCommaIndex = valueString.lastIndex(of: ",") else { return nil }
        valueString.remove(at: valueCommaIndex)
        
        
        query += keyString + ") values ( " + valueString + ")"
        
        //print("insert query ",query)
        
        return query
    }
    
    /// 소켓 통신에 사용할 Dictionary 객체 반환
    /// description 은 모든 Object 의 property로 예약되어 있으므로 ccrDescription key 에 해당하는 property는 key를 description으로 수정하여 리턴
    func getSocketDic() -> [AnyHashable: Any] {
        var returnDic: [AnyHashable: Any] = [:]
        let keys = self.propertyList()
        for key in keys {
            if key == Constants.APIKey.ccrDescription {
                let property = self[key] as! EXProperty<String>
                returnDic.updateValue(property.value as Any, forKey: Constants.APIKey.description)
            }
            else if key == Constants.DBKey.Section_Id || key == Constants.DBKey.Phr_Id {
                continue
            }
            else {
                let property = self[key] as! EXProperty<String>
                returnDic.updateValue(property.value as Any, forKey: key)
            }
        }
        return returnDic
    }
}
