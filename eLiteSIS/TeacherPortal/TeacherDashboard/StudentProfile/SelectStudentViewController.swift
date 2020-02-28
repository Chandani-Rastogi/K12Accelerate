//
//  SelectStudentViewController.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import  CoreData

class SelectStudentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var selectedStudentNameLabel: UILabel!
    @IBOutlet weak var studentTableView: UITableView!
    
    @IBOutlet weak var selectButton: UIButton!
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    let studentDropdown =  DropDown()
   
    var sectionid : String = ""
    var identifier : String = ""
    var animatedCellIndex = [Int]()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.studentDropdown
        ]
    }()
    
    var getClasses = [Classes]()
    var getAllStudent = [AllStudents]()
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.studentTableView.separatorStyle = .none
        self.selectButton.layer.cornerRadius = 8
        self.selectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.selectButton.layer.borderWidth = 1
        
        self.fetchAllSections()
        getclassesAPI()
        setupDropDowns()
        // Do any additional setup after loading the view.
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
        cell!.nameLabel.text = self.getAllStudent[indexPath.row].contactName
        return cell!
    }
    
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if animatedCellIndex.contains(indexPath.row){
            return
        }
        animatedCellIndex.append(indexPath.row)
        cell.moveInAnimation(forIndex: indexPath.row)
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "studentdashboard") as! StudentFacultyController
        destViewController.regId = self.getAllStudent[indexPath.row].registrationID
        destViewController.studentID = self.getAllStudent[indexPath.row].StudentID
        destViewController.classSession = self.getAllStudent[indexPath.row].currentclasssessionid
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    @IBAction func selectButton(_ sender: Any) {
        studentDropdown.show()
    }
    
    func setupDropDowns() {
         Singleton.customizeDropDown()
        setupTeacherlistDropDown()
    }

    // Mark : DropDown
    func setupTeacherlistDropDown() {
        
        studentDropdown.anchorView = selectButton
        let  sectionID : [String]
        
        let name = (0..<getClasses.count).map { (i) -> String in
            return getClasses[i].sectionName
        }
        sectionID = (0..<getClasses.count).map { (i) -> String in
            return getClasses[i].sectionId }
        
        studentDropdown.dataSource = name
        studentDropdown.bottomOffset = CGPoint(x: 0, y: selectButton.bounds.height)
        // Action triggered on selection
        studentDropdown.selectionAction = { [weak self] (index, item) in
            self?.selectButton.setTitle("", for: .normal)
            self?.selectedStudentNameLabel.text = item
            self?.sectionid = sectionID[index]
            self?.fetchAllstudent(section:self!.sectionid)
            self?.getAllStudents(sectionID: self!.sectionid, sectionName:item)
        }
    }
    
    func getclassesAPI() {
        WebService.shared.GetAllFacultyClasses(registrationValue:UserDefaults.standard.value(forKey:"_sis_registration_value") as? String ?? "", completion:{(response, error) in
            if error == nil , let responseDict = response {
                
                if let classDict = responseDict.arrayObject as? [[String:Any]]{
                    for data in classDict {
                        TeacherCoreDatacontroller.shared.insertAndUpdateClassSections(sectionID:(data["sectionId"] as? String)!, sectionName:(data["sectionName"] as? String)!)
                    }
                    self.fetchAllSections()
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func getAllStudents(sectionID:String,sectionName:String) {
        ProgressLoader.shared.showLoader(withText:"Fetching Student..")
        WebService.shared.Getstudentlistbyclasssession(sectionID:sectionID, completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let studentDict = (responseDict.arrayObject as? [[String:Any]]){
                    for data in studentDict {
                        TeacherCoreDatacontroller.shared.insertOrUpdateAllStudents(studentID:data["StudentID"] as! String, sectionID:sectionID, regID:data["RegistrationID"] as! String, regNAme: data["RegistrationName"] as! String, isPresent:"", name:data["Name"] as! String, ContactID:data["ContactID"] as! String, ContactNAme: data["ContactName"] as! String, SessionID: data["Currentclasssessionid"] as! String, SessionName:data["Currentclasssession"] as! String, entityImage:data["Entityimage"] as? String ?? "" , gender:data["Gender"] as! Int, className:data["Class"] as? String ?? "", sectionName: data["Section"] as? String ?? "")
                        
                    }
                    self.fetchAllstudent(section:sectionID)
                }
                
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchAllSections() {
        
        TeacherCoreDatacontroller.shared.fetchAllClassSections(completion: {(response, error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                var classDict = [[String:Any]]()
                classDict.append(contentsOf:itemsJsonArray!)
                DispatchQueue.main.async {
                    if let dict = classDict as? [[String:Any]]{
                        if dict.count > 0 {
                            self.getClasses.removeAll()
                            for data in classDict {
                                let classes = Classes(data)
                                self.getClasses.append(classes)
                                Singleton.customizeDropDown()
                               self.setupTeacherlistDropDown()
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
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
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
                                
                                Singleton.setUpTableViewDisplay(self.studentTableView, headerView:"dashboardTableViewCell", "SelectStudentTableViewCell")
                                self.studentTableView.delegate = self
                                self.studentTableView.dataSource = self
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
                
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
        })
    }
   
    
 
}
