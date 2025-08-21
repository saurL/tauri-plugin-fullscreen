import SwiftRs
import Tauri
import UIKit
import WebKit
class FullscreenPlugin: Plugin {
    private var webviewRef: WKWebView?

    @objc open override func load(webview: WKWebView) {
     guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        rootVC.edgesForExtendedLayout = .all
        rootVC.extendedLayoutIncludesOpaqueBars = true
        
        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = .clear
        webview.scrollView.contentInsetAdjustmentBehavior = .never
        
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webview.frame = rootVC.view.bounds
        
        UIApplication.shared.keyWindow?.backgroundColor = .white

    }
}



@_cdecl("init_plugin_fullscreen")
func initPlugin() -> Plugin {
  return FullscreenPlugin()
}
