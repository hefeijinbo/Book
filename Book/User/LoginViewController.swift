//
//  LoginViewController.swift
//  Book
//
//  Created by 金波 on 16/1/14.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import UITools

class LoginViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: NetManager.OAuthLogin.URLStringGetCode)!))
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType:UIWebViewNavigationType) -> Bool {
        if let URLString = request.URL?.absoluteString {
            print("shouldStartLoadWithRequest:" + URLString)
            if URLString.hasPrefix(NetManager.OAuthLogin.redirect_uri) {
                if let range = URLString.rangeOfString("?code=") {
                    let code = URLString.substringFromIndex(range.endIndex)
                    HUD.showLoading("登录中...")
                    NetManager.OAuthLogin.loginWithCode(code, resultClosure: { (result) -> Void in
                        HUD.hideLoading()
                        if result {
                            Toast.showToast("登陆成功")
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                } else if let _ = URLString.rangeOfString("?error=") {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                return false
            }
        }
        return true
    }

}
