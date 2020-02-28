//
//  StudentAttandanceController.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class List {
    let studentID : String
    let ispresent : String
    
    init(studentID : String, present: String) {
        self.studentID = studentID
        self.ispresent = present
    }
}

struct Classes {
     let sectionName : String!
    let sectionId : String!
    init(_ dict:[String:Any]) {
        sectionName = dict["sectionName"] as? String
        sectionId = dict["sectionId"] as? String
        
    }
}

struct AllStudents {
    let StudentID : String!
    let sectionID : String!
    let isPresent : String!
    let registrationID : String!
    let registrationName : String!
    let name : String!
    let contactID : String!
    let contactName : String!
    let currentclasssession : String!
    let currentclasssessionid : String!
    let entityimage : String!
    let gender : Int
    let attendanceDate : String!
    let className :String!
    let sectionName : String!
    
    
    
    init(_ dict:[String:Any]) {
        
        StudentID = dict["studentID"] as? String
        sectionID = dict["sectionID"] as? String
        isPresent = dict["isPresent"] as? String
        registrationID = dict["registrationID"] as? String
        registrationName = dict["registrationName"] as? String
        name = dict["name"] as? String
        contactID = dict["contactID"] as? String
        contactName = dict["contactName"] as? String
        currentclasssession = dict["currentclasssession"] as? String
        currentclasssessionid = dict["currentclasssessionid"] as? String
        entityimage = dict["entityimage"] as? String
        gender = (dict["gender"] as? Int)!
        attendanceDate = dict["attendancedate"] as? String
        className = dict["classname"] as? String
        sectionName = dict["sectionname"] as? String
    }
}


class StudentAttandanceController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var studentList: UITableView!
    @IBOutlet weak var emptyData: UIImageView!
    
    var dicSet : NSMutableDictionary!
    var dateString : String = ""
    var jsonlist : [List] = []
    let classDropdown =  DropDown()
    var sectionid : String = ""
    var presentStatus : String = ""
    var presentString : String = ""
    
    lazy var classdropDowns: [DropDown] = {
        return [
            self.classDropdown
        ]
    }()
    
    let date = Date()
    let formatter = DateFormatter()
    
    var getClasses = [Classes]()
    var getAllStudent = [AllStudents]()
    var animatedCellIndex = [Int]()
    
    
    var dictionary = [String:Any]()
    var dictionaryTosend = [[String:Any]]()
    
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emptyData.isHidden = true
        self.selectButton.layer.cornerRadius = 8
        self.selectButton.layer.borderColor = #colorLiteral(red: 0.05941096693, green: 0.4214978814, blue: 0.7516218424, alpha: 1)
        self.selectButton.layer.borderWidth = 1
        self.studentList.separatorStyle = .none
        self.studentList.delegate = nil
        self.studentList.dataSource = nil
        //Call API
        //self.fetchAllSections()
        getclassesAPI()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        let serverString = formatter.string(from:date)
       
        
        if (UserDefaults.standard.value(forKey:"Date") as? String) != serverString {
            UserDefaults.standard.set(false, forKey:"AttendanceMarked")
        }
        
        self.button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        self.button.setTitle("Save", for: .normal)
        
    }
    
    // Mark : DropDown
    func setupStudentlistDropDown() {
        Singleton.customizeDropDown()
        classDropdown.anchorView = selectButton
        let  sectionID : [String]
        let name = (0..<getClasses.count).map { (i) -> String in
            return getClasses[i].sectionName }
        sectionID = (0..<getClasses.count).map { (i) -> String in
            return getClasses[i].sectionId }
        classDropdown.dataSource = name
        classDropdown.bottomOffset = CGPoint(x: 0, y: selectButton.bounds.height)
        
        if name.count < 2 {
            
            classDropdown.selectRow(at: 0)
            self.selectButton.setTitle("", for: .normal)
            self.classLabel.text = name[0]
            self.sectionid = sectionID[0]
            
            self.getAllStudents(sectionID:self.sectionid)
            self.fetchAllstudent(section:self.sectionid)
        }
        else {
            // Action triggered on selection
                   classDropdown.selectionAction = {[weak self](index, item) in
                       self?.selectButton.setTitle("", for: .normal)
                       self?.classLabel.text = item
                       self?.sectionid = sectionID[index]
                       
                       self?.getAllStudents(sectionID:self!.sectionid)
                       self?.fetchAllstudent(section:self!.sectionid)
                       //
                   }
        }
        
       
    }
    func setUpTableViewDisplay() {
        
        self.studentList.separatorStyle = .none
        self.studentList.scrollsToTop = false
        self.studentList.bounces = false
        self.studentList.register(UINib(nibName:"StudentHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "StudentHeaderView")
        self.studentList.register(UINib(nibName:"Student_AttendanceCell", bundle: nil), forCellReuseIdentifier: "Student_AttendanceCell")
        self.studentList.delegate = self
        self.studentList.dataSource = self
        if UserDefaults.standard.value(forKey:"new_rolecode") as? String == "212" {

        }
        else {
            let customView = UIView(frame: CGRect(x:7, y: 0, width: 200, height: 50))
            customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button = UIButton(frame: CGRect(x:self.studentList.frame.width/2 - 50, y:5, width:120, height: 40))
            button.setTitle("Save", for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize:12)
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            button.layer.cornerRadius = 15
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            customView.addSubview(button)
            self.studentList.tableFooterView = customView
        }
        
        self.reload(tableView:self.studentList)
        
    }
    @objc func buttonAction(_ sender: UIButton!) {
        self.postAttendance(savedDateString:self.dateString)
    }
    
    func postAttendance(savedDateString:String) {
        
    //    self.button.isUserInteractionEnabled =  false
        formatter.dateFormat = "dd.MM.yyyy"
        let resultString = formatter.string(from:date)
        
        if UserDefaults.standard.bool(forKey:"AttendanceMarked") == true {
            
            if resultString == savedDateString {
                       let alert = UIAlertController(title: "Update Attendance", message: "Attendance is already saved.\n Do you want to Update?", preferredStyle: .alert)
                       let okButton = UIAlertAction(title: "Yes", style: .default, handler: { action in
                           self.postAttendance()
                       })
                       alert.addAction(okButton)
                       let cancel = UIAlertAction(title: "No", style: .default, handler: { action in
                           self.button.isUserInteractionEnabled =  true
                       })
                       alert.addAction(cancel)
                       DispatchQueue.main.async(execute: {
                           self.present(alert, animated: true)
                       })
                   }
            else {
                self.postAttendance()
            }
            
        }
            
        else
        {
            self.postAttendance()
        }
        
        
    }
    
    func postAttendance(){
        print(self.dictionaryTosend)
        ProgressLoader.shared.showLoader(withText:"Attendance Uploading..... ")
        formatter.dateFormat = "dd/MM/yyy"
        let serverString = formatter.string(from:date)
        WebService.shared.postAttendencebyFaculty(date:serverString, sectionValue:self.sectionid, studentlist:self.dictionaryTosend,completion: {(response, error ) in
            if error == nil, let responseDict = response {
                print(responseDict)
                if responseDict == "Process is been successfull" {
                    ProgressLoader.shared.hideLoader()
                    
                    let alert = UIAlertController(title: "", message: "Attendance uploaded successfully!!", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.button.isUserInteractionEnabled =  true
                        self.button.backgroundColor = #colorLiteral(red: 0.5254901961, green: 0.7568627451, blue: 0.4784313725, alpha: 1)
                        self.button.setTitle("Success", for: .normal)
                        UserDefaults.standard.set(true, forKey:"AttendanceMarked")
                        UserDefaults.standard.set(serverString, forKey:"Date")
                    })
                    alert.addAction(okButton)
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true)
                    })
                }
                else if responseDict["ErrorMessage"] == "Server error. Please contact Admin!!" {
                     ProgressLoader.shared.hideLoader()
                    let alert = UIAlertController(title: "ErrorMessage", message: "Server error. Please contact Admin!!", preferredStyle: .alert)
                                     let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                                         self.button.isUserInteractionEnabled =  true
                                         self.button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                                         self.button.setTitle("Save", for: .normal)
                                     })
                                     alert.addAction(okButton)
                                     DispatchQueue.main.async(execute: {
                                         self.present(alert, animated: true)
                                     })
                }
            } else {
                
                 print(response)
                 print(self.dictionaryTosend)
                 self.button.backgroundColor = #colorLiteral(red: 0.5254901961, green: 0.7568627451, blue: 0.4784313725, alpha: 1)
                 self.button.setTitle("Success", for: .normal)
                 self.button.isUserInteractionEnabled =  true
                 ProgressLoader.shared.hideLoader()
            }
        })
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.getAllStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"Student_AttendanceCell") as? Student_AttendanceCell
        cell?.absentbutton.isIconSquare = false
        cell?.presentButton.isIconSquare = false
        cell?.leavebutton.isIconSquare = false
        cell?.presentButton.tag = indexPath.row
        cell?.absentbutton.tag = indexPath.row
        cell?.leavebutton.tag = indexPath.row
        cell?.presentButton.addTarget(self, action: #selector(clickOnPresent), for: .touchUpInside)
        cell?.absentbutton.addTarget(self, action: #selector(clickOnAbsent), for: .touchUpInside)
        cell?.leavebutton.addTarget(self, action: #selector(clickOnLeave), for: .touchUpInside)
       
        if (self.getAllStudent[indexPath.row].isPresent) as String == "P"
        {
            cell?.presentButton.isSelected = true
            cell?.absentbutton.isSelected = false
            cell?.leavebutton.isSelected = false
            
        }
        else if (self.getAllStudent[indexPath.row].isPresent) as String == "A"
        {
            cell?.absentbutton.isSelected = true
            cell?.presentButton.isSelected = false
            cell?.leavebutton.isSelected = false
        }
        else if (self.getAllStudent[indexPath.row].isPresent) as String == "L"
        {
            cell?.leavebutton.isSelected = true
            cell?.absentbutton.isSelected = false
            cell?.presentButton.isSelected = false
        }
        self.dateString = self.getAllStudent[indexPath.row].attendanceDate
        cell?.studentName.text = self.getAllStudent[indexPath.row].contactName
        cell!.selectionStyle = .none
        return cell!
    }
    
    func reload(tableView: UITableView) {
        
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    @objc func clickOnPresent(sender: UIButton) {
        let indexpath = sender.tag
        TeacherCoreDatacontroller.shared.insertOrUpdateAllStudents(studentID:self.getAllStudent[indexpath].StudentID, sectionID:self.getAllStudent[indexpath].sectionID, regID:self.getAllStudent[indexpath].registrationID, regNAme:self.getAllStudent[indexpath].registrationName, isPresent:"P", name:self.getAllStudent[indexpath].name, ContactID:self.getAllStudent[indexpath].contactID, ContactNAme:self.getAllStudent[indexpath].contactName, SessionID:self.getAllStudent[indexpath].currentclasssessionid, SessionName:self.getAllStudent[indexpath].currentclasssessionid, entityImage:self.getAllStudent[indexpath].entityimage , gender:self.getAllStudent[indexpath].gender, className:self.getAllStudent[indexpath].className, sectionName:self.getAllStudent[indexpath].sectionName)
         
        self.fetchAllstudent(section:sectionid)
        animatedCellIndex = []
        let list = List(studentID : self.getAllStudent[indexpath].StudentID, present:"P")
        jsonlist.append(list)
        self.savedDictioanry(Students:jsonlist)
    }
    
    
    @objc func clickOnLeave(sender: UIButton) {
        
        let indexpath = sender.tag
        TeacherCoreDatacontroller.shared.insertOrUpdateAllStudents(studentID:self.getAllStudent[indexpath].StudentID, sectionID:self.getAllStudent[indexpath].sectionID, regID:self.getAllStudent[indexpath].registrationID, regNAme:self.getAllStudent[indexpath].registrationName, isPresent:"L", name:self.getAllStudent[indexpath].name, ContactID:self.getAllStudent[indexpath].contactID, ContactNAme:self.getAllStudent[indexpath].contactName, SessionID:self.getAllStudent[indexpath].currentclasssessionid, SessionName:self.getAllStudent[indexpath].currentclasssessionid, entityImage:self.getAllStudent[indexpath].entityimage , gender:self.getAllStudent[indexpath].gender, className: self.getAllStudent[indexpath].className, sectionName:self.getAllStudent[indexpath].sectionName)
        
        animatedCellIndex = []
        
        self.fetchAllstudent(section:sectionid)

    }
    
    @objc func clickOnAbsent(sender: UIButton) {
        let indexpath = sender.tag
        TeacherCoreDatacontroller.shared.insertOrUpdateAllStudents(studentID:self.getAllStudent[indexpath].StudentID, sectionID:self.getAllStudent[indexpath].sectionID, regID:self.getAllStudent[indexpath].registrationID, regNAme:self.getAllStudent[indexpath].registrationName, isPresent:"A", name:self.getAllStudent[indexpath].name, ContactID:self.getAllStudent[indexpath].contactID, ContactNAme:self.getAllStudent[indexpath].contactName, SessionID:self.getAllStudent[indexpath].currentclasssessionid, SessionName:self.getAllStudent[indexpath].currentclasssessionid, entityImage:self.getAllStudent[indexpath].entityimage , gender:self.getAllStudent[indexpath].gender, className: self.getAllStudent[indexpath].className, sectionName:self.getAllStudent[indexpath].sectionName)
        
        
        animatedCellIndex = []
        
        self.fetchAllstudent(section:sectionid)
    }
    
    func savedDictioanry(Students: [List])
    {
        for studentEntry in Students {
            dictionary = ["studentID" : studentEntry.studentID,
                          "AttendanceStatus" : studentEntry.ispresent
                ] as [String : Any]
        }
  
        
        dictionaryTosend.append(dictionary)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StudentHeaderView") as! StudentHeaderView
        return viewHeader
    }
    
    func getclassesAPI() {
        WebService.shared.GetAllFacultyClasses(registrationValue:(UserDefaults.standard.value(forKey:"userID") as? String)!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let classDict = responseDict.arrayObject as? [[String:Any]]{
                    if classDict.count > 0 {
                        for data in classDict {
                            self.studentList.isHidden = false
                            let classes = Classes(data)
                            self.getClasses.append(classes)
                            self.setupStudentlistDropDown()
                            self.emptyData.isHidden = true
                        }
                    }
                    else
                    {
                        self.studentList.isHidden = true
                        self.emptyData.isHidden = false
                    }
                }
            }else{
                self.studentList.isHidden = true
                self.emptyData.isHidden = false
               
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func getAllStudents(sectionID:String) {
        
        self.getAllStudent.removeAll()
        ProgressLoader.shared.showLoader(withText:"Fetching Student list..")
        WebService.shared.Getstudentlistbyclasssession(sectionID:sectionID, completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let studentDict = (responseDict.arrayObject as? [[String:Any]])
                {
                    for data in studentDict {
                        
                        self.presentString = data["prevAttendance"] as? String ?? ""
                        if self.presentString == "A" {
                            self.presentStatus = "A"
                        }
                        else if self.presentString == "P"
                        {
                            self.presentStatus = "P"
                        }
                        else if self.presentString == "U"
                        {
                           self.presentStatus = "P"
                        }
                        else if self.presentString == "L"
                        {
                            self.presentStatus = "L"
                        }
                        
                        TeacherCoreDatacontroller.shared.insertOrUpdateAllStudents(studentID:data["StudentID"] as! String, sectionID:sectionID, regID:data["RegistrationID"] as! String, regNAme: data["RegistrationName"] as! String, isPresent:self.presentStatus, name:data["Name"] as! String, ContactID:data["ContactID"] as! String, ContactNAme: data["ContactName"] as! String, SessionID: data["Currentclasssessionid"] as! String, SessionName:data["Currentclasssession"] as! String, entityImage:data["Entityimage"] as? String ?? "" , gender:data["Gender"] as! Int, className:data["Class"] as? String ?? "", sectionName:data["Section"] as? String ?? "")
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
    
    func fetchAllstudent(section:String) {
        
        TeacherCoreDatacontroller.shared.fetchAllStudent(sectionid:section,completion:{(response, error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                var allStudentDict = [[String:Any]]()
                allStudentDict.append(contentsOf:itemsJsonArray!)
                
                DispatchQueue.main.async {
                    if let dict = allStudentDict as? [[String:Any]]{
                        self.dictionaryTosend.removeAll()
                        self.getAllStudent.removeAll()
                        if dict.count > 0 {
                            for data in allStudentDict {
                                let student = AllStudents(data)
                                self.getAllStudent.append(student)
                                self.setUpTableViewDisplay()
                                self.animatedCellIndex = []
                                let list = List(studentID : student.StudentID, present:student.isPresent)
                                self.jsonlist.append(list)
                                self.savedDictioanry(Students:self.jsonlist)
                            }
                        }
                        else
                        {
                            ProgressLoader.shared.hideLoader()
                        }
                    }
                }
            }
            else{
                self.getAllStudents(sectionID:self.sectionid)
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
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
                                self.setupStudentlistDropDown()
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
    
    
    @IBAction func selectButton(_ sender: Any) {
        self.classDropdown.show()
    }
}
