import SwiftRs
import Tauri
import UIKit
import WebKit


class FullscreenPlugin: Plugin {
    @objc open override func load(webview: WKWebView) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }

        rootVC.edgesForExtendedLayout = .all
        rootVC.extendedLayoutIncludesOpaqueBars = true

        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = .clear
        webview.scrollView.contentInsetAdjustmentBehavior = .automatic
        webview.isUserInteractionEnabled = true

        // Laisser iOS gérer le frame via Auto Layout
        webview.translatesAutoresizingMaskIntoConstraints = false
        rootVC.view.addSubview(webview)
        NSLayoutConstraint.activate([
            webview.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            webview.bottomAnchor.constraint(equalTo: rootVC.view.bottomAnchor),
            webview.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor)
        ])

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
        guard let webview = UIApplication.shared.keyWindow?.subviews.compactMap({ $0 as? WKWebView }).first,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        webview.scrollView.contentInset.bottom = keyboardFrame.height
        webview.scrollView.scrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc func keyboardWillHide(notification: Notification) {
        guard let webview = UIApplication.shared.keyWindow?.subviews.compactMap({ $0 as? WKWebView }).first else { return }
        webview.scrollView.contentInset.bottom = 0
        webview.scrollView.scrollIndicatorInsets.bottom = 0
    }
}

@_cdecl("init_plugin_fullscreen")
func initPlugin() -> Plugin {
  return FullscreenPlugin()
}
