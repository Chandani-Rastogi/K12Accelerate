//
//  HolidayListController.swift
//  eLiteSIS
//
//  Created by apar on 02/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

struct Holiday {
    let sis_name : String!
    let new_startdate :String!
    let new_dayname : String!
    init(_ dict:[String:Any]) {
        self.sis_name = dict["holidayName"] as? String
        self.new_startdate  = dict["startdate"] as? String
        self.new_dayname = dict["day"] as? String
    }
}

class HolidayListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var holidayList = [Holiday]()
    @IBOutlet weak var holidayListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.holidayListTableView.delegate = nil
        self.holidayListTableView.dataSource = nil
        self.holidayListTableView.separatorColor = .clear
        self.holidayListTableView.backgroundColor = .clear
        self.fetchHolidayData()
        self.getholidayList()

    }
    
    func fetchHolidayData() {
        CoreDataController.sharedInstance.fetchHolidatDataRequest(completion:{(response,error) in
            if error == nil ,let responseDict = response{
              
            let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.holidayList.removeAll()
                        for obj in itemsJsonArray! {
                            let holiday = Holiday(obj)
                            self.holidayList.append(holiday)
                        }
                    Singleton.setUpTableViewDisplay(self.holidayListTableView,headerView:"HolidayListHeaderView","HolidayListTableViewCell")
                        self.holidayListTableView.delegate = self
                        self.holidayListTableView.dataSource = self
                }
            }
        })
    }
    // MARK: - Table view data source
    
  func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.holidayList.count
    }
    
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier:"HolidayListHeaderView") as! HolidayListHeaderView
        viewHeader.holidayName.text = "Holiday Name"
        viewHeader.day.text = "Day"
        viewHeader.date.text = "Date"
        return viewHeader
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HolidayListTableViewCell") as! HolidayListTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.holidayName.text = self.holidayList[indexPath.row].sis_name
        let startdate =   self.holidayList[indexPath.row].new_startdate
        cell.date.text = Date.getFormattedDate(string:startdate!, formatter: "dd-MMM")
        cell.day.text = self.holidayList[indexPath.row].new_dayname
        return cell
    }
    func getholidayList() {
        WebService.shared.GetHolidayList(completion:{(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"Fetching HolidayList")
                if let holidaydict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in holidaydict {
                    CoreDataController.sharedInstance.insertAndUpdateHolidayList(startDate:obj["new_startdate"] as! String, jsonObject:[obj])
                    }
                    self.fetchHolidayData()
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Holiday List")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
}
