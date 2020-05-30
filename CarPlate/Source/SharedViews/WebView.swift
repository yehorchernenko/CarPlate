//
//  WebView.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 29.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    enum Script {
        case atStart(script: String)
        case atEnd(script: String)
    }
    let request: URLRequest
    let scripts: [Script]

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: context.coordinator.config)
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(scripts: scripts)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let scripts: [Script]

        init(scripts: [Script]) {
            self.scripts = scripts
            super.init()
        }

        lazy var  contentController: WKUserContentController = {
            let controller = WKUserContentController()
            scripts.forEach {
                switch $0 {
                case .atStart(let script):
                    controller.addUserScript(WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false))

                case .atEnd(let script):
                    controller.addUserScript(WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
                }
            }
            return controller
        }()

        lazy var config: WKWebViewConfiguration = {
            let config = WKWebViewConfiguration()
            config.userContentController = contentController
            config.preferences.javaScriptEnabled = true
            return config
        }()
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://policy-web.mtsbu.ua")!), scripts: [])
    }
}
