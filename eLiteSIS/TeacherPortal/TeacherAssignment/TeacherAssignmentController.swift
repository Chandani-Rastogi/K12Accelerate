//
//  TeacherAssignmentController.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.


import UIKit
import CoreData
import DropDown

struct FacultyPlanLesson {
    
    let sectionId: String!
    let classSessionName: String!
    let sectionName : String!
    let subjectName : String!
    let subjectId : String!
    let faculty :String!
    let lessonPlanId : String!
    let Studyprogress : Double!
    init(_ dict:[String:Any]) {
        sectionId = dict["sectionId"] as? String
        classSessionName = dict["classSessionName"] as? String
        sectionName = dict["sectionName"] as? String
        subjectName = dict["subjectName"] as? String
        subjectId = dict["subjectId"] as? String
        faculty = dict["faculty"] as? String
        lessonPlanId = dict["lessonPlanId"] as? String
        Studyprogress = dict["studyprogress"] as? Double
    }
}

struct GetAssignment {
    
     let name: String!
     let assignationDate : String!
     let submitDate : String!
     let taskStatus : String!
     let assignmentID : String!
     let entityimage : String!
     let  gender : Int!
    
    init(_ dict:[String:Any]) {
        name = dict["name"] as? String
        assignationDate = dict["assignationDate"] as? String
        assignmentID = dict["assignmentID"] as? String
        entityimage = dict["entityimage"] as? String
        submitDate = dict["submitDate"] as? String
        taskStatus = dict["taskStatus"] as? String
        gender = dict["gender"] as? Int
    }
}

class TeacherAssignmentController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var assignmentList: UITableView!
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
   
    var planlist = [FacultyPlanLesson]()
    var assignments = [GetAssignment]()
    let classDropdown =  DropDown()
    var planid : String = ""
    
    lazy var classdropDowns: [DropDown] = {
        return [
            self.classDropdown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetFacultyLessonPlan()
        self.selectButton.layer.cornerRadius = 8
        self.selectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.selectButton.layer.borderWidth = 1
        self.assignmentList.separatorColor = .clear

        // Do any additional setup after loading the view.
    }
    // Mark : DropDown
    func setupStudentlistDropDown() {
          Singleton.customizeDropDown()
        classDropdown.anchorView = selectButton
        
        let  sectionID : [String]
        let name = (0..<planlist.count).map { (i) -> String in
            return planlist[i].subjectName}
        sectionID = (0..<planlist.count).map { (i) -> String in
            return planlist[i].lessonPlanId }
        
        classDropdown.dataSource = name
        classDropdown.bottomOffset = CGPoint(x: 0, y: selectButton.bounds.height)
        
        // Action triggered on selection
        classDropdown.selectionAction = { [weak self] (index, item) in
            self?.selectButton.setTitle("", for: .normal)
            self?.selectLabel.text = item
            self?.planid = sectionID[index]
            self?.GetAllAssignment()
        }
    }
   
    @IBAction func selectButton(_ sender: Any) {
          self.classDropdown.show()
    }

    func GetFacultyLessonPlan() {
        WebService.shared.GetFacultyLessonPlan(registrationValue:"93a60c2b-6d50-e911-a95c-000d3af2cb54",SubjectId:"",completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let scheduleDict = responseDict.arrayObject as? [[String:Any]]{
                    for data in scheduleDict {
                TeacherCoreDatacontroller.shared.insertAndUpdateFacultyLessonPlan(lessonPlanId:(data["LessonPlanId"] as? String)!, jsonObject:[data])
                    }
                    self.fetchFacultyLessonPlans()
                }
            }else{
                 AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "lesson plan not found ")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func GetAllAssignment() {
        WebService.shared.GetTaskAssignment(value:self.planid,completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let scheduleDict = responseDict.arrayObject as? [[String:Any]]{
                    for data in scheduleDict {
                        TeacherCoreDatacontroller.shared.insertAndUpdatetaskAssignments(lessonPlanId:self.planid, jsonObject: [data])
                    }
                    self.fetchtaskAssignments(planId:self.planid)
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? " assignments not found ")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchtaskAssignments(planId:String) {
        TeacherCoreDatacontroller.shared.fetchtaskAssignments(completion:{(response, error) in
            if error == nil , let responseDict = response
            {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                var assignmentsDict = [[String:Any]]()
                assignmentsDict.append(contentsOf:itemsJsonArray!)
                DispatchQueue.main.async {
                    if let dict = assignmentsDict as? [[String:Any]]{
                        self.assignments.removeAll()
                        if dict.count > 0 {
                            for data in assignmentsDict {
                                let assignment = GetAssignment(data)
                                self.assignments.append(assignment)
                                Singleton.setUpTableViewDisplay(self.assignmentList, headerView: "", "TeacherAssignmentCell")
                                self.assignmentList.delegate = self
                                self.assignmentList.dataSource = self
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
                debugPrint(error?.localizedDescription ?? "no task assignments found ")
            }
        } ) 
    }
    
    
    func fetchFacultyLessonPlans() {
        
        TeacherCoreDatacontroller.shared.fetchFacultyLessonPlan(completion: {(response, error) in
            if error == nil , let responseDict = response
            {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                 var lessonPlanDict = [[String:Any]]()
                lessonPlanDict.append(contentsOf:itemsJsonArray!)
                  self.planlist.removeAll()
                DispatchQueue.main.async {
                    if let dict = lessonPlanDict as? [[String:Any]]{
                        if dict.count > 0 {
                            for data in lessonPlanDict {
                              print(data)
                            let plan = FacultyPlanLesson(data)
                            self.planlist.append(plan)
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
                debugPrint(error?.localizedDescription ?? "no faculty plan are found")
            }
        })
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "TeacherAssignmentCell") as? TeacherAssignmentCell
        cell?.nameText.text = self.assignments[indexPath.row].name
        cell?.datetext.text = Date.getFormattedDate(string: (self.assignments[indexPath.row].assignationDate)!, formatter:"dd-MM-YYYY hh:mm:ss")
        cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView.bounds.width)!/2.0
        cell?.profileImageView.clipsToBounds = true
        
        if (self.assignments[indexPath.row].entityimage) != nil {
            let studentImage = UIImage.decodeBase64(toImage:(self.assignments[indexPath.row].entityimage)!)
            let imgData = studentImage.pngData()
            cell?.profileImageView.image = UIImage(data: imgData!)
        }
        else{
            cell?.profileImageView.image = #imageLiteral(resourceName: "profile")
        }
        
       
        cell!.selectionStyle = .none
        return cell!
    }
    
    
}
