//
//  AuthWebViewController.swift
//  Chesha
//
//  Created by tomy on 2016/02/11.
//  Copyright © 2016年 Silva. All rights reserved.
//

import UIKit

class AuthWebViewController: UIViewController, UIWebViewDelegate {
  @IBOutlet weak var webview: UIWebView!
  

  var targetURL = "https://api.croudia.com/oauth/authorize?response_type=code&client_id=1e08645c63f0d5fb1d5df667649cf7f0dcfb633ef6462fad0bf85f0f290166b9&state=tes"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.webview.translatesAutoresizingMaskIntoConstraints = false;
    // Do any additional setup after loading the view, typically from a nib.
    loadAddressURL()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loadAddressURL() {
    let requestURL: NSURL = NSURL(string: targetURL)!
    let req: NSURLRequest = NSURLRequest(URL: requestURL)
    webview.loadRequest(req)
  }

}