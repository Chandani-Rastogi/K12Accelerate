//
//  AttendanceViewController.swift
//  eLiteSIS
//
//  Created by apar on 02/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import FSCalendar
import CoreData

struct PresentPercentage {
    
    var date  : String!
    var absent : Int16!
    var presnt : Int16!
    var leave : Int16!
    
    init(_ dict:[String:Any]) {
        self.date = dict["dateString"] as? String
        self.absent = dict["absent"] as? Int16
        self.presnt = dict["present"] as? Int16
        self.leave = dict["leave"] as? Int16
    }
    
}

struct Attendance{
    
    var newClassSession : NewClassSession!
    var newAttendancedata : String!
   
    init(fromDictionary dictionary: [String:Any]){
        if let newClassSessionData = dictionary["new_ClassSession"] as? [String:Any]{
            newClassSession = NewClassSession(fromDictionary: newClassSessionData)
        }
        newAttendancedata = dictionary["new_attendancedata"] as? String
    }
    
    struct NewClassSession{
        
        var sisSessionValue : String!
        var session : String!
        init(fromDictionary dictionary: [String:Any]){
            sisSessionValue = dictionary["_sis_session_value"] as? String
            session = dictionary["_sis_session_value@OData.Community.Display.V1.FormattedValue"] as? String
        }
    }
}

class AttendanceViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var sessionProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var presentProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var sessionpercentageLabel: UILabel!
    @IBOutlet weak var presentPercentageLabel: UILabel!
    @IBOutlet weak var presentinthisSessionLabel: UILabel!
    @IBOutlet weak var presentinthisMonthLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var presentLabel: UILabel!
    @IBOutlet weak var absentLabel: UILabel!
    @IBOutlet weak var leaveLabel: UILabel!
    
    
    var monthlyAttendanceArray = [String]()
    var monthArray = [Int]()
    var attendanceData = [Attendance]()
    var serveryear : String = ""
    
    var presenList = [String]()
    var absentList = [String]()
    var weekendList = [String]()
    var leaveList = [String]()
    var json = [String:Any]()
    var presentMonthPercantage = [PresentPercentage]()

    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getStudentAttendance()
        navigationItem.largeTitleDisplayMode = .never
        self.fetchMonthlyAttendancePercentage(dateString: "", totalDays: 0)
        // Do any additional setup after loading the view.
    }
    
    func fetchMonthlyAttendancePercentage(dateString:String , totalDays:Int16) {
        
        CoreDataController.sharedInstance.fetchAttendancePercentage(completion: {(response, error) in
            if error == nil , let responseDict = response {
                
                let itemJsonArray = (Singleton.convertToJSONArray(moArray: responseDict as! [NSManagedObject])) as? [[String:Any]]
                
                
                self.presentMonthPercantage.removeAll()
                
                if itemJsonArray!.count > 0 {
                    for obj in itemJsonArray! {
                        let list = PresentPercentage(obj)
                        
                        self.presentMonthPercantage.append(list)
                        
                        if dateString == list.date {
                            //Label
                            self.presentLabel.text = String(list.presnt)
                            self.absentLabel.text = String(list.absent)
                            self.leaveLabel.text = String(list.leave)
                            
                            
                            if list.absent == 0 && list.presnt != 0  && list.leave == 0 {
                                self.presentinthisMonthLabel.text =  "100 %"
                                self.presentProgressBar.value = 100
                            }
                            else if list.absent == 0 && list.presnt == 0 && list.leave == 0 {
                                
                                self.presentinthisMonthLabel.text =  "0 %"
                                self.presentProgressBar.value = 0
                                
                            }
                            else {
                                
                                let total = (list.presnt + list.absent + list.leave)
                                let percetangeinMonth = ((list.presnt) * 100) / total
                                self.presentinthisMonthLabel.text =  String(percetangeinMonth) + " %"
                                
                                // CircularBar
                                self.presentProgressBar.value = CGFloat(percetangeinMonth)
                                
                            }
                        }
                    }
                }
            }})
    }

    
    func displayEventsInCalender() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor?
    {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        let year = Calendar.current.component(.year, from: currentPageDate)
        let range = Calendar.current.range(of: .day, in:.month, for: date)!
        let numDays = range.count
        let total = (self.presenList.count + self.absentList.count + self.leaveList.count)
     
            let percetangeinSession = ((self.presenList.count) * 100) / total
            self.presentinthisSessionLabel.text = String(percetangeinSession) + " %"
            self.sessionProgressBar.value = CGFloat(percetangeinSession)
      
        if self.presentMonthPercantage.count > 0 {
            
            self.fetchMonthlyAttendancePercentage(dateString:(String(month) + "-" + String(year)), totalDays: Int16(numDays) )
            
            let dateString : String = dateFormatter1.string(from:date)
            if presenList.contains(dateString)
            {
                self.presentLabel.text = String(self.presenList.count)
                
                return #colorLiteral(red: 0, green: 0.9820697904, blue: 0.6320270896, alpha: 1)
            }
            else if absentList.contains(dateString)
            {
                self.absentLabel.text = String(self.absentList.count)
                return #colorLiteral(red: 1, green: 0.1782162834, blue: 0.1231012811, alpha: 1)
            }
            else if weekendList.contains(dateString)
            {
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            else if leaveList.contains(dateString)
            {
                self.leaveLabel.text = String(self.leaveList.count)
                return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            }
            else
            {
                return nil
            }
        }
        return nil
    }
    
    
    func getStudentAttendance() {
        guard let StudentID = UserDefaults.standard.object(forKey:"sis_studentid") as? String else {
            return
        }
        
        WebService.shared.GetStudentAttendance(studentID:StudentID,completion:{(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"Fetching HolidayList")
                if let attendanceDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for monthAttendance in attendanceDict {
                        let attendance = Attendance(fromDictionary:monthAttendance)
                        self.attendanceData.append(attendance)
                        self.setUpAttendance(result:attendance.newAttendancedata, session:attendance.newClassSession.session)
                    }
                }
            }else{
                  self.view.makeToast("No Attendance data", duration: 1.0, position: .center)
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func setUpAttendance(result: String, session: String) {
        
       
        let resultList = result.split(separator: "[")
        var index : Int = 0
        var dateString : String = ""
        var month : Int = 0
        for it in resultList {
            if (it != "") {
                month = Int((it as NSString).substring(with:NSMakeRange(0, 2)))!
                let attendance = (it as NSString).substring(from: 3)
                let pCount = attendance.numberOfOccurrences("P") // aCount = 4
                let aCount = attendance.numberOfOccurrences("A") // aCount = 4
                let lCount = attendance.numberOfOccurrences("L")
                let percentage : Int
                if month < 4 {
                    index = 0
                    serveryear = session.substring(from:5)
                    
                    if pCount != 0 && aCount == 0 {
                         percentage = 100
                    }
                    else {
                    let total = (pCount + aCount + lCount)
                        if total > 0 {
                            percentage = ((pCount) * 100) / total
                            print(percentage)
                        }
                        else{
                        percentage = 0
                    }
                    }
                    
                    CoreDataController.sharedInstance.insertAndUpdateStudentAttendance(month:String(month), percentage: percentage, year:serveryear, registrationID:(UserDefaults.standard.object(forKey:"_sis_registration_value") as? String)! )
                    
                    
                }else{
                    index = 0
                    serveryear = session.substring(to: 3)
                    if pCount != 0 && aCount == 0 {
                        percentage = 100
                    }
                    else {
                        let total = (pCount + aCount + lCount)
                        if total > 0 {
                            percentage = ((pCount) * 100) / total
                            print(percentage)
                        }
                        else{
                            percentage = 0
                        }
                        
                    }
                    CoreDataController.sharedInstance.insertAndUpdateStudentAttendance(month:String(month), percentage: percentage, year:serveryear, registrationID:(UserDefaults.standard.object(forKey:"_sis_registration_value") as? String)! )
                }
                
                
                let finalString = String(month) + "-" + serveryear
                
                print("********************Leave count " , lCount)
            CoreDataController.sharedInstance.insertAndUpdateAttenadancePercentage(present:Int16(pCount), absent:Int16(aCount), leave:Int16(lCount), dateString:finalString)
                
                
                for char in attendance{
                    index = index + 1
                    
                    if char == "P" {
                        
                        if month < 10  {
                            if index < 10{
                                dateString =  serveryear + "-0" + String(month) + "-0" + String(index)
                            }
                            else{
                                dateString =  serveryear + "-0" + String(month) + "-" + String(index)
                            }
                        }
                        else{
                            
                            dateString =  serveryear + "-" + String(month) + "-" + String(index)
                        }
                        self.presenList.append(dateString)
                        
                    }
                    
                    if char == "A"{
                        if month < 10  {
                            
                            if index < 10{
                                dateString =  serveryear + "-0" + String(month) + "-0" + String(index)
                            }
                            else{
                                dateString =  serveryear + "-0" + String(month) + "-" + String(index)
                            }
                        }
                        else{
                            
                            dateString =  serveryear + "-" + String(month) + "-" + String(index)
                        }
                        self.absentList.append(dateString)
                        
                    }
                    if char == "W"{
                        if month < 10  {
                            
                            if index < 10{
                                dateString =  serveryear + "-0" + String(month) + "-0" + String(index)
                            }
                            else{
                                dateString =  serveryear + "-0" + String(month) + "-" + String(index)
                            }
                            
                        }
                        else{
                            
                            dateString =  serveryear + "-" + String(month) + "-" + String(index)
                        }
                        self.weekendList.append(dateString)
                        
                    }
                    
                    if char == "L"{
                        if month < 10  {
                            
                            if index < 10{
                                dateString =  serveryear + "-0" + String(month) + "-0" + String(index)
                            }
                            else{
                                dateString =  serveryear + "-0" + String(month) + "-" + String(index)
                            }
                            
                        }
                        else{
                            
                            dateString =  serveryear + "-" + String(month) + "-" + String(index)
                        }
                        self.leaveList.append(dateString)
                    }
                }
            }
            
            self.displayEventsInCalender()
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
extension String {
        func substring(from : Int) -> String {
            let fromIndex = self.index(self.startIndex, offsetBy: from)
            return String(self[fromIndex...])
        }
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    }
extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
}

extension String {

    public func numberOfOccurrences(_ string: String) -> Int {
        return components(separatedBy: string).count - 1
    }

}

