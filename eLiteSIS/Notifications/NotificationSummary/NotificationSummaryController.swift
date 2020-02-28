//
//  NotificationSummaryController.swift
//  eLiteSIS
//
//  Created by Apar256 on 24/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit


class NotificationSummaryController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    struct Summary {
        let status : String!
        let count : Int!
        
        init(fromDictionary dictionary: [String:Any]) {
            self.status = dictionary["status"] as? String
            self.count = dictionary["count"] as? Int
          
        }
    }
    
    
    @IBOutlet weak var searchBodyTF: UITextField!
    @IBOutlet weak var notificationlist: UITableView!
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    
    var countArray = [Int]()
    var summaryList = [Summary]()
    var sum : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationlist.delegate = nil
        notificationlist.dataSource = nil
        self.notificationlist.separatorColor = .clear // Do any additional setup after loading the view.
        self.fromDateTF.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        self.toDateTF.setInputViewDatePicker(target: self, selector: #selector(tapDone2))
    }
    
    @objc func tapDone() {
          if let datePicker = self.fromDateTF.inputView as? UIDatePicker {
              //datePicker.maximumDate = Date()
              let dateformatter = DateFormatter()
              dateformatter.dateFormat = "MM-dd-yyyy"
              self.fromDateTF.text = dateformatter.string(from: datePicker.date)
          }
          self.fromDateTF.resignFirstResponder()
      }
      @objc func tapDone2() {
          if let datePicker = self.toDateTF.inputView as? UIDatePicker {
             // datePicker.maximumDate = Date()
              let dateformatter = DateFormatter()
              dateformatter.dateFormat = "MM-dd-yyyy"
              self.toDateTF.text = dateformatter.string(from: datePicker.date)
          }
          self.toDateTF.resignFirstResponder()
      }
    

    
    @IBAction func showButton(_ sender: Any) {
        getAllNotification()
        
    }
    @IBAction func clearButton(_ sender: Any) {
        self.fromDateTF.text?.removeAll()
        self.toDateTF.text?.removeAll()
        self.searchBodyTF.text?.removeAll()
    }
    
    func getAllNotification() {
        
        ProgressLoader.shared.showLoader(withText:"Loading Notification Summary...")
        WebService.shared.postNotificationSummary(fromDate: fromDateTF.text!, toDate: toDateTF.text!, description:searchBodyTF.text!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                //print(responseDict)
                self.countArray.removeAll()
                self.summaryList.removeAll()
                if responseDict.count > 0 {
                    if let resultDict = responseDict["result"].arrayObject as? [[String:Any]]{
                        for data in resultDict {
                            let obj = Summary(fromDictionary:data)
                            self.summaryList.append(obj)
                            self.countArray.append(obj.count)
                            
                            self.notificationlist.delegate = self
                            self.notificationlist.dataSource = self
                            
                            Singleton.setUpTableViewDisplay(self.notificationlist, headerView:"SummaryView", "NotificationSummaryCell")
                        }
                    }
                    else {
                        self.view.makeToast("No Notificatiuon Summary to show",duration: 1.0 , position : .bottom)
                    }
                }
            }else{
                ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SummaryView") as! SummaryView
        viewHeader.titleLabel.text = "Total Notification Attempted"
        let total = countArray.reduce(0, +)
        viewHeader.countLabel.text = String(total)
           return viewHeader
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.summaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"NotificationSummaryCell") as! NotificationSummaryCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.titleLabel.text = self.summaryList[indexPath.row].status
        cell.totalCountLabel.text = String(self.summaryList[indexPath.row].count)
        return cell
        
    }
}
