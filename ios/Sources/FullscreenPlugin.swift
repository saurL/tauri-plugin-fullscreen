import SwiftRs
import Tauri
import UIKit
import WebKit


class FullscreenPlugin: Plugin {
    private weak var webviewRef: WKWebView?

    @objc open override func load(webview: WKWebView) {
        self.webviewRef = webview

        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }

        rootVC.edgesForExtendedLayout = .all
        rootVC.extendedLayoutIncludesOpaqueBars = true

        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = .clear
        webview.scrollView.contentInsetAdjustmentBehavior = .automatic
        webview.isUserInteractionEnabled = true
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        UIApplication.shared.keyWindow?.backgroundColor = .white

        // Observers pour le clavier
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let webview = webviewRef,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        webview.scrollView.contentInset.bottom = keyboardFrame.height
        webview.scrollView.scrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc func keyboardWillHide(notification: Notification) {
        guard let webview = webviewRef else { return }
        webview.scrollView.contentInset.bottom = 0
        webview.scrollView.scrollIndicatorInsets.bottom = 0
    }
}

@_cdecl("init_plugin_fullscreen")
func initPlugin() -> Plugin {
  return FullscreenPlugin()
}
