//
//  DailyScheduleViewController.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

struct DailySchedule {
   
    let start_time: String!
    let end_time : String!
    let start_date : String!
    let subject : String!
    let Section : String!
   var startDate : Date = Date()
    
    init(_ dict:[String:Any]) {
        start_time = dict["starttime"] as? String
        end_time = dict["endtime"] as? String
        start_date = dict["startDatastring"] as? String
        subject = dict["subject"] as? String
        Section = dict["section"] as? String
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let startdate = dateFormatter.date(from:(dict["startDatastring"] as? String)!) {
            self.startDate = startdate
        }
    }
}



class DailyScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var DSTableView: UITableView!

   
    var dailySchedule = [DailySchedule]()
    
    var sections = [TableSection<Date, DailySchedule>]()
    
    fileprivate func firstDayOfMonth(date : Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month , .day], from: date)
        return calendar.date(from: components)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DSTableView.separatorColor = .clear
        self.DSTableView.delegate = nil
        self.DSTableView.dataSource = nil
        fetchDailyScheduleList()
      // self.getContactID(regId:registrationID)
      // Do any additional setup after loading the view.
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = self.sections[section]
        let date = section.sectionItem
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: date)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sections.count == 0 {
            Singleton.returnlabel("No Daily Schedule ", self.DSTableView)
        }
        else{
            let section = self.sections[section]
            return section.rowItems.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DailyScheduleTableViewCell") as? DailyScheduleTableViewCell
        let section = self.sections[indexPath.section]
        
        let headline = section.rowItems[indexPath.row]
        cell!.subject.text = headline.subject
        cell!.timeLabel.text = Date.getFormattedTime(string:headline.start_time, formatter: "hh:mm")
        cell!.selectionStyle = .none
        
        return cell!
    }
    
    func fetchDailyScheduleList() {
    TeacherCoreDatacontroller.shared.fetchDailySchedule(completion: {(response, error) in
        if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                var dailyScheduleDict = [[String:Any]]()
                dailyScheduleDict.append(contentsOf:itemsJsonArray!)
               
                    if let dict = dailyScheduleDict as? [[String:Any]]{
                        if dict.count > 0 {
                            for data in dailyScheduleDict {
                                let schedule = DailySchedule(data)
                                self.dailySchedule.append(schedule)
                                self.dailySchedule.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
                                self.dailySchedule.reverse()
                            }
                            self.sections = TableSection.group(rowItems: self.dailySchedule, by: { (schedule) in
                                return self.firstDayOfMonth(date:schedule.startDate)
                            })
                            ProgressLoader.shared.hideLoader()
                        }
                        else
                        {
                            ProgressLoader.shared.hideLoader()
                        }
                    }
                  
            Singleton.setUpTableViewDisplay(self.DSTableView, headerView: "", "DailyScheduleTableViewCell")
            self.DSTableView.delegate = self
            self.DSTableView.dataSource = self
            }
                
            else{
                ProgressLoader.shared.hideLoader()
                debugPrint(error?.localizedDescription ?? "Invalid User")
            AlertManager.shared.showAlertWith(title:"Daily Schedule", message:"No data found!!")
            }
        })
    }
    
    func getDailyScheduleAPI() {
           WebService.shared.getFacultyDailySchedule(value:"2f572c68-6d50-e911-a95c-000d3af2cb54", completion:{(response, error) in
               if error == nil , let responseDict = response {
                   if let scheduleDict = responseDict.arrayObject as? [[String:Any]]{
                       if scheduleDict.count > 0{
                           for data in scheduleDict {
                           TeacherCoreDatacontroller.shared.insertOrUpdateDailySchedule(startDate:data["start_date"] as! String, jsonObject:[data])
                           }
                           self.fetchDailyScheduleList()
                       }
                   }
               }else{
                   AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                   debugPrint(error?.localizedDescription ?? "Invalid User")
               }
               ProgressLoader.shared.hideLoader()
           })
       }
    
    /* func getContactID(regId:String){
          WebService.shared.GetFacultyFromRegistrationID(regId:regId, completion: {(response, error) in
              if error == nil , let responsedict = response {
                      if responsedict.count > 0 {
                          TeacherCoreDatacontroller.shared.insertAndUpdateGetFacultyFromRegistrationID(regID:regId, facultycontactId:responsedict["FacultyContactID"].stringValue, facultyID:responsedict["FacultyID"].stringValue)
                          self.fetchContactID(regID:regId)
                      }
              }
          })
      }*/
    
    /*  func fetchContactID(regID:String) {
         
            TeacherCoreDatacontroller.shared.fetchContactID(regId:regID,completion:{(response, error) in
                if error == nil , let responseDict = response {
                 print(responseDict)
                }else{
                    self.getContactID(regId:regID)
                    debugPrint(error?.localizedDescription ?? "ContactID Not found")
                }
            })
        }*/

    
       
     
}
