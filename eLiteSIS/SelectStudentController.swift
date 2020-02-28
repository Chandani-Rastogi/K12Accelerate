//
//  SelectStudentController.swift
//  eLiteSIS
//
//  Created by apar on 27/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class SelectStudentController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var allTeacherlist = [Teacher]()
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    @IBOutlet weak var facultyList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.facultyList.separatorColor = .clear
        //self.fetchFacultyList()
        self.getFacultyList()
        self.facultyList.delegate = nil
        self.facultyList.dataSource = nil
        // Do any additional setup after loading the view.
    }
    
    func getFacultyList() {
             ProgressLoader.shared.showLoader(withText:"Fetching Faculty List ...")
        guard let sectionValue = UserDefaults.standard.object(forKey:"_sis_section_value") as? String else {
            return
        }
     
        WebService.shared.getFacultyList(sectionValue:sectionValue,completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let teacherdict = responseDict["value"].arrayObject as? [[String:Any]]{
                    
                    if teacherdict.count > 0 {
                        for data in teacherdict {
                            let subjectNm = data["new_subject"] as? [String:Any]
                            CoreDataController.sharedInstance.insertAndUpdateTeacherList(subjectName:(subjectNm?["sis_name"] as? String)!, jsonObject:[data])
                        }
                        self.fetchFacultyList()
                    }
                }
            }else{
                
            }
            
        })
    }
    
    func fetchFacultyList() {
        
      
        CoreDataController.sharedInstance.fetchTeacherListRequest(completion:{(respose,error) in
            if error == nil , let resposeDict = respose {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:resposeDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.allTeacherlist.removeAll()
                    for data in itemsJsonArray! {
                        let list = Teacher(fromDictionary:data)
                        self.allTeacherlist.append(list)
                    }
                    Singleton.setUpTableViewDisplay(self.facultyList, headerView:"","SelectStudentTableViewCell")
                    self.facultyList.delegate = self
                     self.facultyList.dataSource = self
                    self.facultyList.bounces = true
                    ProgressLoader.shared.hideLoader()
                }
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allTeacherlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SelectStudentTableViewCell") as? SelectStudentTableViewCell
        cell!.selectionStyle = .none
        cell!.nameLabel.text = self.allTeacherlist[indexPath.row].facultyName
        cell!.studentIDLabel.text  = self.allTeacherlist[indexPath.row].subjectNAme
         
        let teacherImage = UIImage.decodeBase64(toImage:self.allTeacherlist[indexPath.row].profile)
        let imgData = teacherImage.pngData()
        cell?.imageView?.layer.cornerRadius = (cell?.imageView?.bounds.width)!/2.0
        cell?.imageView?.clipsToBounds = true
        
//        if imgData != nil{
//             cell?.imageView?.image = UIImage(data:imgData!)
//        }
//        else{
//            cell?.imageView?.image = #imageLiteral(resourceName: "profile")
//        }
        
        cell?.imageView?.image = #imageLiteral(resourceName: "profile")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "discuss") as! DiscussionViewController
        destViewController.facultyname = self.allTeacherlist[indexPath.row].facultyName 
        destViewController.facultyID = self.allTeacherlist[indexPath.row].teacherRegisrationValue
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    
}
