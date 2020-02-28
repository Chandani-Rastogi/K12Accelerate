//
//  TeacherTableViewController.swift
//  eLiteSIS
//
//  Created by apar on 02/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit


struct TeacherDetails{
    
    var emailaddress : String!
    var sisName : String!
    var sisPhoneno : String!
    var sisRegistrationid : SisRegistrationid!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        emailaddress = dictionary["emailaddress"] as? String
        sisName = dictionary["sis_name"] as? String
        sisPhoneno = dictionary["sis_phoneno"] as? String
        if let sisRegistrationidData = dictionary["sis_registrationid"] as? [String:Any]{
            sisRegistrationid = SisRegistrationid(fromDictionary: sisRegistrationidData)
        }
    } 
}
struct SisRegistrationid{
    
    var categoryText : String!
    var entityimage : String!
    var sisDateofbirth : String!
    var sisFathersname : String!
    var sisGender : Int!
    var sisMothersname : String!
    var sisRegistrationid : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        categoryText = dictionary["CategoryText"] as? String
        entityimage = dictionary["entityimage"] as? String
        sisDateofbirth = dictionary["sis_dateofbirth"] as? String
        sisFathersname = dictionary["sis_fathersname"] as? String
        sisGender = dictionary["sis_gender"] as? Int
        sisMothersname = dictionary["sis_mothersname"] as? String
        sisRegistrationid = dictionary["sis_registrationid"] as? String
    }
}


class TeacherTableViewController: UITableViewController {
    var teacherId : String = ""
    var teacherdetails = [TeacherDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        self.getFacultyDetails()
        Singleton.setUpTableViewDisplay(self.tableView, headerView:"TeacherHeaderView", "TeacherTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.teacherdetails.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teacherdetails.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier:"TeacherHeaderView") as! TeacherHeaderView
        
        viewHeader.userNameLbl.text = self.teacherdetails[section].sisName
        let teacherImage = UIImage.decodeBase64(toImage:self.teacherdetails[section].sisRegistrationid.entityimage)
        let imgData = teacherImage.pngData()
        viewHeader.profileimageView.layer.cornerRadius = viewHeader.profileimageView.bounds.width/2.0
        viewHeader.profileimageView.clipsToBounds = true
        viewHeader.profileimageView.image = UIImage(data:imgData!)
        
        return viewHeader
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TeacherTableViewCell") as! TeacherTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if (self.teacherdetails[indexPath.row].sisRegistrationid.sisGender)  == 1
        {
            cell.title1.text = "Male"
        }
        else{
            cell.title1.text = "Female"
        }
        cell.title2.text = Date.getFormattedDate(string:self.teacherdetails[indexPath.row].sisRegistrationid.sisDateofbirth, formatter:"dd-MM-yyyy")
        cell.title3.text =  self.teacherdetails[indexPath.row].sisRegistrationid.sisFathersname
        cell.title4.text =  self.teacherdetails[indexPath.row].sisRegistrationid.sisMothersname
        cell.title5.text =  self.teacherdetails[indexPath.row].sisRegistrationid.categoryText
        cell.mobileNumber.text =  self.teacherdetails[indexPath.row].sisPhoneno
        cell.emailaddress.text =  self.teacherdetails[indexPath.row].emailaddress
        
        return cell
    }
    func getFacultyDetails() {
        
        WebService.shared.GetTeacherDetail(facultyID:teacherId,completion:{(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText: "Fetching Teacher Details ....")
                
                if let teacherdict = responseDict["value"].arrayObject as? [[String:Any]]{
                    
                    for teacherData in teacherdict {
                        let details = TeacherDetails(fromDictionary:teacherData)
                       self.teacherdetails.append(details)
                       self.tableView.reloadData()
                    }
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Server error. Please contact Admin!!")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
}
