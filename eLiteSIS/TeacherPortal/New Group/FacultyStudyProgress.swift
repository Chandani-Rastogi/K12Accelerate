//
//  FacultyStudyProgress.swift
//  eLiteSIS
//
//  Created by apar on 30/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import CoreData

struct FacultyProgress {
    let sectionId : String!
    let classSessionName : String!
    let sectionName : String!
    let SubjectName : String!
    let SubjectId : String!
    let Faculty : String!
    let LessonPlanId : String!
    let Studyprogress : Double!
    
    init(_ dict : [String:Any]) {
        sectionId = dict["sectionId"] as? String
        classSessionName = dict["classSessionName"] as? String
        sectionName = dict["sectionName"] as? String
        SubjectName = dict["subjectName"] as? String
        SubjectId = dict["subjectId"] as? String
        Faculty = dict["faculty"] as? String
        LessonPlanId = dict["lessonPlanId"] as? String
        Studyprogress = dict["studyprogress"] as? Double
        
    }
}

class FacultyStudyProgress: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var studyProgressTable: UITableView!
    @IBOutlet weak var selectTest: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    let subjectDropdown =  DropDown()
    var subject : String = ""
     var planlist = [FacultyPlanLesson]()
    var studyprogresss = [FacultyProgress]()
    lazy var dropDowns: [DropDown] = {
        return [
            self.subjectDropdown
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        testButton.layer.cornerRadius = 5
        testButton.layer.borderWidth = 1
        testButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.studyProgressTable.separatorColor = .clear
        self.studyProgressTable.delegate = nil
        self.studyProgressTable.dataSource = nil
       self.fetchFacultyProgress(subID:"")
        GetFacultyLessonPlan(subjectID:"")
    }
    
    @IBAction func selectTest(_ sender: Any) {
        subjectDropdown.show()
    }
    
    // Mark : DropDown
    func setupScoreDropDown() {
        Singleton.customizeDropDown()
        subjectDropdown.anchorView = testButton
        let  subjectID : [String]
        let name = (0..<planlist.count).map { (i) -> String in
            return planlist[i].subjectName}
        subjectID = (0..<planlist.count).map { (i) -> String in
            return planlist[i].subjectId }
        subjectDropdown.dataSource = name
        subjectDropdown.bottomOffset = CGPoint(x: 0, y: testButton.bounds.height)
        
        // Action triggered on selection
        subjectDropdown.selectionAction = { [weak self] (index, item) in
            self?.testButton.setTitle("", for: .normal)
            self?.selectTest.text = item
            self?.subject = subjectID[index]
            self?.GetFacultyLessonPlan(subjectID:self?.subject ?? "")
            self?.fetchFacultyProgress(subID:self?.subject ?? "")
        }
    }

    // MARK: - Table view data source
    func setUpTableViewDisplay() {
        self.studyProgressTable.separatorStyle = .none
        self.studyProgressTable.scrollsToTop = false
        self.studyProgressTable.bounces = false
        self.studyProgressTable.sectionHeaderHeight = UITableView.automaticDimension
        self.studyProgressTable.register(UINib(nibName:"StudyProgressCell", bundle: nil), forCellReuseIdentifier: "StudyProgressCell")
        self.studyProgressTable.register(UINib(nibName:"StudyProgessHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier:"StudyProgessHeaderView")
        self.studyProgressTable.delegate = self
        self.studyProgressTable.dataSource = self
        self.studyProgressTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studyprogresss.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StudyProgessHeaderView") as! StudyProgessHeaderView
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"StudyProgressCell") as! StudyProgressCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.subjectLabel.text = self.studyprogresss[indexPath.row].SubjectName
        cell.percentageLabel.text = String(self.studyprogresss[indexPath.row].Studyprogress) + " % "
        let percetage = self.studyprogresss[indexPath.row].Studyprogress
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            cell.showProgress.value = CGFloat(percetage ?? 0 )
            cell.showProgress.progressColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0.2549019608, alpha: 1)
        }, completion: { finished in
        })
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func GetFacultyLessonPlan(subjectID:String) {
        
        WebService.shared.GetFacultyLessonPlan(registrationValue:"93a60c2b-6d50-e911-a95c-000d3af2cb54",SubjectId:subjectID,completion:{
            (response, error) in
            if error == nil , let responseDict = response {
                if let scheduleDict = responseDict.arrayObject as? [[String:Any]]{
                    for data in scheduleDict {
                        if subjectID.count == 0 {
                      TeacherCoreDatacontroller.shared.insertAndUpdateFacultyLessonPlan(lessonPlanId:(data["LessonPlanId"] as? String)!, jsonObject:[data])
                        }
                        else{
                            TeacherCoreDatacontroller.shared.insertAndUpdateFacultyStudyProgress(SubjectId:subjectID, jsonObject:[data])
                        }
                    }
                  
                    self.fetchFacultyProgress(subID:subjectID)
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
 
    func fetchFacultyProgress(subID:String) {
         if subID.count == 0 {
        TeacherCoreDatacontroller.shared.fetchFacultyLessonPlan(completion: {(response, error) in
            if error == nil , let responseDict = response
            {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                var lessonPlanDict = [[String:Any]]()
                lessonPlanDict.append(contentsOf:itemsJsonArray!)
                DispatchQueue.main.async {
                    self.planlist.removeAll()
                    if let dict = lessonPlanDict as? [[String:Any]]{
                        if dict.count > 0 {
                            for data in lessonPlanDict {
                                print(data)
                                let plan = FacultyPlanLesson(data)
                                self.planlist.append(plan)
                                self.setupScoreDropDown()
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
         else
         {
            TeacherCoreDatacontroller.shared.fetchFacultyStudyProgress(subjectID:subID,completion: {(response, error) in
                if error == nil , let responseDict = response
                {
                    let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                    var lessonPlanDict = [[String:Any]]()
                    lessonPlanDict.append(contentsOf:itemsJsonArray!)
                    DispatchQueue.main.async {
                        self.studyprogresss.removeAll()
                        if let dict = lessonPlanDict as? [[String:Any]]{
                            if dict.count > 0 {
                                for data in lessonPlanDict {
                                    let plan = FacultyProgress(data)
                                    self.studyprogresss.append(plan)
                                    self.setUpTableViewDisplay()
                                    
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
}
