//
//  ProfileTableTableViewController.swift
//  eLiteSIS
//
//  Created by apar on 31/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

class ProfileTableTableViewController: UITableViewController {
    var registrationID : String = ""
    var profileDict = [String:Any]()
    var addressDict = [String:Any]()
    var FromTeacher = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        self.tableView.separatorStyle = .none
        tableView.delegate = nil
        tableView.dataSource = nil
        if FromTeacher == false
        {
        registrationID = (UserDefaults.standard.object(forKey: "_sis_registration_value") as? String)!
        }
        self.tableView.bounces = true
        self.fetchProfileDetails()
        self.fetchAddress()
        self.getaddress()
    }
    
    
    @IBAction func refreshProfile(_ sender: Any) {
        self.getProfileData()
        
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        
    }
    
    func getProfileData() {
        ProgressLoader.shared.showLoader(withText:"Refreshing Profile Data ....")
        WebService.shared.getUserProfile(registrationValue:registrationID,completion:{(response,error) in
            
            if error == nil , let responseDict = response{
                if responseDict.count>0 {
                Singleton.sharedInstance.deleteAllRecords(EntityName:"UserProfile")
                    print(responseDict)
                    
                    let currentclasssession:String? = responseDict["value"][0]["_sis_currentclasssession_value"].stringValue
                    UserDefaults.standard.set(currentclasssession, forKey: "_sis_currentclasssession_value")
                    
                    let sisectionvalue = responseDict["value"][0]["_sis_section_value"].stringValue
                    UserDefaults.standard.set(sisectionvalue, forKey:"_sis_section_value")
                    
                    print(sisectionvalue)
                    print(UserDefaults.standard.value(forKey:"_sis_section_value")!)
                    
                    
                    let classvalue = responseDict["value"][0]["_sis_class_value"].stringValue
                    UserDefaults.standard.set(classvalue, forKey:"_sis_class_value")
                    
                    
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
                    
                    let userID : String? = UserDefaults.standard.object(forKey: "userID") as? String
                    
                    if let profiledict = responseDict["value"].arrayObject as? [[String:Any]]{
                        for data in profiledict {
                            
                            CoreDataController.sharedInstance.insertAndUpdateUserProfile(registrationID:self.registrationID , jsonObject:[data])
                        }
                        self.fetchProfileDetails()
                        self.getaddress()
                    }
                   
                }
                
            }else{
                ProgressLoader.shared.hideLoader()
            }
            ProgressLoader.shared.hideLoader()
        })
    }
   
    
    func fetchProfileDetails() {
        CoreDataController.sharedInstance.fetchProfileDataRequest(regID:registrationID, completion:{(response, error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    for data in itemsJsonArray! {
                        self.profileDict  = (data as? [String:Any])!
                        Singleton.setUpTableViewDisplay(self.tableView, headerView: "ProfileHeaderView", "ProfileTableViewCell")
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                    }
                }
            }
        })
    }
    
    
    func fetchAddress() {
        CoreDataController.sharedInstance.fetchAddressDataRequest(regID:registrationID, completion:{(response,error) in
            if error == nil, let resposneDict = response {
                self.addressDict = resposneDict as! [String:Any]
                if self.addressDict.count > 0 {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 730
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderView") as! ProfileHeaderView
        viewHeader.userNameLabel.text = self.profileDict["name"] as? String
        viewHeader.collegeNameLabel.text = ((self.profileDict["programName"] as? String)!)
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.selectionStyle = .none
        
        cell.dob.text = Date.getFormattedDate(string:((self.profileDict["dob"] as? String)!) , formatter: "dd-MMM-yyyy")
        cell.motherName.text = self.profileDict["motherName"] as? String
        cell.fatherName.text = self.profileDict["fatherName"] as? String
        cell.category.text =  self.profileDict["categoryTxt"] as? String

        cell.gender.text = self.profileDict["gender"] as? String
        cell.mobileNumber.text = self.profileDict["mobileNumber"] as? String
        cell.emailId.text = self.profileDict["email"] as? String
        cell.classID.text = self.profileDict["registrationNum"] as? String
        cell.classSession.text = self.profileDict["sessionName"] as? String
        cell.dateApplied.text = Date.getFormattedDate(string:((self.profileDict["admissionDate"] as? String)!) , formatter: "dd-MMM-yyyy")
        let houseno = self.addressDict["sis_houseno"] as? String
        
        let houseStreet = self.addressDict["sis_streetnumber"] as? String
        cell.Address.text = (houseno ?? "")
        cell.streetnumber.text = houseStreet ?? ""
        cell.addressType.text =  self.addressDict["sis_name"] as? String ?? ""
        
        if (self.addressDict["sis_city"] as? [String:Any]) != nil {
        cell.city.text = ((self.addressDict["sis_city"] as? [String:Any])!["sis_name"] as? String) ?? ""
        }
        else {
            cell.city.text = ""
        }
        
        if (self.addressDict["sis_state"] as? [String:Any]) != nil {
             cell.state.text = ((self.addressDict["sis_state"] as? [String:Any])!["sis_name"] as? String) ?? ""
        }
        else{
            cell.state.text = ""
        }
        
        if (self.addressDict["sis_country"] as? [String:Any]) != nil {
            cell.country.text = ((self.addressDict["sis_country"] as? [String:Any])!["sis_name"] as? String) ?? ""
        }
        else{
          cell.country.text = ""
        }
        
        if (self.addressDict["sis_postalcode"] as? String) != nil {
           cell.postalCode.text = (self.addressDict["sis_postalcode"] as? String) ?? ""
        }
        else{
           cell.postalCode.text = ""
        }
        
        return cell
    }

    func getaddress() {
        WebService.shared.getAddress(registrationValue:registrationID,completion:{(response,error) in
            ProgressLoader.shared.showLoader(withText:"")
            if error == nil , let responseDict = response{
                if responseDict.count > 0 {
                    Singleton.sharedInstance.deleteAllRecords(EntityName:"StudentAddress")
                    
                    if let addressDict = responseDict["value"].arrayObject as? [[String:Any]]{
                        for data in addressDict {
                            CoreDataController.sharedInstance.insertAndUpdateStudentAddress(registrationID:self.registrationID, jsonObject:data)
                        }
                        self.fetchAddress()
                    }
                }
            }else{
                
            }
            ProgressLoader.shared.hideLoader()
        })
    }
 
}
