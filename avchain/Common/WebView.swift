//
//  WebView.swift
//  avchain
//

import SwiftUI
import WebKit
import StompClientLib

struct WebView: UIViewRepresentable {
    var urlToLoad: String
    var socket = ABSocketManager.shared
    
    //ui view 만들기
    func makeUIView(context: Context) -> WKWebView {
        
        //unwrapping
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        let token: String = UserDefaults.standard.string(forKey: "token")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true // JavaScript가 사용자의 상호작용 없이 새 창을 띄울것인지
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.defaultWebpagePreferences.allowsContentJavaScript=true
        
        //웹뷰 인스턴스 생성
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator    // 웹보기의 탐색 동작을 관리하는 데 사용하는 개체
        webView.allowsBackForwardNavigationGestures = true    // 가로로 스와이프 동작이 페이지 탐색을 앞뒤로 트리거하는지 여부
        webView.scrollView.isScrollEnabled = true    // 웹보기와 관련된 스크롤보기에서 스크롤 가능 여부
        
        
        //웹뷰를 로드한다
        webView.load(request)
        
        //agent띄울때만 ... tempurl[2]에서 d=1인지확인하고 진행
        var urlStr = url.absoluteString
        if (urlStr.contains("https://agents.snubi.org:8443/agents/v1/daily_labs/patient/home_page/main.jsp")) {
            let tempUrl = urlStr.split(separator: "&")
            print(tempUrl)
            let unixObj = tempUrl[8].split(separator: "=")
            let unixKey = unixObj[1]
            
            let encObj = tempUrl[1].split(separator: "=")
            let encKey = encObj[1]
            
            
            socket.connect(unixKey: String(unixKey), encKey: String(encKey))
        }
        return webView
    }
    
    func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage) {

        print("msg",message)
            if (message.name == "callbackHandler") {
                print("JavaScript is sending a message \(message.body)")
            }

    }
    
    
    
    //업데이트 ui view
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        print("when")
        print("is?",socket.socketClient.isConnected())
        socket.subscribe()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        init(parent: WebView) {
            self.parent = parent
        }
    }
}

// 미리보기용
struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(urlToLoad: "https://naver.com")
    }
}

/*
 private var authCookie: HTTPCookie? {
     let cookie = HTTPCookie(properties: [
         .domain: urlToLoad,
         .path: "",
         .name: "CID_AUTH",
         .value: UserDefaults.standard.string(forKey: "token") ?? "",
         .maximumAge: 100000,
         .secure: "TRUE"
     ])
     return cookie
 }
 */
