//
//  PayDetailController.swift
//  eLiteSIS
//
//  Created by Apar256 on 26/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit
import BottomPopup

class PayDetailController: BottomPopupViewController,UITableViewDelegate,UITableViewDataSource {
   
    var item = [FeeItemPaymentDetailslist]()
    
    var countArray = [Int]()
    var total : Int = 0
    var fromMonth :String = ""
    var toMonth : String = ""
    
   
    @IBOutlet weak var totalAmt: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        for data in item {
        self.countArray.append(data.totalBcF)
        }
        
        Singleton.setUpTableViewDisplay(itemTableView, headerView:"","PayDetailCell" )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return item.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PayDetailCell") as! PayDetailCell
        cell.selectionStyle = .none
        cell.itemName.text =  item[indexPath.row].feeItemName
        cell.amount.text = String(item[indexPath.row].totalBcF)
        total = countArray.reduce(0, +)
        totalAmt.text = String(total)
        return cell
        
    }
    
    
    @IBAction func payNowButton(_ sender: Any) {
        
        
        self.getFeeReceiptDetail(from:fromMonth, to: toMonth, paymentID:"")

//
    }
    
    func getFeeReceiptDetail(from:String,to:String,paymentID:String) {
        
        ProgressLoader.shared.showLoader(withText: "Forwarding to Payment Gateway .....")
        WebService.shared.GetFeeDetailForUppPayment(regID:"", fromMonth: from, toMonth: to, paymentID: paymentID, amount:String(total),completion:{(response, error) in
            if error == nil , let responseDict = response {
                print("response ***********\(response)")
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as? WebViewController
                {
                     vc.email = responseDict["PayerEmail"].stringValue
                                      vc.mobile = responseDict["PayerPhone"].stringValue
                                      vc.payerName = responseDict["PayerName"].stringValue
                                      vc.instituteID = responseDict["InstituteUniqueID"].stringValue
                                      vc.PayerGUID = responseDict["PayerGUID"].stringValue
                                      vc.UPPMID = responseDict["eUPPMMID"].stringValue
                                      vc.transactionType = responseDict["TransactionType"].stringValue
                                      vc.totalAmount = self.total
                                      vc.modalPresentationStyle = .fullScreen
                                      self.present(vc, animated: true, completion: nil)
                }
                
                ProgressLoader.shared.hideLoader()
            }
            else{
                ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
}
