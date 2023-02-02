//
//  CCRManager.swift
//  AvatarBeans
//

import UIKit
//import EXBinder
import UserNotifications

class CCRManager: EXModel {
    static var shared = CCRManager()
    
    var array_CCR       : [CCRObject]       = []
    var array_Result    : [CCRResult]       = []
    var array_VitalSign : [CCRVitalSign]    = []
    var array_Medication: [CCRMedication]   = []
    var array_Problem   : [CCRProblem]      = []
    var array_Procedures: [CCRProcedure]    = []
    var array_Agent     : [CCRAgent]        = []
    var array_Form      : [CCRForm]         = []
    var array_Payer     : [CCRPayer]        = []
    
    // MARK: - Initializer
    override init() {
        super.init()
        loadAllData()
    }
    
    // MARK: Private
    private func getData(with date:String, data: [CCRModel]) -> [CCRModel] {
        
        print("getData()-----------------------------------------")
        var returnArray: [CCRModel] = []
        for ccr in data {
            guard let dateProperty = ccr[Constants.APIKey.dateTimeValue] as? EXProperty<String> else { continue }
            guard let stringValue = dateProperty.value else { continue }
            /*
             if stringValue == date {
             returnArray.append(ccr)
             }
             */
            let separated = stringValue.split(separator: "~")
            if separated.count == 2 {
                let startDateString = String(separated[0]).replacingOccurrences(of: " ", with: "")
                let endDateString = String(separated[1]).replacingOccurrences(of: " ", with: "")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let startDate = formatter.date(from: startDateString)
                let endDate = formatter.date(from: endDateString)
                let targetDate = formatter.date(from: date)
                
                guard let s = startDate?.timeIntervalSince1970 else { break }
                guard let e = endDate?.timeIntervalSince1970 else { break }
                guard let t = targetDate?.timeIntervalSince1970 else { break }
                
                if s >= t && e <= t {
                    returnArray.append(ccr)
                }
            }
            else {
                if stringValue == date {
                    returnArray.append(ccr)
                }
            }
            
        }
        
        return returnArray
    }
    
    private func getDataPayer(with date:String, data: [CCRModel]) -> [CCRModel] {
        
        print("getDataPayer()-----------------------------------------")
        var returnArray: [CCRModel] = []
        for ccr in data {
            guard let odateProperty = ccr[Constants.APIKey.outDateTimeValue] as? EXProperty<String> else { continue }
            print("odateProperty", odateProperty)
            guard let idateProperty = ccr[Constants.APIKey.inDateTimeValue] as? EXProperty<String> else { continue }
            print("idateProperty", idateProperty)
            
            guard let ostringValue = odateProperty.value else { continue }
            print("ostringValue", ostringValue)
            guard let istringValue = idateProperty.value else { continue }
            print("istringValue", istringValue)
            var stringValue = ""
            if(ostringValue != ""){
                stringValue = ostringValue
            }
            if(istringValue != ""){
                stringValue = istringValue
            }
            /*
             if stringValue == date {
             returnArray.append(ccr)
             }
             */
            let separated = stringValue.split(separator: "~")
            if separated.count == 2 {
                let startDateString = String(separated[0]).replacingOccurrences(of: " ", with: "")
                let endDateString = String(separated[1]).replacingOccurrences(of: " ", with: "")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let startDate = formatter.date(from: startDateString)
                let endDate = formatter.date(from: endDateString)
                let targetDate = formatter.date(from: date)
                
                guard let s = startDate?.timeIntervalSince1970 else { break }
                guard let e = endDate?.timeIntervalSince1970 else { break }
                guard let t = targetDate?.timeIntervalSince1970 else { break }
                
                if s >= t && e <= t {
                    returnArray.append(ccr)
                }
            }
            else {
                if stringValue == date {
                    returnArray.append(ccr)
                }
            }
            
        }
        
        return returnArray
    }
    
    // MARK: - Set
    func setCCRList(_ dataArray: [Dictionary<AnyHashable, Any>]) {
        print("CCRManager ### ","setCCRList()")
        array_CCR.removeAll()
        
        for data in dataArray {
            guard let data = data as? [String: Any] else { continue }
            
            let ccr = CCRObject()
            ccr.setData(data)
            array_CCR.append(ccr)
        }
        print("CCRManager ### ","setCCRList()","array_CCR.count" , array_CCR.count)
    }
    
    // MARK: - Get
    func getAgents(_ name: String) -> CCRAgent? {
        for agent in array_Agent {
            if agent.agentName.value == name {
                return agent
            }
        }
        
        return nil
    }
    
    func getAgent(_ seq: String) -> CCRAgent? {
        for agent in array_Agent {
            if agent.agentSeq.value == seq {
                return agent
            }
        }
        
        return nil
    }
    
    func getNotification(_ id: String) -> CCRNotification? {
        let array = getNotifications()
        for obj in array {
            if obj.Message_ID.value == id {
                return obj
            }
        }
        return nil
    }
    
    func getNotifications() -> [CCRNotification] {
        var array: [CCRNotification] = []
        
        let tempArray = ABSQLite.load_Notificaions()
        for dic in tempArray {
            let obj = CCRNotification()
            obj.setData(dic)
            array.append(obj)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.FullDate
        
        array.sort { (a, b) -> Bool in
            guard let aDate = formatter.date(from: a.Initial_Update.value) else { return true }
            guard let bDate = formatter.date(from: b.Initial_Update.value) else { return true}
            return aDate.timeIntervalSince1970 > bDate.timeIntervalSince1970
        }
        
        return array
    }
    
    func getNewNotificationCount() -> Int {
        var count = 0
        let array = getNotifications()
        for obj in array {
            guard let flag = obj.Read_Flag.value else { continue }
            if flag == Constants.DBValue.False { count += 1 }
        }
        
        return count
    }
    
    func getNewCCRDataCount() -> Int {
        var count = 0
        for obj in array_Problem {
            guard let flag = obj[Constants.ModelKey.readFlag] as? EXProperty<String> else { continue }
            if flag.value != Constants.DBValue.True {
                count += 1
            }
        }
        
        for obj in array_VitalSign {
            guard let flag = obj[Constants.ModelKey.readFlag] as? EXProperty<String> else { continue }
            if flag.value != Constants.DBValue.True {
                count += 1
            }
        }
        
        for obj in array_Procedures {
            guard let flag = obj[Constants.ModelKey.readFlag] as? EXProperty<String> else { continue }
            if flag.value != Constants.DBValue.True {
                count += 1
            }
        }
        
        for obj in array_Result {
            guard let flag = obj[Constants.ModelKey.readFlag] as? EXProperty<String> else { continue }
            if flag.value != Constants.DBValue.True {
                count += 1
            }
        }
        
        for obj in array_Medication {
            guard let flag = obj[Constants.ModelKey.readFlag] as? EXProperty<String> else { continue }
            if flag.value != Constants.DBValue.True {
                count += 1
            }
        }
        
        for obj in array_Payer {
            guard let flag = obj[Constants.ModelKey.readFlag] as? EXProperty<String> else { continue }
            if flag.value != Constants.DBValue.True {
                count += 1
            }
        }
        return count
    }
    
    func updateReadCCRData() {
        
        ABSQLite.update("UPDATE Problems set Read_Flag = '\(Constants.DBValue.True)'")
        ABSQLite.update("UPDATE VitalSigns set Read_Flag = '\(Constants.DBValue.True)'")
        ABSQLite.update("UPDATE Procedures set Read_Flag = '\(Constants.DBValue.True)'")
        ABSQLite.update("UPDATE Results set Read_Flag = '\(Constants.DBValue.True)'")
        ABSQLite.update("UPDATE Medications set Read_Flag = '\(Constants.DBValue.True)'")
        ABSQLite.update("UPDATE Payers set Read_Flag = '\(Constants.DBValue.True)'")
        
    }
    
    // MARK: - Load & Parse
    func loadAllData() {
        // clear all arrays
        array_Result.removeAll()
        array_VitalSign.removeAll()
        array_Medication.removeAll()
        array_Problem.removeAll()
        array_Procedures.removeAll()
        array_Agent.removeAll()
        array_Payer.removeAll()
        
        var results = ABSQLite.load_Results()
        for result in results {
            let obj = CCRResult()
            obj.setData(result)
            array_Result.append(obj)
        }
        array_Result.sort { (a, b) -> Bool in
            a.dateTimeValue.value > b.dateTimeValue.value ? true : false
        }
        
        results = ABSQLite.load_VitalSigns()
        for result in results {
            let obj = CCRVitalSign()
            obj.setData(result)
            array_VitalSign.append(obj)
        }
        array_VitalSign.sort { (a, b) -> Bool in
            a.dateTimeValue.value > b.dateTimeValue.value ? true : false
        }
        
        results = ABSQLite.load_Problems()
        for result in results {
            let obj = CCRProblem()
            obj.setData(result)
            array_Problem.append(obj)
        }
        array_Problem.sort { (a, b) -> Bool in
            a.dateTimeValue.value > b.dateTimeValue.value ? true : false
        }
        
        results = ABSQLite.load_Medications()
        for result in results {
            let obj = CCRMedication()
            obj.setData(result)
            array_Medication.append(obj)
        }
        array_Medication.sort { (a, b) -> Bool in
            a.dateTimeValue.value > b.dateTimeValue.value ? true : false
        }
        
        results = ABSQLite.load_Procedures()
        for result in results {
            let obj = CCRProcedure()
            obj.setData(result)
            array_Procedures.append(obj)
        }
        array_Procedures.sort { (a, b) -> Bool in
            a.dateTimeValue.value > b.dateTimeValue.value ? true : false
        }
        
        results = ABSQLite.load_Agents()
        for result in results {
            let obj = CCRAgent()
            obj.setData(result)
            array_Agent.append(obj)
        }
        
        results = ABSQLite.load_Payers()
        for result in results {
            let obj = CCRPayer()
            obj.setData(result)
            array_Payer.append(obj)
        }
        array_Payer.sort { (a, b) -> Bool in
            a.accidentDateTimeValue.value > b.accidentDateTimeValue.value ? true : false
        }
        
    }
    
    func loadAgent() {
        
        array_Agent.removeAll()
        let results = ABSQLite.load_Agents()
        for result in results {
            let obj = CCRAgent()
            obj.setData(result)
            array_Agent.append(obj)
        }
        print("CCRManager ### ", "loadAgent()","array_Agent.count ", array_Agent.count  , "CCRManager.shared.array_Agent.count ", CCRManager.shared.array_Agent.count)
    }
    
    func removeAllAgents() {
        ABSQLite.delete(AB_QUERY_DELETE_AGENTS)
    }
    
    func parseCCRData(_ data: Dictionary<AnyHashable, Any>) {
        print("data >>> ",data.count)
        guard let syncCode = data["syncCode"] as? String else {
            print("syncCode error");
            return
        }
        print ("syncCode " , syncCode)
        
        //print ("syncCode " , data[AnyHashable("syncCode")]!)
        
        let results     = CCRParser.parseResults(data)
        let problems    = CCRParser.parseProblems(data)
        let procedures  = CCRParser.parseProcedures(data)
        let vitalSigns  = CCRParser.parseVitalSigns(data)
        let medications = CCRParser.parseMedications(data)
        let payers      = CCRParser.parsePayers(data)
        
        if(syncCode == "insert"){
            for result in results { result.doUpdateQuery() }
            for problem in problems { problem.doUpdateQuery() }
            for procedure in procedures { procedure.doUpdateQuery() }
            for vitalSign in vitalSigns { vitalSign.doUpdateQuery() }
            for medication in medications { medication.doUpdateQuery() }
            for payer in payers { payer.doUpdateQuery() }
        }
        if(syncCode == "delete"){
            for result in results { result.doDeleteQuery()}
            for problem in problems { problem.doDeleteQuery() }
            for procedure in procedures { procedure.doDeleteQuery() }
            for vitalSign in vitalSigns { vitalSign.doDeleteQuery() }
            for medication in medications { medication.doDeleteQuery() }
            for payer in payers { payer.doDeleteQuery() }
        }
    }
    
    func parseAgent(_ dataArray: [[AnyHashable: Any]]) {
        array_Agent.removeAll()
        var i = 0
        for data in dataArray {
            guard let data = data as? [String: Any] else { continue }
            
            let agent = CCRAgent()
            agent.setData(data)
            agent.agentOrder.value = String(i)
            i += 1
            array_Agent.append(agent)
        }
        
        for agent in array_Agent { agent.doUpdateQuery() }
    }
    
    func parseNotification(_ dic: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            let obj = CCRNotification()
            obj.setData(dic)
            obj.doUpdateQuery()
//
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: .receivedNewNotification, object: nil)
//            }
        }
    }
    
    func convertTableForm<T>(_ array: [T]) -> [AnyHashable: [T]] {
        var returnDic: [AnyHashable: [T]] = [:]
        var index = 0
        
        print()
        for object in array {
            let obj = object as! CCRModel
            if (obj as? CCRVitalSign) != nil || (obj as? CCRMedication) != nil || (obj as? CCRResult) != nil {
                let key = (obj[Constants.APIKey.ccrDescription] as! EXProperty<String>).value
                var tempArray = returnDic[key]
                if tempArray == nil {
                    tempArray = []
                }
                
                tempArray!.append(object)
                returnDic.updateValue(tempArray!, forKey: key)
            }
            else {
                let tempArray = [object]
                returnDic.updateValue(tempArray, forKey: String(index))
                index += 1
            }
        }
        
        //        for key in returnDic.keys {
        //            print("key ###", key)
        //            let obj = returnDic[key]
        //            print(obj)
        //        }
        
        return returnDic
    }
    
    // MARK: -
    func getTableForm(dateString: String?) -> [AnyHashable: [Any]] {
        
        print("getTableForm()")
        
        var array: [CCRModel]!
        
        array = array_Result
        
//        switch category {
//        case .Results:
//            array = array_Result
//        case .VitalSigns:
//            array = array_VitalSign
//        case .Medications:
//            array = array_Medication
//        case .Procedures:
//            array = array_Procedures
//        case .Problems:
//            array = array_Problem
//        case .Payers:
//            array = array_Payer
//        default:
//            break
//        }
        
        if array == nil {
            return [:]
        }
        
        if dateString != nil {
            array = getData(with: dateString!, data: array)
//            if(category == .Payers){
//                array = getDataPayer(with: dateString!, data: array)
//            }else{
//                array = getData(with: dateString!, data: array)
//            }
        }
        
        print("array count ", array.count )
        
        // 배열 정렬
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.YearMonthDay
        
        array.sort { (a, b) -> Bool in
            guard let aDateProperty = a["dateTimeValue"] as? EXProperty<String> else { return true }
            guard let bDateProperty = b["dateTimeValue"] as? EXProperty<String> else { return true }
            guard let aDate = formatter.date(from: aDateProperty.value) else { return true }
            guard let bDate = formatter.date(from: bDateProperty.value) else { return true }
            
            if aDate.timeIntervalSince1970 > bDate.timeIntervalSince1970 {
                return true
            }
            else {
                return false
            }
        }
        
        return convertTableForm(array)
    }
    
    func getCalendarForm() -> [AnyHashable:Any] {
        loadAllData()
        var returnDic: [AnyHashable: Any] = [:]
        var tempArray: [[AnyHashable: Any]] = []
        
        // procedure
        for procedure in array_Procedures {
            var dic = procedure.getData()
            for key in dic.keys {
                guard let _ = dic[key] as? String else {
                    dic.removeValue(forKey: key)
                    continue
                }
            }
            tempArray.append(dic as? [String: String] ?? [:])
        }
        returnDic.updateValue(tempArray, forKey: Constants.APIKey.procedures)
        tempArray.removeAll()
        
        // problem
        for problem in array_Problem {
            var dic = problem.getData()
            for key in dic.keys {
                guard let _ = dic[key] as? String else {
                    dic.removeValue(forKey: key)
                    continue
                }
            }
            tempArray.append(dic as? [String: String] ?? [:])
        }
        returnDic.updateValue(tempArray, forKey: Constants.APIKey.problems)
        tempArray.removeAll()
        
        // medications
        for medication in array_Medication {
            var dic = medication.getData()
            for key in dic.keys {
                guard let _ = dic[key] as? String else {
                    dic.removeValue(forKey: key)
                    continue
                }
            }
            tempArray.append(dic as? [String: String] ?? [:])
        }
        returnDic.updateValue(tempArray, forKey: Constants.APIKey.medications)
        tempArray.removeAll()
        
        // payers
        for payer in array_Payer {
            var dic = payer.getData()
            for key in dic.keys {
                guard let _ = dic[key] as? String else {
                    dic.removeValue(forKey: key)
                    continue
                }
            }
            tempArray.append(dic as? [String: String] ?? [:])
        }
        returnDic.updateValue(tempArray, forKey: Constants.APIKey.payers)
        tempArray.removeAll()
        
        // results
        for result in array_Result {
            var dic = result.getData()
            for key in dic.keys {
                guard let _ = dic[key] as? String else {
                    dic.removeValue(forKey: key)
                    continue
                }
            }
            tempArray.append(dic as? [String: String] ?? [:])
        }
        returnDic.updateValue(tempArray, forKey: Constants.APIKey.results)
        tempArray.removeAll()
        
        // vitalsigns
        for vitalsign in array_VitalSign {
            var dic = vitalsign.getData()
            for key in dic.keys {
                guard let _ = dic[key] as? String else {
                    dic.removeValue(forKey: key)
                    continue
                }
            }
            tempArray.append(dic as? [String: String] ?? [:])
        }
        returnDic.updateValue(tempArray, forKey: Constants.APIKey.vitalsigns)
        tempArray.removeAll()
        
        return returnDic
    }
    
    func getLastestObjectInArray(_ array: [CCRModel]) -> CCRModel? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.YearMonthDay
        
        var lastDate = Date(timeIntervalSince1970: 0)
        var lastResult: CCRModel? = nil
        
        if (array.first != nil) {
            lastResult = array.first!
            for obj in array {
                guard let dateTimeValue = obj[Constants.APIKey.dateTimeValue] as? EXProperty<String> else { continue }
                guard let stringDate = dateTimeValue.value else { continue }
                guard let date = formatter.date(from: stringDate) else { continue }
                if date.timeIntervalSince1970 > lastDate.timeIntervalSince1970 {
                    lastDate = date
                    lastResult = obj
                }
            }
        }
        
        return lastResult
    }
    
//    func getSortedCategory() -> [HealthCategory] {
//        let formatter = DateFormatter()
//        formatter.dateFormat = Constants.DateFormat.YearMonthDay
//
//        // get last date objects
//        let lastResult: CCRResult? = getLastestObjectInArray(array_Result) as? CCRResult
//        let lastProblem: CCRProblem? = getLastestObjectInArray(array_Problem) as? CCRProblem
//        let lastVitalSign: CCRVitalSign? = getLastestObjectInArray(array_VitalSign) as? CCRVitalSign
//        let lastMedication: CCRMedication? = getLastestObjectInArray(array_Medication) as? CCRMedication
//        let lastProcedure: CCRProcedure? = getLastestObjectInArray(array_Procedures) as? CCRProcedure
//        let lastPayer: CCRPayer? = getLastestObjectInArray(array_Payer) as? CCRPayer
//
//        // sorting objects
//        var tempArray: [CCRModel] = []
//        if lastResult != nil { tempArray.append(lastResult!) }
//        if lastProblem != nil { tempArray.append(lastProblem!) }
//        if lastVitalSign != nil { tempArray.append(lastVitalSign!) }
//        if lastMedication != nil { tempArray.append(lastMedication!) }
//        if lastProcedure != nil { tempArray.append(lastProcedure!) }
//        if lastPayer != nil { tempArray.append(lastPayer!) }
//
//        var resultArray: [CCRModel] = []
//
//        var ccrModel: CCRModel?
//
//        for originObj in tempArray {
//            if resultArray.firstIndex(of: originObj) != nil { continue }
//            guard let originDateString = originObj[Constants.APIKey.dateTimeValue] as? EXProperty<String> else { continue }
//            if originDateString.value.range(of: "~") != nil {
//                let tempArray = originDateString.value.components(separatedBy: " ~ ")
//                originDateString.value = tempArray.first
//            }
//            guard let originDate = formatter.date(from: originDateString.value) else { continue }
//
//            for compObj in tempArray {
//                if resultArray.firstIndex(of: compObj) != nil { continue }
//                guard let compDateString = compObj[Constants.APIKey.dateTimeValue] as? EXProperty<String> else { continue }
//                if compDateString.value.range(of: "~") != nil {
//                    let tempArray = compDateString.value.components(separatedBy: " ~ ")
//                    compDateString.value = tempArray.first
//                }
//                guard let compDate = formatter.date(from: compDateString.value) else { continue }
//
//                if originDate.timeIntervalSince1970 <= compDate.timeIntervalSince1970 {
//                    ccrModel = compObj
//                }
//            }
//            guard let ccrModel = ccrModel else {
//                continue
//            }
//            resultArray.append(ccrModel)
//        }
//        
//        // add last object
//        for originObj in tempArray {
//            if resultArray.firstIndex(of: originObj) == nil {
//                resultArray.append(originObj)
//            }
//        }
//
//        // make flag array
//        var returnArray: [HealthCategory] = []
//        for obj in resultArray {
//            var flag = HealthCategory.Results
//            if      obj is CCRResult    { flag = .Results }
//            else if obj is CCRProcedure { flag = .Procedures }
//            else if obj is CCRProblem   { flag = .Problems }
//            else if obj is CCRMedication{ flag = .Medications }
//            else if obj is CCRVitalSign { flag = .VitalSigns }
//            else if obj is CCRPayer     { flag = .Payers }
//
//            returnArray.append(flag)
//        }
//
//        return returnArray
//    }
}

