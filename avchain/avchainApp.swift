//
//  avchainApp.swift
//  avchain
//

import SwiftUI
import UserNotifications
import Alamofire
import SwiftyJSON
import FirebaseCore
import FirebaseMessaging

@main
struct avchainApp: App {
    
    
    
    //푸시알림 델리게이트
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var settings = UserSettings()
    
    var body: some Scene {
        
        WindowGroup {
            ZStack {
//                ContentView()
                AppSwitcher()
//                GeometryReader { reader in
//                    Color.yellow // safearea 컬러
//                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
//                        .ignoresSafeArea()
//                }
                    .environmentObject(settings)
            }
        }
    }
}


struct AppSwitcher: View {
    @EnvironmentObject var settings: UserSettings
    
    func isInstallPHR(){
        //PHR앱 설치여부 ... appscheme확인 필요
        print("is install sub app")
        var appPath = NSURL(string:"phr://")! // 임시 scheme ... 정확히 알아내야 함

        if UIApplication.shared.canOpenURL(appPath as URL){
            UserDefaults.standard.setValue("true", forKey: "isPHR")
        } else{
            UserDefaults.standard.setValue("false", forKey: "isPHR")
        }
        
        var appPathOnePass = NSURL(string:"onePass://")! // 임시 scheme ... 정확히 알아내야 함

        if UIApplication.shared.canOpenURL(appPathOnePass as URL){
            UserDefaults.standard.setValue("true", forKey: "isOnePass")
        } else{
            UserDefaults.standard.setValue("false", forKey: "isOnePass")
        }
    }
    
    
    // 알림 권한 요청
    func checkGranted(){
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("Error : \(error.localizedDescription)")
                }

                if granted {
                    // 노티피케이션 승인
                    UserDefaults.standard.set(true, forKey: "notiAgree")
                    print("알림 승인")
                }
                else {
                    // 노티피케이션 거부
                    UserDefaults.standard.set(false, forKey: "notiAgree")
                    print("알림 거부")
                }
        }
    }
    
    
    //실질적 스플래시
    init(){
        self.isInstallPHR()
        self.checkGranted()
        
    }
    
    var isAuto = UserDefaults.standard.string(forKey: "autoLogin") ?? "0"
    
    var body: some View {
        
        if (isAuto == "1") {
            var _ = print("자동로그인 진행", isAuto)
            Main()
                .onOpenURL(){url in
                    print("url", url)
                    if (url.absoluteString.contains(".pdf")){
                        do {
                            let data = try Data(contentsOf: url)
                            let fileName = url.lastPathComponent
                            print(data) // 10899227 bytes
                            Alamofire.upload(multipartFormData: { multipartFormData in
                                multipartFormData.append(url, withName: "file", fileName: fileName, mimeType:"application/pdf")
                            }, to: "\(URLAddress.PLATFORM_ADDRESS)/BigData/upload/myhealthway/\(UserDefaults.standard.string(forKey: "avatarId")!)", encodingCompletion: { (result) in
                                
                                print(result)
                                
                            })
                        } catch {
                            print(error)
                        }
                    }
                }
        } else {
            if (settings.isLogin) {
                Main()
                    .onOpenURL(){url in
                        print("url", url)
                        if (url.absoluteString.contains(".pdf")){
                            do {
                                let data = try Data(contentsOf: url)
                                let fileName = url.lastPathComponent
                                print(data) // 10899227 bytes
                                Alamofire.upload(multipartFormData: { multipartFormData in
                                    multipartFormData.append(url, withName: "file", fileName: fileName, mimeType:"application/pdf")
                                }, to: "\(URLAddress.PLATFORM_ADDRESS)/BigData/upload/myhealthway/\(UserDefaults.standard.string(forKey: "avatarId")!)", encodingCompletion: { (result) in
                                    
                                    print(result)
                                    
                                })
                            } catch {
                                print(error)
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
        
    }
}




// 토큰획득시 알아서 로그남기는 레거시

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // init
        FirebaseApp.configure()

        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        // 메세징 델리게이트
        Messaging.messaging().delegate = self

        // 푸시 포그라운드 설정
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        UserDefaults.standard.setValue(deviceToken, forKey: "deviceToken")
    }

}

extension AppDelegate : MessagingDelegate {

    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken Received")
        print("Firebase registration token: \(String(describing: fcmToken))")
        //여기서 userDefaults입력
    }
}


//푸시 핸들링
extension AppDelegate : UNUserNotificationCenterDelegate {

    // 포그라운드 푸시 리시버
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        print("willPresent: userInfo: ", userInfo)
        
        
        ABSQLite.insert("INSERT INTO main.Notification (Phr_Id, User_Id, Message, Read_Flag, Initial_Update, Last_Update) VALUES (0, \(UserDefaults.standard.string(forKey: "avatarId") ?? ""), \(notification.request.content.body), T, \(KoreanDate.dbDateFormat.string(from: Date())), \(KoreanDate.dbDateFormat.string(from: Date()))")
        
        

        completionHandler([.banner, .sound, .badge])
    }

    // 백그라운드 푸시 리시버
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo)
        
        ABSQLite.insert("INSERT INTO main.Notification (Phr_Id, User_Id, Message, Read_Flag, Initial_Update, Last_Update) VALUES (0, \(UserDefaults.standard.string(forKey: "avatarId") ?? ""), \(response.notification.request.content.body), T, \(KoreanDate.dbDateFormat.string(from: Date())), \(KoreanDate.dbDateFormat.string(from: Date()))")

        completionHandler()
    }

}

