//
//  HtmlViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/5.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import WebKit

class HtmlViewController: SunBaseViewController,WKNavigationDelegate,WKUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let web = WKWebView(frame: self.view.bounds)
        web.navigationDelegate = self
        web.uiDelegate = self
        web.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Untitled-1", ofType: "html")!)))
        self.view.addSubview(web)
        
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("tolink()") { (response, error) in
            print(response,error)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let hostname = navigationAction.request.url?.absoluteString
        UIApplication.shared.openURL(URL(string: "url://"+hostname!
            )!)

    }
//    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
//        let url = navigationResponse.response.URL?.host?.lowercaseString
//        if ((url?.containsString("myapp://")) != nil) {
//            UIApplication.sharedApplication().openURL(navigationResponse.response.URL!)
////            decisionHandler(WKNavigationResponse.cfg)
//        }
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
