//
//  GetAttendanceController.swift
//  eLiteSIS
//
//  Created by apar on 18/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown


struct GetAttendanceList {
    let sectionName : String!
    let PresentCount : String!
    let AbsentCount : String!
    
    init(_ dict:[String:Any]) {
        self.sectionName = dict["sectionName"] as? String
        self.PresentCount = dict["PresentCount"] as? String
        self.AbsentCount = dict["AbsentCount"] as? String
    }
}

class GetAttendanceController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var selectDate: UITextField!
    @IBOutlet weak var attendance: UITableView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var showButton: UIButton!
    var attendanceList = [GetAttendanceList]()
    var getSectionClass = [ClassSection]()
    var filteredSectionClass = [ClassSection]()
    let classDropdown =  DropDown()
    var ClaasID : [String] = []
    var Classname : [String] = []
    var classString : String = ""
    
    lazy var Dropdown: [DropDown] = {
          return [
           
              self.classDropdown,
            
          ]
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attendance.delegate = nil
        self.attendance.dataSource = nil
        self.getclassesAPI()
        self.selectButton.layer.cornerRadius = 8
        self.selectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.selectButton.layer.borderWidth = 1
        
        self.showButton.layer.cornerRadius = 8
        self.showButton.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
     
        
        self.attendance.separatorColor = .clear
        
        self.selectDate.setLeftView(image:#imageLiteral(resourceName: "dob"))
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yyyy"
        //dateformatter.dateStyle = .medium
        self.selectDate.text = dateformatter.string(from:date as Date)
        self.selectDate.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        // Do any additional setup after loading the view.
    }
    
    func setupClasslistDropDown() {
         
         Singleton.customizeDropDown()
         classDropdown.anchorView = selectButton
         
         Classname = (0..<getSectionClass.count).map { (i) -> String in
                    return getSectionClass[i].className
         }
         
         ClaasID = (0..<getSectionClass.count).map { (i) -> String in
         return getSectionClass[i].classId
             
         }
         
         classDropdown.dataSource = Classname
         classDropdown.bottomOffset = CGPoint(x: 0, y: selectButton.bounds.height)
         // Action triggered on selection
         classDropdown.selectionAction = {[weak self](index, item) in
             self?.selectButton.setTitle("", for: .normal)
             self?.selectLabel.text = item
             self?.selectLabel.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
             self?.selectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self?.classString = (self?.ClaasID[index])!
         }
     }
    
    func getclassesAPI() {
   WebService.shared.GetAllClassSection(registrationValue:UserDefaults.standard.value(forKey:"_sis_registration_value") as? String ?? "", completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let classDict = responseDict["Classes"].arrayObject as? [[String:Any]]
                {
                    self.getSectionClass.removeAll()
                    if classDict.count > 0 {
                        for data in classDict {
                            let obj = ClassSection(fromDictionary: data)
                            self.getSectionClass.append(obj)
                        }
                        self.setupClasslistDropDown()
                       
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
    func getAttendanceAPI(classID:String) {
        ProgressLoader.shared.showLoader(withText:"Fetching Attendance List .....")
        WebService.shared.GetAttendanceforPrincipal(classID:classID,AttendanceDate: self.selectDate.text!, completion:{(response, error) in
               if error == nil , let responseDict = response {
                   if let attendanceDict = responseDict["AttendanceList"].arrayObject as? [[String:Any]]
                   {
                    self.attendanceList.removeAll()
                    if attendanceDict.count > 0 {
                        for data in attendanceDict {
                            let obj = GetAttendanceList(data)
                            self.attendanceList.append(obj)
                        }
                        Singleton.setUpTableViewDisplay(self.attendance, headerView:"", "TeacherDashboardTableViewCell")
                        self.attendance.delegate = self
                        self.attendance.dataSource = self
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
           })
       }
    
    
    
    @IBAction func selectButton(_ sender: Any) {
       self.classDropdown.show()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 130
           
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.attendanceList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           var cell = tableView.dequeueReusableCell(withIdentifier: "TeacherDashboardTableViewCell") as? TeacherDashboardTableViewCell
           
           cell?.subjectProgressBar1.maxValue = CGFloat(Double(self.attendanceList[indexPath.row].AbsentCount)!) + CGFloat(Double(self.attendanceList[indexPath.row].PresentCount)!)
           
           cell?.subjectProgressBar2.maxValue = CGFloat(Double(self.attendanceList[indexPath.row].AbsentCount)!) + CGFloat(Double(self.attendanceList[indexPath.row].PresentCount)!)
           
           cell?.subjectProgressBar1?.progressStrokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
           cell?.subjectProgressBar1?.progressColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
           UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
               self.view.layoutIfNeeded()
               
               cell?.subjectProgressBar1?.value = CGFloat(Double(self.attendanceList[indexPath.row].PresentCount)!)
               
           }, completion: { finished in
           })
           
           cell?.subjectProgressBar2?.progressStrokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
           cell?.subjectProgressBar2?.progressColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
           UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
               self.view.layoutIfNeeded()
               cell?.subjectProgressBar2?.value = CGFloat(Double(self.attendanceList[indexPath.row].AbsentCount)!)
               
           }, completion: { finished in
           })
           cell?.subjectLabel.text = attendanceList[indexPath.row].sectionName
           cell?.subject1percentage.text = String(self.attendanceList[indexPath.row].PresentCount)
           cell?.subject2Percentage.text = String(self.attendanceList[indexPath.row].AbsentCount)
           cell!.selectionStyle = .none
           return cell!
       }
    
    @objc func tapDone() {
          if let datePicker = self.selectDate.inputView as? UIDatePicker {
              datePicker.maximumDate = Date()
              let dateformatter = DateFormatter()
              dateformatter.dateFormat = "MM-dd-yyyy"
              //dateformatter.dateStyle = .medium
              self.selectDate.text = dateformatter.string(from: datePicker.date)
          }
          self.selectDate.resignFirstResponder()
      }
    
    @IBAction func showButton(_ sender: Any) {
        if self.selectLabel.text != "Select Class *" {
           self.getAttendanceAPI(classID:classString)
        }
        else{
            self.selectButton.shake()
        }
     
    }
    
    
}
