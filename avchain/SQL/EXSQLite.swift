//
//  EXSQLite.swift
//  avchain
//

import Foundation
import SQLite3

class EXSQLite: NSObject {
    static var shared = EXSQLite()
    
    enum SQLError: Error {
        case connectionError
        case queryError
        case otherError
    }
    
    enum ColumnType {
        case int
        case double
        case text
    }
    
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var path: String = {
        let dbUrl = Bundle.main.url(forResource: "AvatarBeans", withExtension: "db")!
        return dbUrl.path
    }()
    
    override init() {
        super.init()
        
        let fileManager = FileManager.default
        
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let finalDatabaseURL = documentsUrl.appendingPathComponent("AvatarBeans.db")
        
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
                print("DB does not exist in documents folder")
                
                if let dbFilePath = Bundle.main.path(forResource: "AvatarBeans", ofType: "db") {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
                } else {
                    print("data.db is not in the app bundle")
                }
            } else {
                print("Database file found at path: \(finalDatabaseURL.path)")
            }
        } catch {
            print("Unable to copy data.db: \(error)")
        }
        
        guard sqlite3_open(finalDatabaseURL.path, &db) == SQLITE_OK else {
            print("init errorrrr",SQLError.queryError)
            return
        }
        
        //        self.setupTables()
    }
    
    func setupTables() {
        do {
            try self.install(query: AB_QUERY_CREATE_TABLE_USERINFO)
            try self.execute()
            
            try self.install(query: AB_QUERY_CREATE_TABLE_TARGETS)
            try self.execute()
            
            try self.install(query: AB_QUERY_CREATE_TABLE_DAILYACTIVITY)
            try self.execute()
            
//            try self.install(query: AB_QUERY_CREATE_TABLE_RESULTS)
//            try self.execute()
//            
//            
//            try self.install(query: SQL_CREATE_RESULT_INDEX_USER_ID)
//            try self.execute()
//            try self.install(query: SQL_CREATE_RESULT_INDEX_DATETIME_VALUE)
//            try self.execute()
//            try self.install(query: SQL_CREATE_RESULT_INDEX_DESCRIPTION)
//            try self.execute()
//            
//            try self.install(query: AB_QUERY_CREATE_TABLE_VITALSIGNS)
//            try self.execute()
//            
//            try self.install(query: SQL_CREATE_VITALSIGNS_INDEX_USER_ID)
//            try self.execute()
//            try self.install(query: SQL_CREATE_VITALSIGNS_INDEX_DATETIME_VALUE)
//            try self.execute()
//            try self.install(query: SQL_CREATE_VITALSIGNS_INDEX_DESCRIPTION)
//            try self.execute()
//            
//            
//            try self.install(query: AB_QUERY_CREATE_TABLE_MEDICATIONS)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_PROBLEMS)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_PROCEDURES)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_AGENT)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_NOTIFICATION)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_PAYERS)
//            try self.execute()
//            
//            try self.install(query: SQL_CREATE_PAYERS_INDEX_USER_ID)
//            try self.execute()
//            try self.install(query: SQL_CREATE_PAYERS_INDEX_AccidentDateTimeValue)
//            try self.execute()
//            try self.install(query: SQL_CREATE_PAYERS_INDEX_DESCRIPTION)
//            try self.execute()
//            
//            
//            
//            
//            try self.install(query: AB_QUERY_CREATE_TABLE_FUNCTIONALSTATUS)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_FAMILYHISTORY)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_ALERTS)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_IMMUNIZATIONS)
//            try self.execute()
//            try self.install(query: AB_QUERY_CREATE_TABLE_ENCOUNTERS)
//            try self.execute()
            
        } catch {
            print(error)
        }

    }
    
    func install(query: String) throws {
        sqlite3_finalize(stmt)
        stmt = nil
        
        print("query : \(query)")
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            print(query + " : SQLite OK")
            return
        }
        print("wrong")
        throw SQLError.queryError
    }
    
    func bind(data:Any, withType type: ColumnType, at col: Int32 = 1) {
        switch type {
        case .int:
            if let value = data as? Int {
                sqlite3_bind_int(stmt, col, Int32(value))
            }
        case .double:
            if let value = data as? Double {
                sqlite3_bind_double(stmt, col, value)
            }
        case .text:
            if let value = data as? String {
                sqlite3_bind_text(stmt, col, value, -1, nil)
            }
        }
    }
    
    func execute(rowHandler:((OpaquePointer) -> Void)? = nil) throws {
        while true {
            let returnValue = sqlite3_step(stmt)
            switch returnValue {
            case SQLITE_DONE:
                return
            case SQLITE_ROW:
                rowHandler?(stmt!)
            default:
                print(returnValue)
                throw SQLError.otherError
            }
        }
    }
    
    deinit {
        sqlite3_finalize(stmt)
        sqlite3_close(db)
    }

}

// MARK: - 조회 Print
extension EXSQLite {
    
    func select(_ field: String, from: String) -> [Dictionary<AnyHashable,Any>] {
        var returnArray: [[AnyHashable:Any]] = []
        do {
            let query = "select " + field + " from " + from
            try self.install(query: query)
            try self.execute() { stmt in
                guard let data = self.parseData(data: stmt) else { return }
                returnArray.append(data)
            }
        } catch {
            print(error)
        }
        
        return returnArray
    }
    
    func parseResult(rawValue: UnsafePointer<Any>) {
        
    }
}


// MARK: - Parse
extension EXSQLite {
    func parseData(data: OpaquePointer) -> Dictionary<AnyHashable, Any>? {
        
        var returnDic: Dictionary<AnyHashable, Any> = [:]
        
        // get count
        let count = sqlite3_column_count(stmt)
        
        // parse key
        for i in 0..<count {
            let valueType = sqlite3_column_type(stmt, i)
            
            let key = String(cString:sqlite3_column_name(stmt, i))
            let value: Any
            
            switch valueType {
            case SQLITE_INTEGER:
                value = sqlite3_column_int(stmt, i)
            case SQLITE_FLOAT:
//                value = "TODO: need to set value for float"
                value = sqlite3_column_double(stmt, i)
            case SQLITE_BLOB:
//                value = "TODO: need to set value for blob"
                value = ""
            case SQLITE_TEXT:
//                value = String(cString: sqlite3_column_text(stmt, i))
                
                guard let pointer = sqlite3_column_text(stmt, i) else { continue }
                let count = sqlite3_column_bytes(stmt, i)
                let data = Data(bytes: pointer, count: Int(count))
                
                value = String(bytes: data, encoding: .utf8) as Any
                
            default:
//                value = "TODO: need to set default error handle"
                value = ""
            }
            
            returnDic.updateValue(value, forKey: key)
            
        }
        
        if returnDic.keys.count <= 0 {
            return nil
        }
        
        return returnDic
    }
}
