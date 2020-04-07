//
//  FeeReceiptTableViewController.swift
//  eLiteSIS
//
//  Created by Apar256 on 27/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit


struct FeeReceipt {
    
    let ReceiptNo: String!
    let Transaction_Date: String!
    let Amount: String!
    let ReceiptDuration: String!
    let FeePaymentTypen: String!
    
    init(dict:[String:Any]) {
        self.ReceiptNo = dict["ReceiptNo"] as? String
        self.Transaction_Date = dict["Transaction_Date"] as? String
        self.Amount = dict["Amount"] as? String
        self.ReceiptDuration = dict["ReceiptDuration"] as? String
        self.FeePaymentTypen = dict["FeePaymentType"] as? String
    }
}



class FeeReceiptTableViewController: UITableViewController {
    
    var feeReceiptDetails = [FeeReceipt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.tableView.separatorColor = .clear
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        getFeeReceipt()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feeReceiptDetails.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sampleTableViewCell") as! sampleTableViewCell
        cell.dateLabel.text = self.feeReceiptDetails[indexPath.row].Transaction_Date
        cell.title.text = self.feeReceiptDetails[indexPath.row].ReceiptNo
        cell.detailTextView.text = "Paid Rs. " + String(self.feeReceiptDetails[indexPath.row].Amount) + " for " + String(self.feeReceiptDetails[indexPath.row].FeePaymentTypen) + "\n" + "Fee Duration: " + String(self.feeReceiptDetails[indexPath.row].ReceiptDuration)
        return cell
        
    }
    
    func getFeeReceipt() {
        
        ProgressLoader.shared.showLoader(withText: "Loading Fee Receipt Details .....")
        
        WebService.shared.GetFeeReceipt(regID:"", completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.feeReceiptDetails.removeAll()
                if let receiptDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    print(receiptDict)
                    for data in receiptDict {
                        let object = FeeReceipt(dict: data)
                        self.feeReceiptDetails.append(object)
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        Singleton.setUpTableViewDisplay(self.tableView, headerView:"", "sampleTableViewCell")
                    }
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
    
    @IBAction func backButton(_ sender: Any) {
        
        let destViewController  = storyboard?.instantiateViewController(withIdentifier: "more") as! MoreTableViewController
        self.navigationController?.pushViewController(destViewController, animated: false)
    }
    
}
