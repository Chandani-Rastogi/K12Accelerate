//
//  HomeWorkReportcontroller.swift
//  eLiteSIS
//
//  Created by apar on 24/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
struct HomeWorkReport {
    var FacultyName : String!
    var FacultyID : String!
    init(_ dict:[String:Any]) {
        self.FacultyID = dict["FacultyID"] as? String
        self.FacultyName = dict["FacultyName"] as? String
    }
}

class HomeWorkReportcontroller: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var reportTable: UITableView!
    @IBOutlet weak var datetext: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    var homeworkReport = [HomeWorkReport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.layer.cornerRadius = 8
        self.submitButton.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.submitButton.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.submitButton.isHidden = true
        reportTable.separatorColor = .clear
        reportTable.delegate = nil
        reportTable.dataSource = nil
        self.datetext.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        // Do any additional setup after loading the view.
    }
    @objc func tapDone() {
        
           if let datePicker = self.datetext.inputView as? UIDatePicker {
               datePicker.maximumDate = Date()
               let dateformatter = DateFormatter()
               dateformatter.dateFormat = "MM-dd-yyyy"
               self.datetext.text = dateformatter.string(from: datePicker.date)
           }
          self.datetext.resignFirstResponder()
        if self.datetext.text!.count > 0 {
            self.submitButton.isHidden = false
        }
     
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 50
        
       
      }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.homeworkReport.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         var cell = tableView.dequeueReusableCell(withIdentifier:"Student_AttendanceCell") as! Student_AttendanceCell
        cell.studentName.text = self.homeworkReport[indexPath.row].FacultyName
        cell.presentButton.isHidden = true
        cell.absentbutton.isHidden = true
        cell.leavebutton.isHidden = true
        return cell
        
     }
    
    
    @IBAction func submitButton(_ sender: Any) {
        
        if self.datetext.text!.count > 0 {
            getHomeworkReportAPI()
        }
        else {
            self.datetext.shake()
             self.view.makeToast("Select Date to view Homework Report!!", duration: 1.0, position:.center)
        }
    }
    
    func getHomeworkReportAPI() {
        
        ProgressLoader.shared.showLoader(withText:"Fetching Homework Report ......")
        
        WebService.shared.HomeworkReport(fromDate:self.datetext.text ?? "", completion:{(response, error) in
                 if error == nil , let responseDict = response {
                     if let Dict = responseDict.arrayObject as? [[String:Any]]
                     {
                         self.homeworkReport.removeAll()
                        
                         if Dict.count > 0 {
                            print(Dict)
                             for data in Dict {
                              let obj = HomeWorkReport(data)
                                 self.homeworkReport.append(obj)
                                Singleton.setUpTableViewDisplay(self.reportTable, headerView: "", "Student_AttendanceCell")
                                self.reportTable.delegate = self
                                self.reportTable.dataSource = self
                                self.reportTable.separatorColor = .gray
                                if self.homeworkReport.count > 0 {
                                      ProgressLoader.shared.hideLoader()
                                }
                             
                             }
                         }
                     }
                     else {
                        
                        self.view.makeToast("No Homework Report Found !!", duration: 1.0, position:.center)
                       ProgressLoader.shared.hideLoader()
                     }
                 }else{
                    ProgressLoader.shared.hideLoader()
                     AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                     debugPrint(error?.localizedDescription ?? "Invalid User")
                 }
               
             }
        
        )
        
         }
    
}
