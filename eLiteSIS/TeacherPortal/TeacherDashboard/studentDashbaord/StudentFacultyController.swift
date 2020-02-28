//
//  StudentFacultyController.swift
//  eLiteSIS
//
//  Created by apar on 27/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData


class StudentFacultyController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    @IBOutlet weak var allAssignment: UILabel!
    @IBOutlet weak var dueAssignment: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var studentClass: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dashboardTable: UITableView!
    @IBOutlet weak var viewButton: UIButton!
  
    var dashbaoardData = [Dashboard]()
    var studentID : String = ""
    var classSession : String = ""
    var regId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewButton.layer.cornerRadius = viewButton.bounds.height / 2
        viewButton.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width/2.0
        profileImage.clipsToBounds = true
        dashboardTable.delegate = nil
        dashboardTable.dataSource = nil
        dashboardTable.separatorColor = .clear
        self.getProfileData()
        self.fetchDashBoardData()
        // Do any additional setup after loading the view.
    }
    
    func fetchProfileDetails() {
        
        CoreDataController.sharedInstance.fetchProfileDataRequest(regID:regId, completion:{(response, error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    for data in itemsJsonArray! {
                      //  self.profileDict  = (data as? [String:Any])!
                      
                    }
                }
            }
        })
    }
    
    @IBAction func assignmentButton(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assignment") as? AssignmentTableViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 305
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashbaoardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "dashboardTableViewCell") as? dashboardTableViewCell
        
        let due = dashbaoardData[indexPath.row].new_totalassignments - dashbaoardData[indexPath.row].new_completedassignments
     
        studentName.text = dashbaoardData[indexPath.row].sis_name
        namelabel.text = dashbaoardData[indexPath.row].sis_name
        allAssignment.text = String(Int(dashbaoardData[indexPath.row].new_totalassignments))
        dueAssignment.text = String(Int(due))
        
        if let imgData = UserDefaults.standard.data(forKey:"entityimage") {
            profileImage.image = UIImage(data: imgData)
        }
        if let studentschool =  UserDefaults.standard.value(forKey:"new_program"){
            studentClass.text =  "\(studentschool)"
        }
        cell?.Button1.addTarget(self, action: #selector(studyProgess), for: .touchUpInside)
        cell?.Button1.tag = indexPath.row
        
        cell?.Button2.addTarget(self, action: #selector(attendance), for: .touchUpInside)
        cell?.Button2.tag = indexPath.row
        
        cell?.button3.addTarget(self, action: #selector(overAll), for: .touchUpInside)
        cell?.button3.tag = indexPath.row
        
        cell?.title1.text = "Study Progress"
        let studyper = String(format:"%.1f",(dashbaoardData[indexPath.row].new_studyprogress))
      
        cell?.studyPercentage.text = studyper + "%"
        cell?.totalsubjects.text = String(Int(dashbaoardData[indexPath.row].new_totalsubjects)) + " Subjects"
        cell?.studyProgress?.progressColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0.2549019608, alpha: 1)
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            cell?.studyProgress?.value = CGFloat(Double(self.dashbaoardData[indexPath.row].new_studyprogress))
        }, completion: { finished in
        })
        cell?.title2.text = "Attendance"
        cell?.presentProgress?.progressColor = #colorLiteral(red: 0.3058823529, green: 0.7647058824, blue: 0.2588235294, alpha: 1)
        let present = dashbaoardData[indexPath.row].new_presentdays! * 100
        let total = dashbaoardData[indexPath.row].new_totalclasses!
        let presentattendance = present/total
        print(presentattendance)
        cell?.presentPercentage.text =  String(format:"%.1f",presentattendance) + "%"
        cell?.presentDays.text = String(Int(dashbaoardData[indexPath.row].new_presentdays)) + " Days"
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            cell?.presentProgress.value = CGFloat(Double(presentattendance))
        }, completion: { finished in
        })
        
        cell?.title3.text = "Performance"
        cell?.overallProgress?.progressColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        cell?.overAllPercentage.text = String(format:"%.1f",dashbaoardData[indexPath.row].new_percentage) + " %"
        cell?.overallObtained.text = String(Int(dashbaoardData[indexPath.row].new_obtainedmarks)) + " Overall"
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            cell?.overallProgress.value = CGFloat(Double(self.dashbaoardData[indexPath.row].new_percentage))
        }, completion: { finished in
        })
        cell!.selectionStyle = .none
        return cell!
    }
    
    @objc func studyProgess(sender: UIButton) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "progress") as! StudyProgressController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func attendance(sender: UIButton) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "attendance") as! AttendanceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func overAll(sender: UIButton) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "performance") as! PerformanceScoreController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getProfileData() {
        WebService.shared.getUserProfile(registrationValue:regId,completion:{(response,error) in
            ProgressLoader.shared.showLoader(withText:"")
            if error == nil , let responseDict = response{
                if responseDict.count>0 {
                     
                    if let profiledict = responseDict["value"].arrayObject as? [[String:Any]]{
                        for data in profiledict {
                            CoreDataController.sharedInstance.insertAndUpdateUserProfile(registrationID:self.regId, jsonObject:[data])
                        }
                    }
                        let currentclasssession:String? = responseDict["value"][0]["_sis_currentclasssession_value"].stringValue
                        UserDefaults.standard.set(currentclasssession, forKey: "_sis_currentclasssession_value")
                        let studentid:String? = responseDict["value"][0]["sis_studentid"].stringValue
                        UserDefaults.standard.set(studentid, forKey: "sis_studentid")
                        let studentValue:String? = responseDict["value"][0]["_sis_studentname_value"].stringValue
                        UserDefaults.standard.set(studentValue, forKey: "_sis_studentname_value")
                        
                        let fatherName:String? = responseDict["value"][0]["sis_fathername"].stringValue
                        UserDefaults.standard.set(fatherName, forKey: "sis_fathername")
                        let mothername:String? = responseDict["value"][0]["sis_mothername"].stringValue
                        UserDefaults.standard.set(mothername, forKey: "sis_mothername")
                        let profileImage:String? = responseDict["value"][0]["entityimage"].stringValue
                        let studentImage = UIImage.decodeBase64(toImage:profileImage)
                        let imgData = studentImage.pngData()
                        UserDefaults.standard.set(imgData, forKey: "entityimage")
                        let emailaddress:String? = responseDict["value"][0]["emailaddress"].stringValue
                        UserDefaults.standard.set(emailaddress, forKey: "emailaddress")
                        let schoolName:String? = responseDict["value"][0]["new_program"]["sis_name"].stringValue
                        
                        UserDefaults.standard.set(schoolName, forKey: "new_program")
                        let studentName:String? = responseDict["value"][0]["sis_name"].stringValue
                        UserDefaults.standard.set(studentName, forKey: "studentName")
                        
                        let CategoryText:String? = responseDict["value"][0]["CategoryText"].stringValue
                        UserDefaults.standard.set(CategoryText, forKey: "CategoryText")
                        let dob:String? = responseDict["value"][0]["sis_dateofbirth"].stringValue
                        UserDefaults.standard.set(Date.getFormattedDate(string:dob!, formatter: "dd-MMM-yyyy"), forKey: "sis_dateofbirth")
                        let gender:String? = responseDict["value"][0]["sis_gender"].stringValue
                        UserDefaults.standard.set(gender, forKey: "sis_gender")
                        let mobile:String? = responseDict["value"][0]["sis_primarymobilenumber"].stringValue
                        UserDefaults.standard.set(mobile, forKey: "sis_primarymobilenumber")
                        let classsession:String? = responseDict["value"][0]["_sis_currentclasssession"].stringValue
                        UserDefaults.standard.set(classsession, forKey: "_sis_currentclasssession")
                        let registration:String? = responseDict["value"][0]["_sis_registration"].stringValue
                        UserDefaults.standard.set(registration, forKey: "_sis_registration")
                        let section:String? = responseDict["value"][0]["_sis_section"].stringValue
                        UserDefaults.standard.set(section, forKey: "_sis_section")
                        let admissionDate:String? = responseDict["value"][0]["sis_dateofadmission"].stringValue
                        UserDefaults.standard.set(Date.getFormattedDate(string:admissionDate!, formatter: "dd-MMM-yyyy"), forKey: "sis_dateofadmission")
                        let sectionValue:String? = responseDict["value"][0]["_sis_section_value"].stringValue
                        UserDefaults.standard.set(sectionValue, forKey: "_sis_section_value")
                        
                        let Class:String? = responseDict["value"][0]["_sis_class"].stringValue
                        UserDefaults.standard.set(Class, forKey: "_sis_class")
                }
                
            }else{
                ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title:"Error!", message:"while fetching user profile data")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    func fetchDashBoardData() {
        
        WebService.shared.GetDashboardData(currentClassSession:classSession, studentID:studentID, completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let dashBoardDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    
                    for data in dashBoardDict {
                      CoreDataController.sharedInstance.insertAndUpdateStudentDashBoard(studentName:(data["sis_name"] as? String)!, jsonObject:[data])
                        self.fetchStudentDashBaordData(name:(data["sis_name"] as? String)!)
                    }
                    
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchStudentDashBaordData(name:String) {
        CoreDataController.sharedInstance.fetchStudentDashboardDataRequest(student:name, completion:{(response,error) in
             if error == nil , let resposneDict = response {
                 let itemsJsonArray = (Singleton.convertToJSONArray(moArray:resposneDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                     self.dashbaoardData.removeAll()
                    for data in itemsJsonArray! {
                             let dashboard = Dashboard(data)
                             self.dashbaoardData.append(dashboard)
                         }
                    Singleton.setUpTableViewDisplay(self.dashboardTable, headerView:"", "dashboardTableViewCell")
                    self.dashboardTable.delegate = self
                    self.dashboardTable.dataSource = self
                     }
                 }
             else {
                debugPrint(error?.localizedDescription ?? "Student Dashboard Data Not found")
            }
         })
     }
    
    @IBAction func viewButton(_ sender: Any) {
        let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "profile") as! ProfileTableTableViewController
        destViewController.registrationID = regId
        destViewController.FromTeacher = true
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
}
