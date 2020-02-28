//
//  StudentListViewController.swift
//  eLiteSIS
//
//  Created by apar on 15/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class StudentListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var studentList: UITableView!
    @IBOutlet weak var selectSubjectButton: UIButton!
    @IBOutlet weak var emptyImage: UIImageView!
    
    var navTitle : String = ""
    var subjectid : String = ""
    var getClasses = [Classes]()
    var getAllStudent = [AllStudents]()
    var presentStatus : String = ""
     var presentString : String = ""
    
    let SubjectDropdown =  DropDown()
    lazy var subjectDropdown: [DropDown] = {
        return [
            self.SubjectDropdown
        ]
    }()
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navTitle != "Chat" {
            self.title = "Student Information"
        }
        else {
           self.title = navTitle
        }
        self.selectSubjectButton.layer.cornerRadius = 8
        self.selectSubjectButton.layer.borderWidth = 1
        self.selectSubjectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        studentList.separatorColor = .clear
        //Call API
        self.getAllSubjects(facultyID:(UserDefaults.standard.value(forKey:"userID") as? String)!)
         self.emptyImage.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    // Mark : DropDown
    func setupSubjectListDropDown() {
        Singleton.customizeDropDown()
        SubjectDropdown.anchorView = selectSubjectButton
        let  subjectID : [String]
        let name = (0..<getClasses.count).map { (i) -> String in
            return getClasses[i].sectionName }
        subjectID = (0..<getClasses.count).map { (i) -> String in
            return getClasses[i].sectionId }
        SubjectDropdown.dataSource = name
        SubjectDropdown.bottomOffset = CGPoint(x: 0, y: selectSubjectButton.bounds.height)
        // Action triggered on selection
        SubjectDropdown.selectionAction = {[weak self](index, item) in
            self?.selectSubjectButton.setTitle("", for: .normal)
            self?.subjectLabel.text = item
            self?.subjectid = subjectID[index]
            self?.fetchAllstudent(section:self!.subjectid)
        }
    }
    
    
    // Mark : Webservices
    func getAllSubjects(facultyID:String) {
        WebService.shared.GetAllFacultyClasses(registrationValue:(UserDefaults.standard.value(forKey:"userID") as? String)!,completion: {(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"Fetching Subjects")
                if let subjectDict = responseDict.arrayObject as? [[String:Any]]{
                     if subjectDict.count > 0 {
                    for obj in subjectDict {
                       
                            self.studentList.isHidden = false
                            let subject = Classes(obj)
                            self.getClasses.append(subject)
                            self.setupSubjectListDropDown()
                            
                            self.emptyImage.isHidden = true
                        }
                    }
                    else
                    {
                        self.studentList.isHidden = true
                        self.emptyImage.isHidden = false
                    }
                }
            }
            else
            {
               self.studentList.isHidden = true
               self.emptyImage.isHidden = false
            }
            ProgressLoader.shared.hideLoader()
        })
    }
       func getAllStudents(sectionID:String) {
            
            self.getAllStudent.removeAll()
            ProgressLoader.shared.showLoader(withText:"Fetching Student list..")
        
            WebService.shared.Getstudentlistbyclasssession(sectionID:sectionID, completion:{(response, error) in
        if error == nil , let responseDict = response {
            
            if let studentDict = (responseDict.arrayObject as? [[String:Any]]){
                
                print(studentDict)
                for data in studentDict {
                    
                    self.presentString = data["prevAttendance"] as? String ?? ""
                    if self.presentString == "A" {
                        self.presentStatus = "A"
                    }
                    else if self.presentString == "P"
                    {
                        self.presentStatus = "P"
                    }
                    else if self.presentString == "L"
                    {
                        self.presentStatus = "L"
                    }
                    
            TeacherCoreDatacontroller.shared.insertOrUpdateAllStudents(studentID:data["StudentID"] as! String, sectionID:sectionID, regID:data["RegistrationID"] as? String ?? "", regNAme: data["RegistrationName"] as? String ?? "", isPresent:self.presentStatus, name:data["Name"] as? String ?? "", ContactID:data["ContactID"] as? String ?? "", ContactNAme: data["ContactName"] as? String ?? "", SessionID: data["Currentclasssessionid"] as? String ?? "", SessionName:data["Currentclasssession"] as? String ?? "", entityImage:data["Entityimage"] as? String ?? "" , gender:data["Gender"] as? Int ?? 0, className:data["Class"] as? String ?? "" ,sectionName: data["Section"] as? String ?? "")
                }
                self.fetchAllstudent(section:sectionID)
            }
            
        }else{
                    debugPrint(error?.localizedDescription ?? "Invalid User")
                }
                ProgressLoader.shared.hideLoader()
            })
        }
    
    func fetchAllstudent(section:String) {
    
        TeacherCoreDatacontroller.shared.fetchAllStudent(sectionid:section,completion:{(response, error) in
            if error == nil , let responseDict = response {
              
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                var allStudentDict = [[String:Any]]()
                allStudentDict.append(contentsOf:itemsJsonArray!)
                
                DispatchQueue.main.async {
                    
                    if let dict = allStudentDict as? [[String:Any]]{
                        
                        if dict.count > 0 {
                            self.getAllStudent.removeAll()
                            for data in allStudentDict {
                                let student = AllStudents(data)
                                self.getAllStudent.append(student)
                                Singleton.setUpTableViewDisplay(self.studentList, headerView:"dashboardTableViewCell", "SelectStudentTableViewCell")
                                self.studentList.delegate = self
                                self.studentList.dataSource = self
                            }
                            ProgressLoader.shared.hideLoader()
                        }
                        else
                        {
                            ProgressLoader.shared.hideLoader()
                        }
                    }
                }
            }
            else{
                
                ProgressLoader.shared.hideLoader()
                self.getAllStudents(sectionID:section)
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
        })
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 65
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.getAllStudent.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          var cell = tableView.dequeueReusableCell(withIdentifier: "SelectStudentTableViewCell") as? SelectStudentTableViewCell
          cell!.selectionStyle = .none
          cell!.nameLabel.text = self.getAllStudent[indexPath.row].contactName //+ " (" + self.getAllStudent[indexPath.row].className + "-" + self.getAllStudent[indexPath.row].sectionName + ")"
          cell!.studentIDLabel.text  = self.getAllStudent[indexPath.row].registrationName
          if (self.getAllStudent[indexPath.row].gender)  == 2
          {
             cell?.imageView?.image = #imageLiteral(resourceName: "female")
          }
        else
          {
            cell?.imageView?.image = #imageLiteral(resourceName: "profile")
          }
         
          return cell!
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if navTitle != "Chat" {
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "studentdashboard") as! StudentFacultyController
            destViewController.regId = self.getAllStudent[indexPath.row].registrationID
            destViewController.classSession = self.getAllStudent[indexPath.row].currentclasssessionid
            destViewController.studentID = self.getAllStudent[indexPath.row].StudentID
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        else {
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "facultyChat") as! FacultyDiscussionViewController
            destViewController.studentid = self.getAllStudent[indexPath.row].registrationID
            destViewController.studentName = self.getAllStudent[indexPath.row].contactName + " (" + self.getAllStudent[indexPath.row].className + "-" + self.getAllStudent[indexPath.row].sectionName + ")"
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        
    }
    
    @IBAction func subjectButton(_ sender: Any) {
        self.SubjectDropdown.show()
    }
    
}
