//
//  MoreTableViewController.swift
//  eLiteSIS
//
//  Created by apar on 31/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class MoreTableViewController: UITableViewController {
    var moreItems = [String]()
    var thumbImage = [String]()
    var profileDict = [String:Any]()
    var identifierDict = [String]()
    
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey:"fromWebView"){
            let destViewController  = storyboard?.instantiateViewController(withIdentifier: "receipt") as! FeeReceiptTableViewController
            self.navigationController?.pushViewController(destViewController, animated: false)
            UserDefaults.standard.set(false, forKey:"fromWebView")
        }
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        moreItems = ["Home","Chat History","Attendance","Homework","Fee Payment","Fee Receipt","Notification","View Circular","View Syllabus","Holiday List","My Profile","Change Password","Logout"]
        
        thumbImage = ["Home","Discussion","attendance","HomeWork","FeePayment","FeePayment","notification","Assignment","Assignment","HolidayList","user","changePassword","login"]
        
        identifierDict = ["studentHome","recentChat","attendance","homework","BasicPayment","receipt","Notification","circular","circular","holiday","profile","changepassword","login"]
        
        self.tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        fetchProfileDetails()
        
    }
    func fetchProfileDetails() {
        
        CoreDataController.sharedInstance.fetchProfileDataRequest(regID:(UserDefaults.standard.object(forKey: "_sis_registration_value") as? String)!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    for data in itemsJsonArray! {
                        self.profileDict  = (data as? [String:Any])!
                        Singleton.setUpTableViewDisplay(self.tableView, headerView: "MoreHeaderView", "MoreTableViewCell")
                        UserDefaults.standard.set(self.profileDict["sectionValue"], forKey:"_sis_section_value")
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                    }
                }
            }
        })
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
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier:"MoreHeaderView") as! MoreHeaderView
        viewHeader.userNameLabel.text =   self.profileDict["name"] as? String
        viewHeader.studentIDLabel.text = ((self.profileDict["programName"] as? String)!)
        viewHeader.profileImageView.layer.cornerRadius = viewHeader.profileImageView.bounds.width/2.0
        viewHeader.profileImageView.clipsToBounds = true
        let studentImage = UIImage.decodeBase64(toImage:self.profileDict["entityImage"] as? String)
        let imgData = studentImage.pngData()
        if let imgData =  imgData {
            viewHeader.profileImageView.image = UIImage(data: imgData)
        }else
        {
            viewHeader.profileImageView.image = #imageLiteral(resourceName: "profile")
        }
        
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
        
        if self.identifierDict[indexPath.row] == "changepassword"
        {
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "changepassword") as! ChangePasswordController
          //  destViewController.fromStudent = true
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        
        else if self.moreItems[indexPath.row] == "Syllabus"
        {
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "circular") as! CircularViewController
            
            destViewController.uploadtitle = "Syllabus"
            destViewController.uploadType = 1
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
       else if self.moreItems[indexPath.row] == "Circular"
        {
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "circular") as! CircularViewController
           destViewController.uploadtitle = "Circular"
                       destViewController.uploadType = 2
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        
       else if self.identifierDict[indexPath.row] == "login"
        {
            let alert = UIAlertController(title: "Alert!", message: "Do you want to Logout?", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Log Out", style: .default, handler: { action in
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                UserDefaults.standard.setIsLoggedIn(value:false)
                Singleton.sharedInstance.deleteAllRecords(EntityName:"Percentage")
                Singleton.sharedInstance.deleteAllRecords(EntityName:"AttendancePercentage")
                Singleton.sharedInstance.deleteAllRecords(EntityName:"HomeWorkList")
                Singleton.sharedInstance.deleteAllRecords(EntityName:"UserProfile")
                Singleton.sharedInstance.deleteAllRecords(EntityName:"TeacherList")
                
                Messaging.messaging().unsubscribe(fromTopic:((self.profileDict["sectionValue"] as? String)!))
                Messaging.messaging().unsubscribe(fromTopic:((self.profileDict["classValue"] as? String)!))
                Messaging.messaging().unsubscribe(fromTopic:"whole_school")
                
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as? LoginViewController{
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
        else{
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier:self.identifierDict[indexPath.row])
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        
    }
}

