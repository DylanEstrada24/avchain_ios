//
//  ABSQLite.swift
//  avchain
//

import Foundation

class ABSQLite: NSObject {
    class func getAllTableName() -> [String] {
        var tableNameArray: [String] = []
        do {
            try EXSQLite.shared.install(query: AB_QUERY_MASTER_TABLE)
            try EXSQLite.shared.execute() { stmt in
                guard let dic = EXSQLite.shared.parseData(data: stmt) else { return }
                guard let name = dic["name"] as? String else { return }
                tableNameArray.append(name)
            }
        } catch {
            print(error)
        }
        
        for i in 0..<tableNameArray.count {
            let name = tableNameArray[i]
            if name == "sqlite_sequence" {
                tableNameArray.remove(at: i)
                break
            }
        }
        
        return tableNameArray
    }
    
    class func select(_ field: String, table: String) -> [[AnyHashable: Any]] {
        return EXSQLite.shared.select(field, from: table)
    }
    
    class func insert(_ query: String) {
        //print("ABSQLite insert ", query)
        DispatchQueue.main.async {
            do {
                try EXSQLite.shared.install(query: query)
                try EXSQLite.shared.execute()
                //print("insert done")
            } catch {
                print(error)
            }
        }
    }
    
    class func update(_ query: String) {
        //print("ABSQLite update ", query)
        DispatchQueue.main.async {
            do {
                try EXSQLite.shared.install(query: query)
                try EXSQLite.shared.execute()
                //print("update done", query)
            } catch {
                print(error)
            }
        }
    }
    
    class func delete(_ query: String) {
        DispatchQueue.main.async {
            do {
                try EXSQLite.shared.install(query: query)
                try EXSQLite.shared.execute()
                //print("delete done")
            } catch {
                print(error)
            }
        }
    }
    
    class func doQuery(_ query: String) -> [[AnyHashable: Any]] {
        var returnArray: [[AnyHashable: Any]] = []
        //DispatchQueue.main.async {
            do {
                try EXSQLite.shared.install(query: query)
                try EXSQLite.shared.execute() { stmt in
                    guard let data = EXSQLite.shared.parseData(data: stmt) else { return }
                    returnArray.append(data)
                }
            }
            catch {
                print(error)
            }
        //}
        return returnArray
    }
    
    
    // MARK: - Load
    class func load_Results() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_RESULT)
    }
    
    class func load_VitalSigns() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_VITALSIGNS)
    }
    
    class func load_Medications() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_MEDICATIONS)
    }
    
    class func load_Payers() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_PAYERS)
    }
    
    class func load_Problems() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_PROBLEMS)
    }
    
    class func load_Procedures() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_PROCEDURES)
    }
    
    class func load_Agents() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_AGENTS)
    }
    
    class func load_Notificaions() -> [[AnyHashable: Any]] {
        return select("*", table: AB_TABLE_NAME_NOTIFICATION)
    }
}
