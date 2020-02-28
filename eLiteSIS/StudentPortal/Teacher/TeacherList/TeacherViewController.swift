//
//  TeacherViewController.swift
//  eLiteSIS
//
//  Created by apar on 27/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData


struct Teacher {
    var newFacultyValue : String!
    var facultyName : String!
    var profile : String!
    var phoneNo : String!
    var subjectNAme : String!
    var subjectId : String!
    var teacherRegisrationValue : String!
    var gender : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        newFacultyValue = dictionary["teacherID"] as? String
        facultyName = dictionary["teacherName"] as? String
        profile = dictionary["profileIcon"] as? String
        phoneNo = dictionary["phoneNo"] as? String
        subjectId = dictionary["subjectId"] as? String
        subjectNAme = dictionary["subjectName"] as? String
        teacherRegisrationValue = dictionary["regirationID"] as? String
        gender = dictionary[""] as? String
    }
}

class TeacherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var emptydata: UIImageView!
    @IBOutlet weak var teacherList: UITableView!
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    var teacherlist = [Teacher]()
    var teacherTimings = [Timings]()
    var facultyValue : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teacherList.backgroundColor = #colorLiteral(red: 0.9242504239, green: 0.9242504239, blue: 0.9242504239, alpha: 1)
        self.teacherList.separatorColor = .clear
        self.teacherList.delegate = nil
        self.teacherList.dataSource = nil
        self.emptydata.isHidden = true
        self.fetchFacultyList()
        self.getFacultyList()

        // Do any additional setup after loading the view.
    }
   
    // MARK: - Table view data source
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teacherlist.count
    }
    
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier:"TeacherListHeaderView") as! TeacherListHeaderView
        
        return viewHeader
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"TeacherListTableViewCell") as! TeacherListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.viewTimings.tag = indexPath.row
        cell.viewTimings.addTarget(self, action: #selector(viewTimingsSelected), for: .touchUpInside)
        cell.chatButton.tag = indexPath.row
        cell.chatButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        cell.teacherName.text = self.teacherlist[indexPath.row].facultyName
        cell.subjectName.text = self.teacherlist[indexPath.row].subjectNAme
        let teacherImage = UIImage.decodeBase64(toImage:self.teacherlist[indexPath.row].profile)
        let imgData = teacherImage.pngData()
        cell.teacherProfileImage.layer.cornerRadius = cell.teacherProfileImage.bounds.width/2.0
        cell.teacherProfileImage.clipsToBounds = true
        if imgData != nil{
             cell.teacherProfileImage.image = UIImage(data:imgData!)
        }
        else{
            cell.teacherProfileImage.image = #imageLiteral(resourceName: "profile")
        }
       
        return cell
        
    }
    @objc func viewTimingsSelected(sender: UIButton) {
        
        let index = sender.tag
        facultyValue = self.teacherlist[index].newFacultyValue
        let teacherImage = self.teacherlist[index].profile
        let teacherName = self.teacherlist[index].facultyName
        let teacherSubject = self.teacherlist[index].subjectNAme
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
         let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "getAvailable") as! GetAvailableTimingController
        vc.facultyValue = facultyValue
        vc.facultyName = teacherName!
        vc.facultyProfilePicture = teacherImage!
        vc.facultySubject = teacherSubject!
        navigationController?.pushViewController(vc, animated: true)
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teacher") as? TeacherTableViewController{
           vc.teacherId = self.teacherlist[indexPath.row].newFacultyValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func buttonSelected(sender: UIButton){
        let index = sender.tag
         let teacherName = self.teacherlist[index].facultyName
         let teacherImage = self.teacherlist[index].profile
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "discuss") as? DiscussionViewController{
            vc.facultyID = self.teacherlist[index].teacherRegisrationValue
            vc.facultyname = teacherName!
            vc.facultyprofileImage = teacherImage!
            vc.fromTeacherList = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    func getFacultyList() {
        
        ProgressLoader.shared.showLoader(withText:"Fetching Teacher List....")
        guard let sectionValue = UserDefaults.standard.object(forKey: "_sis_section_value") as? String else {
            return
        }
        WebService.shared.getFacultyList(sectionValue:sectionValue,completion:{(response, error) in
            if error == nil , let responseDict = response {
                print(responseDict)
                if let teacherdict = responseDict["value"].arrayObject as? [[String:Any]]{
                    
                    if teacherdict.count > 0 {
                        for data in teacherdict {
                          let subjectNm = data["new_subject"] as? [String:Any]
                        CoreDataController.sharedInstance.insertAndUpdateTeacherList(subjectName:(subjectNm?["sis_name"] as? String)!, jsonObject:[data])
                        }
                        self.teacherList.isHidden = false
                        self.emptydata.isHidden = true
                        self.fetchFacultyList()
                         ProgressLoader.shared.hideLoader()
                    }
                    else
                    {
                        self.teacherList.isHidden = true
                        self.emptydata.isHidden = false
                         ProgressLoader.shared.hideLoader()
                    }
                   
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Server error. Please contact Admin!!")
                ProgressLoader.shared.hideLoader()
            }
          //
        })
    }
    
    func fetchFacultyList() {
        CoreDataController.sharedInstance.fetchTeacherListRequest(completion:{(respose,error) in
            if error == nil , let resposeDict = respose {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:resposeDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.teacherlist.removeAll()
                        for data in itemsJsonArray! {
                            let list = Teacher(fromDictionary:data)
                            self.teacherlist.append(list)
                        }
                        Singleton.setUpTableViewDisplay(self.teacherList, headerView:"TeacherListHeaderView","TeacherListTableViewCell")
                        self.teacherList.delegate = self
                        self.teacherList.dataSource = self
                        self.teacherList.bounces = true
                }
            }
        })
    }
}
