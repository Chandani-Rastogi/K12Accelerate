//
//  TeacherProfileController.swift
//  eLiteSIS
//
//  Created by apar on 26/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

class TeacherProfileController: UITableViewController {
    var selectedMenuItem : Int = 0
      var userDict = [String:Any]()
     var profileDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = nil
        self.tableView.dataSource =  nil
        self.tableView.separatorStyle = .none
        self.fetchTeacherProfileData()
       
    }
    
    func fetchTeacherProfileData() {
        
     TeacherCoreDatacontroller.shared.fetchFacultyDataRequest(regID:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!, completion:{(response, error) in
            
            if error == nil , let responseDict = response {
                self.userDict = responseDict as! [String:Any]
                if self.userDict.count > 0 {
                 self.setUpTableViewDisplay()
                }
               
            }else{
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
        })
    }
    
    func getTeacherData() {
        
        ProgressLoader.shared.showLoader(withText:"Refreshing Profile Data ....")
        
        WebService.shared.GetFacultyProfiledetails(registrationValue:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!,completion:{(response,error) in
            
            if error == nil , let responseDict = response {
                if responseDict.count > 0 {
                    print(responseDict)
                    Singleton.sharedInstance.deleteAllRecords(EntityName:"FacultyProfile")
                    self.profileDict = ["DateOfBirth" : responseDict["DateOfBirth"].stringValue,
                                        "FatherName" : responseDict["FatherName"].stringValue,
                                        "MotherName" :responseDict["MotherName"].stringValue,
                                        "GenderText" : responseDict["GenderText"].stringValue,
                                        "ApplicantFullName" : responseDict["ApplicantFullName"].stringValue,
                                        "PrimaryEmailAddress" : responseDict["PrimaryEmailAddress"].stringValue,
                                        "PrimaryMobileNumber" : responseDict["PrimaryMobileNumber"].stringValue,
                                        "CategoryText" : responseDict["CategoryText"].stringValue,
                                        "Entityimage" : responseDict["Entityimage"].stringValue,
                                        "HouseNo" : responseDict["HouseNo"].stringValue,
                                        "StreetNo" : responseDict["StreetNo"].stringValue,
                                        "City": responseDict["City"].stringValue,
                                        "State" : responseDict["State"].stringValue,
                                        "Country" : responseDict["Country"].stringValue,
                                        "QualificationName": responseDict["QualificationName"].stringValue,
                                        "Year" : responseDict["Year"].stringValue,
                                        "CGPA" : responseDict["CGPA"].doubleValue,
                                        "PostalCode" : responseDict["PostalCode"].stringValue,
                                        "ClassName" : responseDict["className"].stringValue,
                                        "ID" : responseDict["ID"].stringValue,
                                        "Percentage" : responseDict["Percentage"].stringValue,
                                        "AddressLine" : responseDict["AddressLine"].stringValue,
                                        "AllowNotification" : responseDict["AllowNotification"].boolValue,
                                        "IsPrincipal" : responseDict["IsPrincipal"].boolValue
                        ] as [String : Any]
                    TeacherCoreDatacontroller.shared.insertAndUpdateFacultyProfile(registrationID:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!, jsonObject:self.profileDict)
                        
                         self.setUpTableViewDisplay()
                    ProgressLoader.shared.hideLoader()
                    
                }
            }
            else{
                
            }
            
        })
    }
    
    
    
    @IBAction func refreshButton(_ sender: Any) {
        
        self.getTeacherData()
    }
    
    
    func setUpTableViewDisplay() {
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        self.tableView.scrollsToTop = false
        self.tableView.bounces = false
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName:"FacultyHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FacultyHeaderView")
        self.tableView.register(UINib(nibName:"FacultyProfileCell", bundle: nil), forCellReuseIdentifier: "FacultyProfileCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FacultyHeaderView") as! FacultyHeaderView
        
        viewHeader.facultyName.text =  userDict["ApplicantFullName"] as? String
        viewHeader.facultyID.text = userDict["ID"] as? String
        viewHeader.profileimage.layer.cornerRadius = viewHeader.profileimage.bounds.width/2.0
        viewHeader.profileimage.clipsToBounds = true
        
        if (self.userDict["Entityimage"] as? String)!.count > 0 {
            let FacultyImage = UIImage.decodeBase64(toImage:userDict["Entityimage"] as? String)
            let imgData = FacultyImage.pngData()
            viewHeader.profileimage.image = UIImage(data: imgData!)
        }
       else
        {
           if(self.userDict["GenderText"] as? String) == "Female" {
                  viewHeader.profileimage.image = #imageLiteral(resourceName: "female")
                }
                else{
                    viewHeader.profileimage.image = #imageLiteral(resourceName: "profile")
                }
            
        }
        
        return viewHeader
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "FacultyProfileCell") as! FacultyProfileCell
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.selectionStyle = .none
        cell.dobText.text = Date.getFormattedDate(string: (userDict["DateOfBirth"] as? String)!, formatter:"dd-MM-YYYY")
        cell.mothersNAmeTExt.text =  userDict["MotherName"] as? String
        cell.fathersNameText.text =   userDict["FatherName"] as? String
        cell.categoryText.text =   userDict["CategoryText"] as? String
        cell.genderText.text =  userDict["GenderText"] as? String
        cell.mobileText.text =  userDict["PrimaryMobileNumber"] as? String
        cell.emailIDText.text =  userDict["PrimaryEmailAddress"] as? String
        cell.qualifactionText.text =   userDict["QualificationName"] as? String
        cell.yearOfPassingtext.text =  userDict["Year"] as? String
        let cgpaString = String(format:"%.f", (userDict["CGPA"] as? Double)!)
        
        
        if cgpaString == "0" {
        
            cell.cgpaTExt.text = "NA"
            
        }
        else {
            cell.cgpaTExt.text =  cgpaString + "/" +  ((userDict["Percentage"] as? String)!)
        }
        
       
       
        let houseno =   userDict["HouseNo"] as! String
        let houseStreet =  userDict["StreetNo"] as! String
        cell.addressText.text = userDict["AddressLine"] as? String
        cell.streetNAMe.text = houseStreet
        cell.addressLine.text = houseno 
        cell.cityTExt.text =  userDict["City"] as? String
        cell.statText.text =   userDict["State"] as? String
        cell.countryText.text =  userDict["Country"] as? String
        cell.postalCodeText.text =  userDict["PostalCode"] as? String
        return cell
        
    }
}

