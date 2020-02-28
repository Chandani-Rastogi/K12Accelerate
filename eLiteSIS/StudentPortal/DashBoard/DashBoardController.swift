//
//  DashBoardController.swift
//  eLiteSIS
//
//  Created by apar on 31/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBCircularProgressBar
import CoreData
import  Firebase


struct Dashboard {
    
    let  new_totalclasses : Double!
    let new_presentdays : Double!
    let new_absentdays: Double!
    let new_totalmarks : Double!
    let new_obtainedmarks : Double!
    let new_percentage : Double!
    let new_studyprogress : Double!
    let new_totalassignments : Double!
    let new_completedassignments : Double!
    let new_totalsubjects : Double!
    let sis_name : String!
    
    init(_ dict:[String:Any]) {
        
        new_totalclasses = dict["newTotalclasses"] as? Double
        new_presentdays = dict["presentDays"] as? Double
        new_absentdays = dict["absentsDays"] as? Double
        new_totalmarks = dict["totalMarks"] as? Double
        new_obtainedmarks = dict["obtainedMarks"] as? Double
        new_percentage = dict["percentage"] as? Double
        new_studyprogress = dict["studyProgress"] as? Double
        new_totalassignments = dict["totalAssignment"] as? Double
        new_completedassignments = dict["completedAssignments"] as? Double
        new_totalsubjects = dict["totalsSubjects"] as? Double
        sis_name = dict["studentName"] as? String
    }
   
}


class DashBoardController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var collegeName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var totalAssignments: UILabel!
    @IBOutlet weak var dueAssignmnets: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var dashbaoardData = [Dashboard]()
    var profileDict = [String:Any]()
    var regID : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       // Singleton.sharedInstance.deleteAllRecords(EntityName:"UserProfile")
        
        regID = (UserDefaults.standard.object(forKey: "_sis_registration_value") as? String)!
        dashboardTableView.delegate = nil
        dashboardTableView.dataSource = nil
        dashboardTableView.separatorColor = .clear
       
        self.fetchProfile(regid: regID)
        self.getProfileData()
        // Do any additional setup after loading the view.
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
        totalAssignments.text = String(Int(dashbaoardData[indexPath.row].new_totalassignments))
        dueAssignmnets.text = String(Int(due))
       
        cell?.Button1.addTarget(self, action: #selector(studyProgess), for: .touchUpInside)
        cell?.Button1.tag = indexPath.row
        
        cell?.Button2.addTarget(self, action: #selector(attendance), for: .touchUpInside)
        cell?.Button2.tag = indexPath.row
        
        cell?.button3.addTarget(self, action: #selector(overAll), for: .touchUpInside)
        cell?.button3.tag = indexPath.row
        
        cell?.title1.text = "Study Progress"
        cell?.studyPercentage.text = String(format:"%.1f" ,dashbaoardData[indexPath.row].new_studyprogress) + "%"
        cell?.totalsubjects.text = String(Int(dashbaoardData[indexPath.row].new_totalsubjects)) + " Subjects"
        cell?.studyProgress?.progressColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0.2549019608, alpha: 1)
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            cell?.studyProgress?.value = CGFloat(Double(self.dashbaoardData[indexPath.row].new_studyprogress))
        }, completion: { finished in
        })
        cell?.title2.text = "Attendance"
        cell?.presentProgress?.progressColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        let present = dashbaoardData[indexPath.row].new_presentdays! * 100
        let total = dashbaoardData[indexPath.row].new_totalclasses!
        let presentattendance = present/total
      
        cell?.presentPercentage.text =  String(format:"%.1f",presentattendance) + "%"
        cell?.presentDays.text = String(Int(dashbaoardData[indexPath.row].new_presentdays)) + " Days"
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
           cell?.presentProgress.value = CGFloat(Double(presentattendance))
        }, completion: { finished in
        })
        cell?.title3.text = "Performance"
        cell?.overallProgress?.progressColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
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
    func fetchProfile(regid:String) {
        
     CoreDataController.sharedInstance.fetchProfileDataRequest(regID:regid, completion:{(response, error) in
               if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0{
                    for  data in itemsJsonArray! {
                        self.profileDict  = (data as? [String:Any])!
                        self.userName.text = self.profileDict["name"] as? String
                        let studentImage = UIImage.decodeBase64(toImage:(self.profileDict["entityImage"] as? String))
                        let imgData = studentImage.pngData()
                        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width/2.0
                        self.profileImage.clipsToBounds = true
                        self.profileImage.image = UIImage(data:imgData!)
                        self.collegeName.text = (self.profileDict["programName"] as? String)!
                        self.fetchStudentDashBaordData(name:(self.profileDict["name"] as? String)!)
    
                    }
                }

               }else{
                   debugPrint(error?.localizedDescription ?? "Profile Not Found")
               }
           })
        
       }
    
    func getProfileData() {
        
        WebService.shared.getUserProfile(registrationValue:regID,completion:{(response,error) in
            ProgressLoader.shared.showLoader(withText:"")
            if error == nil , let responseDict = response{
                if responseDict.count>0 {
                    let currentclasssession:String? = responseDict["value"][0]["_sis_currentclasssession_value"].stringValue
                    UserDefaults.standard.set(currentclasssession, forKey: "_sis_currentclasssession_value")
                    
                    let sisectionvalue = responseDict["value"][0]["_sis_section_value"].stringValue
                    print(sisectionvalue)
                    UserDefaults.standard.set(sisectionvalue, forKey:"_sis_section_value")
                    
                    let studentid:String? = responseDict["value"][0]["sis_studentid"].stringValue
                    UserDefaults.standard.set(studentid, forKey: "sis_studentid")
                    
                    let studentValue:String? = responseDict["value"][0]["_sis_studentname_value"].stringValue
                    UserDefaults.standard.set(studentValue, forKey: "_sis_studentname_value")
                    
                    let profileImage:String? = responseDict["value"][0]["entityimage"].stringValue
                    let studentImage = UIImage.decodeBase64(toImage:profileImage)
                    let imgData = studentImage.pngData()
                    UserDefaults.standard.set(imgData, forKey: "entityimage")
                    
                    let studentName:String? = responseDict["value"][0]["sis_name"].stringValue
                    UserDefaults.standard.set(studentName, forKey: "studentName")
                    
                    let registration:String? = responseDict["value"][0]["_sis_registration"].stringValue
                    UserDefaults.standard.set(registration, forKey: "_sis_registration")
                    if let profiledict = responseDict["value"].arrayObject as? [[String:Any]]{
                        for data in profiledict {
                            CoreDataController.sharedInstance.insertAndUpdateUserProfile(registrationID:self.regID, jsonObject:[data])
                        }
                        self.fetchProfile(regid:self.regID)
                        
                    }
                    self.getDashBoardData(nme:studentName!)
                    
                }
                
            }else{
                ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title:"Error!", message:"while fetching user profile data")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func getDashBoardData(nme:String) {
    WebService.shared.GetDashboardData(currentClassSession:UserDefaults.standard.value(forKey:"_sis_currentclasssession_value") as! String, studentID: UserDefaults.standard.value(forKey:"sis_studentid") as! String, completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let dashBoardDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for data in dashBoardDict {
                        CoreDataController.sharedInstance.insertAndUpdateStudentDashBoard(studentName:(data["sis_name"] as? String)!, jsonObject:[data])
                    }
                    self.fetchStudentDashBaordData(name:nme)
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
                        Singleton.setUpTableViewDisplay(self.dashboardTableView,headerView:"", "dashboardTableViewCell")
                        self.dashboardTableView.delegate = self
                        self.dashboardTableView.dataSource = self
                     
                  }
              }
              else {
                  debugPrint(error?.localizedDescription ?? "Student Dashboard Data Not found")
              }
          })
      }

}
