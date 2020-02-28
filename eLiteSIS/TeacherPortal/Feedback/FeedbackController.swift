//
//  FeedbackController.swift
//  eLiteSIS
//
//  Created by apar on 20/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import FSCalendar
import DropDown


struct AllFacultyList {
    
    let FacultyName : String!
    let FacultyID : String!
    let FacultyContactID : String!
    
    init(_ dict:[String:Any]) {
        FacultyName = dict["FacultyName"] as? String
        FacultyID = dict["FacultyID"] as? String
        FacultyContactID = dict["FacultyContactID"] as? String
    }
}

struct FeedBackReport {
    
   let  recordID : String
    let date : String
    let subject : String
    let To : String
    let From : String
    let Message : String
    let regName : String
    let ReplyMsg : String
    let ReplyDate : String
    
    init(_ dict:[String:Any]) {
        
        recordID = dict["recordID"] as? String ?? "NA"
        date = dict["date"] as? String ?? "NA"
        subject = dict["subject"] as? String ?? "NA"
        To = dict["To"] as? String ?? "NA"
        From = dict["From"] as? String ?? "NA"
        Message = dict["Message"] as? String ?? "NA"
        regName = dict["regName"] as? String ?? "NA"
        ReplyMsg = dict["ReplyMsg"] as? String ?? "NA"
        ReplyDate = dict["ReplyDate"] as? String ?? "NA"
    }
}

class FeedbackController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var feedbackTable: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var totext: UITextField!
    @IBOutlet weak var fromText: UITextField!
    
    var facultyList = [AllFacultyList]()
    var feedBackReport = [FeedBackReport]()
    var facultyname : [String] = []
    var facultyID : [String] = []
    var facultyid : String = ""
    
    let FacultyListDropdown =  DropDown()
    lazy var Dropdown: [DropDown] = {
             return [
              
                 self.FacultyListDropdown,
               
             ]
         }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackTable.delegate = nil
        feedbackTable.dataSource = nil
        searchButton.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        searchButton.layer.cornerRadius = 15
        self.selectButton.layer.cornerRadius = 8
        self.selectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.selectButton.layer.borderWidth = 1
        self.feedbackTable.separatorColor = .clear
        self.fromText.setLeftView(image:#imageLiteral(resourceName: "dob"))
        self.totext.setRightView(image:#imageLiteral(resourceName: "dob"))
        getFacultyListAPI()
        self.fromText.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        self.totext.setInputViewDatePicker(target: self, selector: #selector(tapDone2))
        
    }
    
     func setupFacultylistDropDown() {
             
             Singleton.customizeDropDown()
             FacultyListDropdown.anchorView = selectButton
             
             facultyname = (0..<facultyList.count).map { (i) -> String in
                        return facultyList[i].FacultyName
             }
             
             facultyID = (0..<facultyList.count).map { (i) -> String in
             return facultyList[i].FacultyID
                 
             }
             
             FacultyListDropdown.dataSource = facultyname
             FacultyListDropdown.bottomOffset = CGPoint(x: 0, y: selectButton.bounds.height)
             // Action triggered on selection
             FacultyListDropdown.selectionAction = {[weak self](index, item) in
                 self?.selectButton.setTitle("", for: .normal)
                 self?.selectLabel.text = item
                 self?.selectLabel.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
                 self?.selectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
                self?.facultyid =  (self?.facultyID[index])!
          
             }
         }
    
    func getFacultyListAPI() {
      WebService.shared.getallFacultyList(completion:{(response, error) in
               if error == nil , let responseDict = response {
                   if let Dict = responseDict.arrayObject as? [[String:Any]]
                   {
                       self.facultyList.removeAll()
                       if Dict.count > 0 {
                           for data in Dict {
                            let obj = AllFacultyList(data)
                               self.facultyList.append(obj)
                           }
                           self.setupFacultylistDropDown()
                          
                       }
                   }
                   else {
                       
                   }
               }else{
                   AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                   debugPrint(error?.localizedDescription ?? "Invalid User")
               }
               ProgressLoader.shared.hideLoader()
           })
       }
    
    func getfeedbackReport() {
        ProgressLoader.shared.showLoader(withText:"Loading Feedbacks...")
        WebService.shared.FeedbackReport(fromDate:self.fromText.text!, toDate:self.totext.text!, facultyID:self.facultyid, completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let Dict = responseDict.arrayObject as? [[String:Any]]
                {
                    self.facultyList.removeAll()
                    self.feedBackReport.removeAll()
                    if Dict.count > 0 {
                        for data in Dict {
                        let obj = FeedBackReport(data)
                            self.feedBackReport.append(obj)
                            Singleton.setUpTableViewDisplay(self.feedbackTable, headerView: "", "NotificationTableViewCell")
                            self.feedbackTable.delegate = self
                            self.feedbackTable.dataSource = self
                            ProgressLoader.shared.hideLoader()
//                            self.fromText.text = ""
//                            self.totext.text = ""
                            self.facultyid = "0"
                         //   self.selectLabel.text = "Select Teacher"
                            self.FacultyListDropdown.clearSelection()
                            self.facultyList.removeAll()
                            self.getFacultyListAPI()
                        }
                   
                    }
                    else{
                          self.feedBackReport.removeAll()
                        
                        Singleton.setUpTableViewDisplay(self.feedbackTable, headerView: "", "NotificationTableViewCell")
                         self.facultyid = "0"
                        self.feedbackTable.delegate = self
                        self.feedbackTable.dataSource = self
//                        self.fromText.text = ""
//                        self.totext.text = ""
 //                       self.selectLabel.text = "Select Teacher"
                        self.FacultyListDropdown.clearSelection()
                        self.facultyList.removeAll()
                        self.getFacultyListAPI()

                          self.view.makeToast("No Feedbacks Found", duration: 1.0, position:.center)
                       ProgressLoader.shared.hideLoader()
                    }
                }
                else {
                   ProgressLoader.shared.hideLoader()
                }
            }else{
                 ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        } )
    }
    
    
    
    @IBAction func selectButton(_ sender: Any) {
          self.FacultyListDropdown.show()
    
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        if self.selectLabel.text != "Select Teacher" {
            self.getfeedbackReport()
        }
            
        else {
            if fromText.text?.count != 0 {
                if totext.text?.count != 0{
                    self.getfeedbackReport()
                }
                else {
                    totext.shake()
                }
            }
            else {
                fromText.shake()
            }
        }
    }
    
    @objc func tapDone() {
        if let datePicker = self.fromText.inputView as? UIDatePicker {
            datePicker.maximumDate = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM-dd-yyyy"
            self.fromText.text = dateformatter.string(from: datePicker.date)
        }
        self.fromText.resignFirstResponder()
    }
    @objc func tapDone2() {
        if let datePicker = self.totext.inputView as? UIDatePicker {
            datePicker.maximumDate = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM-dd-yyyy"
            self.totext.text = dateformatter.string(from: datePicker.date)
        }
        self.totext.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
    //return 260
    return UITableView.automaticDimension
      
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedBackReport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"NotificationTableViewCell") as! NotificationTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.title.textColor = .darkGray
        cell.title.text = " To : " + self.feedBackReport[indexPath.row].To
        cell.detailTextView.text = "From : " + self.feedBackReport[indexPath.row].From + "\n" + "Date : " + self.feedBackReport[indexPath.row].date + "\n" + "Reg Name : " + self.feedBackReport[indexPath.row].regName + "\n" + "Subject : " + self.feedBackReport[indexPath.row].subject + "\n" + "Message : " + self.feedBackReport[indexPath.row].Message + "\n" + "Reply : " + self.feedBackReport[indexPath.row].ReplyMsg + "\n" + "Reply Date : " + self.feedBackReport[indexPath.row].ReplyDate
        return cell
    }
 
}
