import SwiftRs
import Tauri
import UIKit
import WebKit

class FullscreenPlugin: Plugin {
    private var webviewRef: WKWebView?

    @objc open override func load(webview: WKWebView) {
        // On garde la référence
        self.webviewRef = webview

        // Récupération safe du rootViewController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
              let rootVC = keyWindow.rootViewController else { return }

        // Config Fullscreen
        rootVC.edgesForExtendedLayout = .all
        rootVC.extendedLayoutIncludesOpaqueBars = true

        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = .clear
        webview.scrollView.contentInsetAdjustmentBehavior = .automatic
        webview.isUserInteractionEnabled = true

        // Ajout safe du WebView
        if webview.superview == nil {
            rootVC.view.addSubview(webview)
        }

        // Auto Layout pour fullscreen
        webview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webview.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            webview.bottomAnchor.constraint(equalTo: rootVC.view.bottomAnchor),
            webview.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor)
        ])

        // Background window
        keyWindow.backgroundColor = .white
    }
}


@_cdecl("init_plugin_fullscreen")
func initPlugin() -> Plugin {
  return FullscreenPlugin()
}
