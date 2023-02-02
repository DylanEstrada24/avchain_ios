//
//  Profile.swift
//  avchain
//

import SwiftUI
import IPFSClientKit
import Alamofire
import SwiftyJSON
import SSZipArchive
import Base58Swift

struct Setting: View {
    @State var version = "0.1"
    @State var popupWipe: Bool = false
    @State var date = Date()
    
    func backupData(){
        // 데이터 암호화해쉬 요청 > 암호화 해쉬 > 서버에 base64데이터 전송
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent("AvatarBeans.db")
        let writeDatabaseURL = documentsUrl.appendingPathComponent("AvatarBeans.db.zip")
        
        // call api
        // avatar/backup/init/{avatarID}
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        
        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/backup/init/\(avatarId)", method: .get, encoding: URLEncoding.default, headers:headers)
                        .responseJSON{ (response) in
                            switch response.result {
                            case .success:
                                let json = JSON(response.result.value)
                                guard json["code"].string == "success" else {
                                    //통신은 성공했으나 데이터가져오기 실패인 경우
                                    return
                                }
                                
                                // avatarBackupSeq
                                // encKey
                                // host
                                do{
                                    print(json["data"]["encKey"])
                                    print(json["data"]["avatarBackupSeq"])
                                    print(json["data"]["host"])
                                    
                                    // check db path
//                                    print(finalDatabaseURL.path)
                                    
                                    var splitHost = json["data"]["host"].stringValue.split(separator: "/")
                                    
                                    // ipfs set host
                                    var ipfs = try IPFSClient(host: String(splitHost[1]), port: Int(splitHost[3])!)
                                    
                                    let param = [finalDatabaseURL.path]
                                    
                                    do{
                                        SSZipArchive.createZipFile(atPath: writeDatabaseURL.path, withFilesAtPaths: param, withPassword: json["data"]["encKey"].string)
                                        
                                        do{
                                            // get MerkleNode = ipfsClient.add(file).get(0)
                                            
                                            try ipfs.add(writeDatabaseURL.path) { merkleResult in
                                                print("merclenode", merkleResult)
                                                print("merclenode", merkleResult[0].data)
                                                
                                                // merklenode conver base58  >> filehash
                                                var encodeFileHash = Base58.base58Encode(merkleResult[0].data!)
                                                
                                                // call api
                                                // avatar/backup/update/{avatarID}/V/{avatarBackupSeq}/{fileHash}
                                                Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/backup/update/\(avatarId)/V/\(json["data"]["avatarBackupSeq"].stringValue)/\(encodeFileHash)", method: .get, encoding: URLEncoding.default, headers:headers)
                                                    .responseJSON{ (response) in
                                                        print("print upload response ::",response)
                                                    }
                                            }
                                        }
                                        catch{
                                            print("add err")
                                        }
                                        
                                    }catch{
                                        print("in zip errr")
                                    }
                                    
                                    
                                    // get ipfs obj >> multihash
                                    let multihashRestore = try! fromB58String(json["data"]["fileHash"].stringValue)
                                    
                                    // ipfs set file
                                    // multihash + base 58 >> filecontent
                                    try ipfs.get(multihashRestore, completionHandler: { (result) in
                                        print("result Data",Data(result))
                                        // set .zip data
                                        // filcontent + .zip data
                                        fileManager.createFile(atPath: writeDatabaseURL.path, contents: Data(result))

                                        do{
                                            try SSZipArchive.unzipFile(atPath: writeDatabaseURL.path, toDestination: documentsUrl.path, overwrite: true, password: json["data"]["encKey"].string)
                                        }catch{
                                            print("zip err")
                                        }



                                    })
                                }catch{
                                    print("error parse json")
                                }
                                
                            case .failure(_):
                                print("error...")
                            }
                        }
        }
        
        
        
    }
    
    
    func restoreData(){
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent("AvatarBeans.db")
        let writeDatabaseURL = documentsUrl.appendingPathComponent("AvatarBeans.db.zip")
//        let tempDatabaseURL = documentsUrl.appendingPathComponent("AvatarBeans.db")
        
        // call api
        // avatar/backup/get/{avatarID}
        let avatarId = UserDefaults.standard.string(forKey: "avatarId") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        print("get backup files info")
        
        do {
            Alamofire.request("\(URLAddress.PLATFORM_ADDRESS)/avatar/backup/get/\(avatarId)", method: .get, encoding: URLEncoding.default, headers:headers)
                        .responseJSON{ (response) in
                            switch response.result {
                            case .success:
                                let json = JSON(response.result.value)
                                guard json["code"].string == "success" else {
                                    //통신은 성공했으나 데이터가져오기 실패인 경우
                                    return
                                }
                                
                                do{
                                    print(json["data"]["encKey"])
                                    print(json["data"]["avatarBackupSeq"])
//                                    print(json["data"]["host"])
//                                    print(json["data"]["fileHash"])
                                    
                                    // check db path
//                                    print(finalDatabaseURL.path)
                                    var splitHost = json["data"]["host"].stringValue.split(separator: "/")
                                    
                                    // ipfs set host
                                    var ipfs = try IPFSClient(host: String(splitHost[1]), port: Int(splitHost[3])!)
                                    
                                    // get ipfs obj >> multihash
                                    let multihashRestore = try! fromB58String(json["data"]["fileHash"].stringValue)
                                    
                                    // ipfs set file
                                    // multihash + base 58 >> filecontent
                                    try ipfs.get(multihashRestore, completionHandler: { (result) in
                                        print("result Data",Data(result))
                                        // set .zip data
                                        // filcontent + .zip data
                                        fileManager.createFile(atPath: writeDatabaseURL.path, contents: Data(result))
                                        
                                        do{
                                            try SSZipArchive.unzipFile(atPath: writeDatabaseURL.path, toDestination: documentsUrl.path, overwrite: true, password: json["data"]["encKey"].string)
                                        }
                                        catch{
                                            print("zip err")
                                        }
                                        
                                        
                                        
                                    })
                                }catch{
                                    print("error parse json")
                                }
                                
                                
                            case .failure(_):
                                print("error...")
                            }
                        }
        }
        
        // decrypt file
        // finish
    }
    
    
    var body: some View {
        VStack {
            Header(title: "환경설정")
            VStack(alignment: .leading) {
                
                Group {
                    Text("도움말")
                        .foregroundColor(.gray)
                        .font(.caption)
                    SettingItem(title: "헬스아바타란?", destination: AnyView(HealthAvatar()))
                    SettingItem(title: "앱 사용 가이드", destination: AnyView(GuidePage()))
                }
                EmptyView()
                Group {
                    Text("변경")
                        .foregroundColor(.gray)
                        .font(.caption)
                    SettingItem(title: "비밀번호 변경", destination: AnyView(ChangePW()))
                    HStack(alignment: .center) {
                        Text("알림 메세지 수신 변경")
                            .bold()
                            .foregroundColor(.brown)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.black)
                    }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            guard let url = URL(string: "App-prefs:root=NOTIFICATIONS_ID") else {
                                print(" unvaild url")
                                return }

                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                
                Group {
                    Text("저장된 자료를 백업하거나, 복구 합니다.")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .bold()
                    HStack(alignment: .center) {
                        Text("자료 백업 및 복원")
                            .bold()
                            .foregroundColor(.brown)
                        Spacer()
                        Menu {
                            Button {
                                self.backupData()
                            } label: {
                                Text("데이터 백업 요청")
                            }
                            Button {
                                self.restoreData()
                            } label: {
                                Text("데이터 복구")
                            }
                        } label: {
                            Image("agent_option_icon")
                                .resizable()
                                .frame(width: 10, height: 20)

                        }
//
                    }
                    .padding(.vertical, 5)
                }
                EmptyView()
                Group {
                    Text("정보")
                        .foregroundColor(.gray)
                        .font(.caption)
                    HStack(alignment: .center) {
                        Text("버전 : \(version)")
                            .bold()
                            .foregroundColor(.brown)
                    }
                    .padding(.vertical, 5)
                    HStack(alignment: .center) {
                        Button("팝업/8주 초기화"){
                            ABSQLite.update(POPUP_RESET)
                            
                        }.foregroundColor(.brown)
//
                        Spacer()
                        
                    }
                    .padding(.vertical, 5)
                }
                Spacer()
            }
            .padding(.horizontal)
            Spacer()
        }.navigationBarHidden(true)
    }
}

struct SettingItem: View {
    var title: String
    var destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .center) {
                Text(title)
                    .bold()
                    .foregroundColor(.brown)
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 5)
        }
    }
}

// destination -> 빈 뷰로 이동용
struct emptySpace: View {
    var body: some View {
        Group {
            Text("")
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}

