//
//  StudyProgressController.swift
//  eLiteSIS
//
//  Created by apar on 13/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import CoreData

struct StudyProgress {
    var newPerformance : Int!
    var sisName : String!
    var sisObtainedmarks : Int!
    var sisTotalmarks : Int!
    var examID : String!
    var marksID : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        newPerformance = dictionary["newPerformance"] as? Int
        sisName = dictionary["name"] as? String
        sisObtainedmarks = dictionary["obtained"] as? Int
        sisTotalmarks = dictionary["totalMarks"] as? Int
        examID = dictionary["examID"] as? String
        marksID = dictionary["marksID"] as? String
    }
}


class StudyProgressController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var selectTest: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var studyProgressTableView: UITableView!
    var marksvalue : String = ""
    var performnceList = [Performance]()
    var studyprogresss = [StudyProgress]()
    let scoreDropdwon =  DropDown()
    var planid : String = ""
    lazy var dropDowns: [DropDown] = {
        return [
            self.scoreDropdwon
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.fetchPerformnaceList()
        self.getPerformanceList()
        testButton.layer.cornerRadius = 5
        testButton.layer.borderWidth = 1
        testButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.studyProgressTableView.separatorColor = .clear
        self.studyProgressTableView.delegate = nil
        self.studyProgressTableView.dataSource = nil
        // Do any additional setup after loading the view.
    }
    
    // Mark : Webservice Call
    func getPerformanceList() {
        
        let studentID = UserDefaults.standard.value(forKey:"sis_studentid") as? String ?? ""
        let currentsession = UserDefaults.standard.value(forKey: "_sis_currentclasssession_value") as? String ?? ""
        let sectionValue = UserDefaults.standard.value(forKey:"_sis_section_value") as? String ?? ""
        
        WebService.shared.getPerformanceList(studentID:studentID, currentclasssession:currentsession, sectionValue:sectionValue,completion:{(response, error) in
            self.performnceList.removeAll()
            if error == nil , let responseDict = response {
                if let performanceDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in performanceDict {
                CoreDataController.sharedInstance.insertAndUpdateStudentPerformance(marksID:(obj["sis_classsessionwisemarksid"] as? String)!, jsonObject:[obj])
                    }
                    self.fetchPerformnaceList()
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Pinboard data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchPerformnaceList() {
        CoreDataController.sharedInstance.fetchStudentPerformanceRequest(completion:{(respose,error) in
                if error == nil , let resposeDict = respose {
                    let itemsJsonArray = (Singleton.convertToJSONArray(moArray:resposeDict as! [NSManagedObject])) as? [[String:Any]]
                    if itemsJsonArray!.count > 0 {
                        self.performnceList.removeAll()
                        for obj in itemsJsonArray! {
                                let performnace = Performance(obj)
                                self.performnceList.append(performnace)
                                self.setupScoreDropDown()
                            }
                        
                    }
            }
                else{
                    self.getPerformanceList()
                   debugPrint(error?.localizedDescription ?? "PerformnaceList Not Found")
            }
        })
    }
    
    func getstudyProgress(_ marksValue:String) {
        WebService.shared.GetStudyProgress(currentclasssessionmarksid:self.marksvalue ,completion:{(response, error) in
            self.studyprogresss.removeAll()
            if error == nil , let responseDict = response {
                if let performanceDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    
                    for obj in performanceDict {
                        let exam = obj["sis_Examination"] as? [String:Any]
                        CoreDataController.sharedInstance.insertAndUpdateStudentStudyProgress(marksID:self.marksvalue, examID:(exam!["sis_examinationid"] as? String)!, jsonObject:[obj])

                    }
                    self.fetchstudyProgress(self.marksvalue)
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Study Progress data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchstudyProgress(_ marksValue:String) {
        CoreDataController.sharedInstance.fetchStudentStudyProgressRequest(marksID:marksvalue, completion:{(respose,error) in
            if error == nil , let resposeDict = respose {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:resposeDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.studyprogresss.removeAll()
                        for obj in itemsJsonArray! {
                            let progress = StudyProgress(fromDictionary: obj)
                            self.studyprogresss.append(progress)
                        }
                        
                        Singleton.setUpTableViewDisplay(self.studyProgressTableView, headerView: "StudyProgessHeaderView","StudyProgressCell")
                        self.studyProgressTableView.delegate = self
                        self.studyProgressTableView.dataSource = self
                    }
                }
            else{
                    self.getstudyProgress(self.marksvalue ?? "")
                    debugPrint(error?.localizedDescription ?? "Study Progress Not Found")
                }
            })
    }
    // Mark : DropDown
    func setupScoreDropDown() {
         Singleton.customizeDropDown()
        scoreDropdwon.anchorView = testButton
        let  marksid : [String]
    
        let name = (0..<performnceList.count).map { (i) -> String in
            return performnceList[i].examtype
        }
        print(name)
        
        marksid = (0..<performnceList.count).map { (i) -> String in
            return performnceList[i].markdID
        }
        scoreDropdwon.dataSource = name
        scoreDropdwon.bottomOffset = CGPoint(x: 0, y: testButton.bounds.height)
        
        // Action triggered on selection
        scoreDropdwon.selectionAction = { [weak self] (index, item) in
            self?.testButton.setTitle("", for: .normal)
            self?.selectTest.text = item
            self?.marksvalue = marksid[index]
            self?.fetchstudyProgress(self?.marksvalue ?? "")
            self?.getstudyProgress(self?.marksvalue ?? "")
           
        }
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
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.subjectLabel.text = self.studyprogresss[indexPath.row].sisName
        cell.percentageLabel.text = String(self.studyprogresss[indexPath.row].sisObtainedmarks) + " % "
        let percetage = self.studyprogresss[indexPath.row].newPerformance
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chapter") as? ChapterViewController{
            vc.examinationId = self.studyprogresss[indexPath.row].examID ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func selectTest(_ sender: Any) {
        scoreDropdwon.show()
    }
  
}
