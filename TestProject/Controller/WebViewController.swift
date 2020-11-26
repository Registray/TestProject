//
//  WebViewController.swift
//  TestProject
//
//  Created by mac on 11/25/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: url!)!))
        
        
    }
    
    
    
}
