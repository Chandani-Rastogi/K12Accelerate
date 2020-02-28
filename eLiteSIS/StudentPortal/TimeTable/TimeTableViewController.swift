//
//  TimeTableViewController.swift
//  eLiteSIS
//
//  Created by apar on 16/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import UserNotifications
import CoreData

struct TimeTable{
    
    var newClasssessionValue : String!
    var newClasstaken : String!
    var newClasstakenValue : String!
    var newEndtime : String!
    var newStartdate : String!
    var newSubject : String!
    var subjectValue : String!
    var startDate : Date = Date()
    var notify : Bool
    
 
    init(fromDictionary dictionary: [String:Any]) {
        
        newClasssessionValue = dictionary["newClasssessionValue"] as? String
        newClasstaken = dictionary["newClasstaken"] as? String
        newClasstakenValue = dictionary["newClasstakenValue"] as? String
        newEndtime = dictionary["newEndtime"] as? String
        newStartdate = dictionary["newStartdate"] as? String
        startDate = (dictionary["startDate"] as? Date)!
        newSubject = dictionary["sisName"] as? String
        subjectValue = dictionary["sisValue"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let startdate = dateFormatter.date(from:(dictionary["newStartdate"] as? String)!) {
            self.startDate = startdate
        }
        notify = dictionary["notify"] as! Bool
        
    }
    

}

class TimeTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var timeTableView: UITableView!
    
    var timetablelist = [TimeTable]()
    var timeTableDict = [[String:Any]]()
    
    var monthArray = [String]()
    var subjectArray = [String]()
    var teacherArrya = [String]()
    
    var monthName : String = ""
    var facultyString : String = ""
    var subjectString : String = ""
    var indexDate : String = ""
    
   
    
    let filterDropdwon = DropDown()
    let monthDropDown =  DropDown()
    let subjectDropDown = DropDown()
    let teacherDropDown = DropDown()
    
    
   
    lazy var dropDowns: [DropDown] = {
        return [
            self.filterDropdwon,
            self.monthDropDown,
            self.subjectDropDown,
            self.teacherDropDown
        ]
    }()
    
    fileprivate func firstDayOfMonth(date : Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month , .day], from: date)
        return calendar.date(from: components)!
    }
    
    var sections = [TableSection<Date, TimeTable>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeTableView.dataSource = nil
        self.timeTableView.delegate = nil
        self.timeTableView.backgroundColor = .white
        self.timeTableView.separatorStyle = .none
        setupFilterDropDown()
        Singleton.customizeDropDown()
        
        self.fetchtimeTableFromDatabase(SubjectName:"", MonthName:"", FacultyName:"")
        // Do any additional setup after loading the view.
    }
    
    func fetchtimeTableFromDatabase(SubjectName : String,MonthName:String,FacultyName:String){
        CoreDataController.sharedInstance.fetchtimetableRequest(subjectString:SubjectName, monthString:MonthName, facultyString:FacultyName, completion:{(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"fetching time table data ...")
                
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                var TableDict = [[String:Any]]()
                TableDict.append(contentsOf:itemsJsonArray!)
                DispatchQueue.main.async {
                    
                    if let timeTableDict = TableDict as? [[String:Any]]{
                        
                        if timeTableDict.count > 0 {
                            self.timetablelist.removeAll()
                            for obj in timeTableDict {
                                
                                let timeTable = TimeTable(fromDictionary: obj)
                                self.timetablelist.append(timeTable)
                                self.timetablelist.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
                                self.timetablelist.reverse()
                                self.monthArray.append(Date.getFormattedDate(string:timeTable.newStartdate, formatter:"MMM-yyyy"))
                                self.subjectArray.append(timeTable.newSubject)
                                self.teacherArrya.append(timeTable.newClasstaken)
                            
                            }
                            self.sections = TableSection.group(rowItems: self.timetablelist, by: { (timeTable) in
                                return self.firstDayOfMonth(date:timeTable.startDate)
                            })
                           
                            Singleton.setUpTableViewDisplay(self.timeTableView, headerView:"", "TimeTableViewCell")
                            self.timeTableView.delegate = self
                            self.timeTableView.dataSource = self
                            self.setUpMonthfilterDropDown()
                            self.setUpsubjectDropDown()
                            self.setUpteacherdropDown()
                             ProgressLoader.shared.hideLoader()
                        }
                        else
                        {
                            print("******************************")
                            self.fetchTimeTable()
                             ProgressLoader.shared.hideLoader()
                        }
                    }
                }
                
            }else{
                
                 ProgressLoader.shared.hideLoader()
                   self.fetchTimeTable()
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
        })
        
      
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
       return self.sections.count
    }
    
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        let section = self.sections[section]
        let date = section.sectionItem
        let dateFormatter = DateFormatter() 
        dateFormatter.dateFormat = "dd-MMM-YYYY"
    
       return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sections.count == 0 {
            Singleton.returnlabel("No Time Table Data", self.timeTableView)
        }
        else{
            let section = self.sections[section]
            return section.rowItems.count
        }
       return 0
       
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TimeTableViewCell") as! TimeTableViewCell
      cell.selectionStyle = .none
        
        let section = self.sections[indexPath.section]
        
       let  headline = section.rowItems[indexPath.row]
      
        let startDate = Date.getFormattedDate(string:headline.newStartdate, formatter:"hh:mm a")
        let endDate = Date.getFormattedDate(string:headline.newEndtime, formatter:"hh:mm a")
        let origImage = #imageLiteral(resourceName: "notification-bell")
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        cell.notificationButton.setImage(tintedImage, for: .normal)
      
        if headline.notify == false{
            cell.notificationButton.tintColor = .lightGray
            cell.notificationButton.tag = indexPath.row
            cell.notificationButton.addTarget(self, action: #selector(clickOnNotification), for: .touchUpInside)
        }
        else if headline.notify == true
        {
           let origImage = #imageLiteral(resourceName: "notification-bell")
          cell.notificationButton.setImage(origImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
       
        cell.startTime?.text = startDate
        cell.endTime.text = endDate
        indexDate = headline.newStartdate
        cell.classText.text = headline.newSubject
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cell = self.timeTableView.cellForRow(at:indexPath)
        print(indexPath.row)
    
    }
    
    @objc func clickOnNotification(sender: UIButton) {
        
        let buttonRow = sender.tag
        print("indexpath ************* ",buttonRow as Any)
        
        sender.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration:1.0, delay:0.5,usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 10, options:UIView.AnimationOptions.curveLinear, animations:{
                        let origImage = #imageLiteral(resourceName: "notification-bell")
                        let tintedImage = origImage.withRenderingMode(.alwaysOriginal)
                        sender.setImage(tintedImage, for: .normal)
                        sender.transform = CGAffineTransform.identity
                        
        }, completion:nil)
        
    
        print(indexDate)
       CoreDataController.sharedInstance.insertAndUpdatetimeTable(startDate:indexDate, notify:true, jsonObject:timeTableDict)
        
    }
    
 
    // Mark : Webservice Call
    func fetchTimeTable() {
        
        let currentsession = UserDefaults.standard.value(forKey: "_sis_currentclasssession_value") as? String ?? ""
        let sectionValue = UserDefaults.standard.value(forKey:"_sis_section_value") as? String ?? ""
        
        ProgressLoader.shared.showLoader(withText:"fetching time table data ...")
        
        WebService.shared.GetTimeTable(currentclasssession:currentsession, sectionValue:sectionValue, completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.timeTableDict = (responseDict["value"].arrayObject as? [[String:Any]])!
                CoreDataController.sharedInstance.insertAndUpdatetimeTable(startDate:"", notify: false, jsonObject:self.timeTableDict)
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching time table data")
                ProgressLoader.shared.hideLoader()
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    @IBAction func filterBtn(_ sender: Any) {
        filterDropdwon.selectionAction = { (index: Int, item: String) in
            // do action
            if  "\(item)" == "Month" {
        
               let unique = Array(Set(self.monthArray))
                self.monthDropDown.dataSource = unique
                self.monthDropDown.selectionAction = { (index: Int, item: String) in
                    // do action
                self.monthName = item
                self.fetchtimeTableFromDatabase(SubjectName:self.subjectString, MonthName:self.monthName,FacultyName:self.facultyString)
                }
                self.monthDropDown.width = 140
                self.monthDropDown.bottomOffset = CGPoint(x: 0, y:(self.monthDropDown.anchorView?.plainView.bounds.height)!)
                self.monthDropDown.show()
            }
            
            if "\(item)" == "Teacher"{
                let unique = Array(Set(self.teacherArrya))
                self.teacherDropDown.dataSource = unique
                self.teacherDropDown.selectionAction = { (index: Int, item: String) in
                    // do action
                    self.facultyString = item
                    self.fetchtimeTableFromDatabase(SubjectName:self.subjectString, MonthName:self.monthName, FacultyName:self.facultyString)
                }
                self.teacherDropDown.width = 140
                self.teacherDropDown.bottomOffset = CGPoint(x: 0, y:(self.teacherDropDown.anchorView?.plainView.bounds.height)!)
                self.teacherDropDown.show()
                
            }
            if "\(item)" == "Subject"{
                let unique = Array(Set(self.subjectArray))
                self.subjectDropDown.dataSource = unique
                self.subjectDropDown.selectionAction = { (index: Int, item: String) in
                self.subjectString = item
                self.fetchtimeTableFromDatabase(SubjectName:self.subjectString, MonthName:self.monthName, FacultyName:self.facultyString)
                }
                self.subjectDropDown.width = 140
                self.teacherDropDown.bottomOffset = CGPoint(x: 0, y:(self.subjectDropDown.anchorView?.plainView.bounds.height)!)
                self.subjectDropDown.show()
                
            }
            
        }
       
        filterDropdwon.width = 140
        filterDropdwon.bottomOffset = CGPoint(x: 0, y:(filterDropdwon.anchorView?.plainView.bounds.height)!)
        filterDropdwon.show()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        self.fetchtimeTableFromDatabase(SubjectName:"", MonthName:"", FacultyName:"")
        
    }
    
    
   
    
    // Mark : initial FilterDropDown
    func setupFilterDropDown() {
        filterDropdwon.anchorView = filterButton
        filterDropdwon.dataSource = ["Month", "Teacher","Subject"]
        /*filterDropdwon.cellConfiguration = { (index, item) in return "\(item)"}*/
    }
    // Mark : Month filter
    func setUpMonthfilterDropDown() {
        monthDropDown.anchorView = filterButton
        monthDropDown.dataSource = monthArray
    }
    // Mark : Teacher filter
    func setUpteacherdropDown(){
        teacherDropDown.anchorView = filterButton
    
      
    }
    // Mark : Subject filter
    func setUpsubjectDropDown(){
        subjectDropDown.anchorView = filterButton
    }
    
    
    
}


