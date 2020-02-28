//
//  EventViewController.swift
//  eLiteSIS
//
//  Created by apar on 02/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

struct Event {
    var eventtypeX002eNewId : String!
    var newDescription : String!
    var newEventTypeId : String!
    var newEventstatus : Int!
    var newId : String!
    var newName : String!
    var newSubeventenddate : String!
    var newSubeventstartdate : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        eventtypeX002eNewId = dictionary["eventTypeByNewId"] as? String
        newDescription = dictionary["eventDetail"] as? String
        newEventTypeId = dictionary["eventTypeID"] as? String
        newEventstatus = dictionary["eventStatus"] as? Int
        newId = dictionary["newID"] as? String
        newName = dictionary["eventName"] as? String
        newSubeventenddate = dictionary["endDate"] as? String
        newSubeventstartdate = dictionary["startDate"] as? String
    }
}

class EventViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var eventTableView: UITableView!
    var allEvents = [Event]()
    var eventsDate = [String]()
    var eventsType = [String]()
    var selectedEventType = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTableView.separatorColor = .clear
        self.fetchEvents()
        self.getEvents()
        // Do any additional setup after loading the view.
    }
    
    func fetchEvents(){
        
        CoreDataController.sharedInstance.fetchMonthlyEventsDataRequest(completion:{(respose,error) in
            if error == nil , let resposeDict = respose {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:resposeDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.allEvents.removeAll()
                        for obj in itemsJsonArray! {
                            let event = Event(fromDictionary: obj)
                            self.allEvents.append(event)
                        }
                        Singleton.setUpTableViewDisplay(self.eventTableView, headerView:"", "EventTableViewCell")
                        self.eventTableView.delegate = self
                        self.eventTableView.dataSource = self
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"EventTableViewCell") as! EventTableViewCell
        cell.heading.text = self.allEvents[indexPath.row].eventtypeX002eNewId
        cell.title.text = self.allEvents[indexPath.row].newName
        cell.desc.text = self.allEvents[indexPath.row].newDescription
        let startTime = Date.getFormattedDate(string: self.allEvents[indexPath.row].newSubeventstartdate, formatter:"dd-MMM-yy hh:mm:aa")
        let endTime = Date.getFormattedDate(string: self.allEvents[indexPath.row].newSubeventenddate, formatter:"dd-MMM-yy hh:mm:aa")
        cell.startDate.text = "Start Time : " + startTime
        cell.endTime.text = "End Time : " + endTime
        cell.clipsToBounds = true
//        cell.sizeToFit()
//        cell.layoutIfNeeded()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.2 onwards
        return UITableView.automaticDimension
    }
  
    // Mark : Webservice Call
    func getEvents() {
        WebService.shared.GetMonthlyTimeTable(currentclasssession: UserDefaults.standard.value(forKey:"sisSchoolValue") as! String , completion:{(response, error) in
            
            if error == nil , let responseDict = response {
                 ProgressLoader.shared.showLoader(withText:"fetching events ...")
                if let eventDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in eventDict {
                        CoreDataController.sharedInstance.insertAndUpdateMonthlyEvents(newID:(obj["new_id"] as? String)!, jsonObject:[obj])
                    }
                    self.fetchEvents()
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching time table data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }

}
