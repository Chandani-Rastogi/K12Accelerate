//
//  MenuController.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class MenuController: UITableViewController {
    var moreItems = [String]()
    var thumbImage = [String]()
     var identifier = [String]()
    
    var userDict = [String:Any]()
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = nil
        tableView.dataSource = nil

           TeacherCoreDatacontroller.shared.fetchFacultyDataRequest(regID:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.userDict = responseDict as! [String:Any]
                
                
                if UserDefaults.standard.value(forKey:"new_rolecode") as? String == "212" {
                    if self.userDict["AllowNotification"] as? Bool == false {
                        
                        self.moreItems = ["Home","Homework","Upload Circular","Upload Syllabus","My Profile","View Notifications","Holiday List","Change Password","Logout"]
                        self.thumbImage = ["Home","Assignment","Assignment","Assignment","user","notification","HolidayList","changePassword","login"]
                        self.identifier = ["teacherHome","facultyHomeWork","uploadcircular","uploadcircular","teacher_profile","Notification","holiday","changepassword","login"]
                    }
                    else {
                        
                        if self.userDict["IsPrincipal"] as? Bool == false {
                            self.moreItems = ["Home","Homework","Upload Circular","Upload Syllabus","My Profile","View Notifications","Send Notification","Notification Summary","Holiday List","Change Password","Logout"]
                            self.thumbImage = ["Home","Assignment","Assignment","Assignment","user" ,"notification","notification","notification","HolidayList","changePassword","login"]
                            self.identifier = ["teacherHome","facultyHomeWork","uploadcircular","uploadcircular","teacher_profile","Notification","custom","notificationSummary","holiday","changepassword","login"]
                        }
                            
                        else {
                            
                            self.moreItems = ["Home","View Classwise Attendance","My Profile","HomeWork Report","View Notifications","Send Notification","Notification Summary","View Feedback Report","Employee Discussion","Holiday List","Change Password","Logout"]
                            
                            self.thumbImage = ["Home","attendance","user" ,"Assignment","notification","notification","notification","user","Discussion","HolidayList","changePassword","login"]
                            self.identifier = ["teacherHome","getAttendance","teacher_profile","homeworkReport","Notification","custom","notificationSummary","feedback","emplyeeList","holiday","changepassword","login"]
                        }
                    }
                }
                else {
                    if self.userDict["AllowNotification"] as? Bool == false {
                        self.moreItems = ["Home","Attendance","Homework","Upload Circular","Upload Syllabus","Discussion","My Profile","View Notifications","Student Information","Holiday List","Change Password","Logout"]
                        self.thumbImage = ["Home","user","Assignment","Assignment","Assignment","Discussion","user","notification","user","HolidayList","changePassword","login"]
                        self.identifier = ["teacherHome","st_attendance","facultyHomeWork","uploadcircular","uploadcircular","studentList","teacher_profile","Notification","studentList","holiday","changepassword","login"]
                    }
                    else{
                        self.moreItems = ["Home","Attendance","Homework","Upload Circular","Upload Syllabus","Discussion","My Profile","View Notifications","Send Notification","Notification Summary","Holiday List","Change Password","Logout"]
                        self.thumbImage = ["Home","user","Assignment","Assignment","Assignment","Discussion","user","notification","notification","notification","HolidayList","changePassword","login"]
                        self.identifier = ["teacherHome","st_attendance","facultyHomeWork","uploadcircular","uploadcircular","studentList","teacher_profile","Notification","custom","notificationSummary","holiday","changepassword","login"]
                    }
                }
                
            }else{
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
        })
        
        Singleton.setUpTableViewDisplay(self.tableView, headerView: "MoreHeaderView", "MoreTableViewCell")
         self.tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moreItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MoreHeaderView") as! MoreHeaderView
        
        viewHeader.userNameLabel.text =  self.userDict["ApplicantFullName"] as? String
        viewHeader.studentIDLabel.text = self.userDict["ID"] as? String
        viewHeader.profileImageView.layer.cornerRadius = viewHeader.profileImageView.bounds.width/2.0
        viewHeader.profileImageView.clipsToBounds = true
        
        if self.userDict.count > 0 {
            
            if (self.userDict["Entityimage"] as? String)!.count > 0 {
                let FacultyImage = UIImage.decodeBase64(toImage:self.userDict["Entityimage"] as? String)
                let imgData = FacultyImage.pngData()
                viewHeader.profileImageView.image = UIImage(data: imgData!)
            }
            else
            {
                if(self.userDict["GenderText"] as? String) == "Female" {
                    viewHeader.profileImageView.image = #imageLiteral(resourceName: "female")
                }
                else{
                    viewHeader.profileImageView.image = #imageLiteral(resourceName: "profile")
                }
                
            }
        }
       viewHeader.profileImageView.image = #imageLiteral(resourceName: "profile")
        return viewHeader
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"MoreTableViewCell") as! MoreTableViewCell
        cell.labelText.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        cell.labelText.font = UIFont(name:"Helvetica Neue", size:14)
        cell.thumbImage.image =  UIImage(named:self.thumbImage[indexPath.row])
        cell.labelText.text = self.moreItems[indexPath.row]
        return cell
        
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var destViewController : UIViewController
        
        if self.identifier[indexPath.row] == "login" {
            let alert = UIAlertController(title: "Alert!", message: "Do you want to Logout?", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Log Out", style: .default, handler: { action in
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                Singleton.sharedInstance.deleteAllRecords(EntityName:"FacultyHomeWorkList")
                Singleton.sharedInstance.deleteAllRecords(EntityName:"FacultyProfile")
                Singleton.sharedInstance.deleteAllRecords(EntityName:"AllStudent")
                
                Messaging.messaging().unsubscribe(fromTopic:"employee")
                Messaging.messaging().unsubscribe(fromTopic:"whole_school")
                
                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                UserDefaults.standard.setIsLoggedIn(value:false)
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.identifier[indexPath.row]) as? LoginViewController{
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
                    
                }
            })
            alert.addAction(okButton)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            })
            alert.addAction(cancel)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
            
        else if self.moreItems[indexPath.row] == "Discussion" {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:self.identifier[indexPath.row]) as? StudentListViewController{
                vc.navTitle = "Chat"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
            
        else if self.moreItems[indexPath.row] == "Upload Circular" {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:self.identifier[indexPath.row]) as? UploadCircularSyllabusController{
                vc.uploadtitle = "Upload Circular"
                vc.uploadType = 2
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if self.moreItems[indexPath.row] == "Upload Syllabus" {
           if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:self.identifier[indexPath.row]) as? UploadCircularSyllabusController{
                vc.uploadtitle = "Upload Syllabus"
                vc.uploadType = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            destViewController = mainStoryboard.instantiateViewController(withIdentifier:self.identifier[indexPath.row])
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
    }
    
    func deleteAllEntity() {
        
        
    }
}
