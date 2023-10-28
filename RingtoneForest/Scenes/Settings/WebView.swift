//
//  WebView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 26/10/2023.
//

import SwiftUI
import WebKit

enum WebType: String, Identifiable {
    var id: RawValue { rawValue }
    
    case term = "https://sites.google.com/view/team-tonemakerwallpaper"
    case privacy = "https://sites.google.com/view/prima-tonemakerwallpaper"
    case support = "https://sites.google.com/view/spop-tonemakerwallpaper"
}

struct WebView: UIViewControllerRepresentable {
    let type: WebType
    
    init(type: WebType) {
        self.type = type
    }
    
    func makeUIViewController(context: Context) -> WebViewController {
        WebViewController(type: type)
    }
    
    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        
    }
}

class WebViewController: UIViewController {
    var type: WebType!
    
    convenience init(type: WebType!) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let urlString = type.rawValue
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else {
            print("Wrong url path")
        }
    }
}
