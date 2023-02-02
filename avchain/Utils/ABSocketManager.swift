//
//  SocketUtil.swift
//

import Foundation
import StompClientLib
import Alamofire
import SwiftyJSON

let SOCKET_DEBUG = true

struct CCR: Codable {
    let id: String
    let deviceType: String
    let ccrData: String
}

/// for socket debug
fileprivate func socketPrint(_ string: String) {
    if SOCKET_DEBUG {
        print("########## [socket] " + string)
    }
}

//델리게이트 수정필요
@objc protocol ABSocketDelegate {
    @objc optional func socketDidConnect()
    @objc optional func socketDidDisconnect()
    @objc optional func socketDidReceivedJSONBody(_ jsonBody: AnyObject?, header: [String: String], destination: String?)
    @objc optional func socketDidReceivedRecipt(_ receipID: String)
    @objc optional func socketReceivedError(_ description: String, error: String)
}

class ABSocketManager: NSObject, StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        // do something
        socketPrint("jsonBody \(jsonBody)")
        socketPrint("stringBody \(stringBody)")
        socketPrint("destination \(destination)")
        
        guard let body = jsonBody as? [AnyHashable: Any] else { return }
        print("bbbody" , body)
        guard let dic = body[Constants.Keys.data] as? [AnyHashable: Any] else { return }
        guard let tableName = dic[Constants.Keys.table] as? String else { return }
        let queryString = ABSocketDataParser.getQueryString(dic)
        //빈값 => queryString
        let tempccr = ABSQLite.doQuery(queryString)
        
        //ccr공백값일 경우 빈 배열 하드코딩 반환
        let ccr = ABSocketDataParser.prepareSocketDictionary(tempccr, tableName: tableName)
        print("socket tablename", tableName)
        var jsonStringCcr = ""
        
        //일요일 데이터 넣고 확인해보자.
        
        if ccr.isEmpty {
            if(tableName == "Results"){
                jsonStringCcr = "{\"results\":[{\"\":[],\"phrId\":[],\"description\":[],\"type\":[],\"testResultValue\":[],\"averageResultValue\":[],\"testResultUnit\":[],\"dateTimeType\":[],\"dateTimeValue\":[],\"actorID\":[],\"actorRole\":[],\"initialUpdate\":[],\"lastUpdate\":[],\"flag\":[],\"objectID\":[],\"codeValue\":[],\"codeCodingSystem\":[],\"hashSeq\":[]}],\"hashSeq\":[]}"
            }
            
            if(tableName == "VitalSigns"){
                jsonStringCcr = "{\"vitalsigns\":[{\"\":[],\"phrId\":[],\"description\":[],\"type\":[],\"testResultValue\":[],\"testResultUnit\":[],\"dateTimeType\":[],\"dateTimeValue\":[],\"actorID\":[],\"actorRole\":[],\"initialUpdate\":[],\"lastUpdate\":[],\"flag\":[],\"objectID\":[],\"codeValue\":[],\"codeCodingSystem\":[],\"hashSeq\":[]}],\"hashSeq\":[]}"
            }
            
        } else {
            
            let ccrData = ABSocketDataParser.createCCRData(ccr, tableName: tableName)
            jsonStringCcr = ABSocketDataParser.parseDicToJSONString(ccrData)
        }
        
        
        //여기서 정제된 ccr데이터를 api호출한다.
        let dob = CCR(id: self.encKey, deviceType : Constants.APIValue.avatar, ccrData: jsonStringCcr)
        if let dobdata = try? JSONEncoder().encode(dob) {
            if let json = String(data: dobdata, encoding: .utf8) {
                //let header = ["content-type":"application/json;charset=UTF-8"]
                var path = self.sendMessagePath.replacingOccurrences(of: self.placeholder_UserID, with: UserDefaults.standard.string(forKey: "avatarId") ?? "")
                path = URLAddress.PLATFORM_ADDRESS + path.replacingOccurrences(of: self.placeholder_agentWSId, with: self.uniqueKey)

                
                
                let jwtToken = UserDefaults.standard.string(forKey: "token") ?? ""
                let headers: HTTPHeaders = [
                            "Authorization": "Bearer \(jwtToken)",
                            "Content-Type":"application/json"
                ]
                
                
                let parameters = [
                    "id":dob.id,
                    "deviceType": dob.deviceType,
                    "ccrData": dob.ccrData
                        
                ]
                
                print("pm ...",parameters)
                
                Alamofire.request(path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                        .validate(statusCode: 200..<600)
                        .responseJSON { response in

                            print(response)
                            print("is alive?",self.socketClient.isConnected())

                    }
//                socketClient.sendMessage(message: json, toDestination: path, withHeaders: nil, withReceipt: nil)
                
//                self.disconnect()
            }
        }
    }

    static var shared = ABSocketManager()

    var delegate: ABSocketDelegate?

    /// for singleton network connection handle
    var connectingCount = 0
    var socketClient = StompClientLib()
    let urlString               = URLAddress.PLATFORM_ADDRESS + "/platform-websocket/websocket"
    let subscribePath           = "/user/[User_ID]/[agentWSId]/reply"           // WSID는 timestamp임.
    let sendMessagePath         = "/connection3/[User_ID]/[agentWSId]"
    let placeholder_UserID      = "[User_ID]"
    let placeholder_agentWSId   = "[agentWSId]"
    var token                   = ""
    var uniqueKey               = ""
    var encKey                  = ""

    public func connect(unixKey: String, encKey: String) {
        self.uniqueKey = unixKey
        self.encKey = encKey
        let url = URL(string: urlString)!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url), delegate: self,connectionHeaders: ["heart-beat": "0,1000"])
        
    }
    
    public func subscribe(){
        
        socketPrint("call sub")
        
        let url = URL(string: urlString)!
        var path = subscribePath.replacingOccurrences(of: placeholder_UserID, with: UserDefaults.standard.string(forKey: "avatarId") ?? "")
        path = path.replacingOccurrences(of: placeholder_agentWSId, with: self.uniqueKey)
        socketPrint("call \(url)")
        socketPrint("destination path : \(path)")
        
        if(socketClient != nil && socketClient.isConnected()) {
            socketPrint("topic on")
            socketClient.subscribe(destination: path)
        }
        
    }

    public func disconnect() {
        socketClient.disconnect()
    }

    public func sendMessage(_ message: [AnyHashable: Any]) {
        socketClient.sendJSONForDict(dict: message as AnyObject, toDestination: "")
    }


    // MAKR: - STOMP Socket Delegate StompClientLibDelegate
    func stompClientDidConnect(client: StompClientLib!) {
        var path = subscribePath.replacingOccurrences(of: placeholder_UserID, with: UserDefaults.standard.string(forKey: "avatarId") ?? "")
        path = path.replacingOccurrences(of: placeholder_agentWSId, with: self.uniqueKey)
        socketPrint("Socket is Connected : \(path)")
        
        subscribe()
        
    }

    func stompClientDidDisconnect(client: StompClientLib!) {
        socketPrint("socket disconnect !!!!")
        connectingCount = 0
        //reconnect
        subscribe()
    }

    func stompClientWillDisconnect(client: StompClientLib!, withError error: NSError) {
        socketPrint("Socket will is Disconnected")
    }
//
//    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, withHeader header: [String : String]?, withDestination destination: String) {
//        socketPrint("<<< 에이전트요청쿼리 : \(destination)")
//        socketPrint("JSON BODY 1 : \(String(describing: jsonBody))")
//
//        //prepare jsonBody
//        //Constants -> 값 변경 필요
//        DispatchQueue.main.async {
//            guard let body = jsonBody as? [AnyHashable: Any] else { return }
//            print("bbbody" , body)
//            guard let dic = body[Constants.Keys.data] as? [AnyHashable: Any] else { return }
//            guard let tableName = dic[Constants.Keys.table] as? String else { return }
//            let queryString = ABSocketDataParser.getQueryString(dic)
//            let tempccr = ABSQLite.doQuery(queryString)
//            let ccr = ABSocketDataParser.prepareSocketDictionary(tempccr, tableName: tableName)
//            let ccrData = ABSocketDataParser.createCCRData(ccr, tableName: tableName)
//            let jsonStringCcr = ABSocketDataParser.parseDicToJSONString(ccrData)
//
//
//
////            //여기서 정제된 ccr데이터를 api호출한다.
////            //sendCCR인데, 이 결과로 무언가 기능을 하는것은 아닌것으로 보임.
////            //url >>> /connection3/{avatarId}/{agentWSId} // agentWSId == uniquekey
////            let dob = CCR(id: self.token, deviceType : Constants.APIValue.avatar, ccrData: jsonStringCcr)
////            if let dobdata = try? JSONEncoder().encode(dob) {
////                if let json = String(data: dobdata, encoding: .utf8) {
////                    //let header = ["content-type":"application/json;charset=UTF-8"]
////                    var path = self.sendMessagePath.replacingOccurrences(of: self.placeholder_UserID, with: UserInfo.shared.avatarId ?? "")
//////                    path = URL_HOST + ":" + URL_PORT + path.replacingOccurrences(of: self.placeholder_agentWSId, with: self.uniqueKey)
////
////                    print(">>> 소켓전송 JSON : \(json)" , path)
//////                    EXNetworkFunc.sendCCR(message: json, toDestination: path,  handler: self.handler_SendCCR(response:))
////                    //self.disconnect()
////                }
////            }
//        }
//    }
//    func handler_SendCCR(response: EXResponse) {
//    }

    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        socketPrint("DESTIONATION : \(destination)")
        //socketPrint("String JSON BODY : \(String(describing: jsonBody))")
    }

    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        socketPrint("Receipt : \(receiptId)")
    }

    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        socketPrint("Error : \(String(describing: message))")
    }

    func serverDidSendPing() {
        socketPrint("Server Ping")
    }
    

}

