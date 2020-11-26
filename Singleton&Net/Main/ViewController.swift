//
//  ViewController.swift
//  Singleton&Net
//
//  Created by Michael Iliouchkin on 26.11.2020.
//

import UIKit
import Alamofire
import WebKit

class Session {
    let token = "15583ea4ff0862560cc7fa5e038fe65f8c764c51de91bd86e26765ded56eefec8f7a4bb4523212c50d6d4"

}

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let session = Session()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "PARAMETERS", value: "PARAMETERS"),
            URLQueryItem(name: "access_token", value: session.token),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "v", value: "5.126")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        let friendList = params["access_token"]
    
        print(friendList!)
        
        decisionHandler(.cancel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

//https://api.vk.com/method/friends.get?PARAMETERS&access_token=15583ea4ff0862560cc7fa5e038fe65f8c764c51de91bd86e26765ded56eefec8f7a4bb4523212c50d6d4&v=5.126
