//
//  WebViewController.swift
//  eLiteSIS
//
//  Created by Apar256 on 26/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    var totalAmount : Int = 0
    var payerName : String = ""
    var email : String = ""
    var mobile : String = ""
    
    var instituteID : String = ""
    var transactionType: String = ""
    var UPPMID : String = ""
    var PayerGUID : String = ""
    var responseURL : String = ""
    var fromBasicFee = Bool()
    
    
    @IBOutlet weak var webView: WKWebView!
     var urlString : String = ""
    
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        print(responseURL)
        
        
        urlString = "http://demo.eupp.in/PaymentGatewayPage?PayerGUID=\(self.PayerGUID)&PayerName=\(self.payerName)&PayerEmail=\(self.email)&PayerPhone=\(self.mobile)&PayerTotalAmount=\(String(self.totalAmount)).00&InstituteUniqueID=\(instituteID)&TransactionType=\(self.transactionType)&UPPMID=\(self.UPPMID)&ResponseURL=\(responseURL)"
        
         loadWebview()
        // Do any additional setup after loading the view.
    }
    
    func loadWebview() {
        
        let url : NSString = urlString as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        print(searchURL)

        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        webView.configuration.preferences = preferences
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(URLRequest(url: searchURL as URL))
        self.view.addSubview(webView)
    }
    
   func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // print("Strat to load")

        if let url = webView.url?.absoluteString{
           // print("didStartProvisionalNavigation url = \(url)")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("finish to load")

        if let url = webView.url?.absoluteString{
           // print("didFinish url = \(url)")
            if url == "https://demo.eupp.in/ExternalUserReceipt?PayerId=&UPPTransactionId=&TransactionStatus=Success" {
                
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as? TabBarViewController
                {
                    vc.selectedIndex = 4
                    vc.fromWebView = true
                    vc.modalPresentationStyle = .fullScreen
                    UserDefaults.standard.set(true, forKey: "fromWebView")
                    self.present(vc, animated: true, completion: nil)
                    
                    }
                }
                
            }
        }
    }
 
