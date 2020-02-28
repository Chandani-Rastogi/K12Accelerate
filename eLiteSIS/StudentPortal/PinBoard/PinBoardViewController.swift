//
//  PinBoardViewController.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

class PinBoardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    struct PinBoard {
        let new_name : String!
        let  new_heading :String!
        let  new_message :String!
        let  new_startdate : String!
        let  new_enddate : String!
        var startDate : Date = Date()
        var endDate : Date = Date()
        
        init(_ dict:[String:Any]){
            self.new_name = dict["name"] as? String
            self.new_heading = dict["heading"] as? String
            self.new_message = dict["message"] as? String
            self.new_startdate = dict["startdate"] as? String
            self.new_enddate = dict["endDate"] as? String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.startDate = dateFormatter.date(from:new_startdate)!
            self.endDate = dateFormatter.date(from:new_enddate!)!
        }
    }
   
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var pinBoardTableview: UITableView!
    
    var pinBoardData = [PinBoard]()
    var pastarray = [PinBoard]()
    var upcomingarray = [PinBoard]()
    var todaysArray = [PinBoard]()
    var dashboardData = [String:AnyObject]()
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pinBoardTableview.delegate = self
        self.pinBoardTableview.dataSource = self
        self.pinBoardTableview.separatorColor = .clear
        self.pinBoardTableview.rowHeight = UITableView.automaticDimension
        self.pinBoardTableview.estimatedRowHeight = UITableView.automaticDimension
      
        self.fetchPinboardData()
        self.getPinBoardData()
    
        self.segmentController.selectedSegmentIndex = 2
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.pinBoardTableview.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
   
    
    @IBAction func segmentController(_ sender: Any) {
       self.pinBoardTableview.reloadData()
    }
      // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentController.selectedSegmentIndex == 0{
            if self.todaysArray.count == 0{
                
                Singleton.returnlabel("No Today's Data", self.pinBoardTableview)
            }
            else{
                Singleton.returnlabel("", self.pinBoardTableview)
                return self.todaysArray.count
            }
            
        }
        if segmentController.selectedSegmentIndex == 1{
            if self.upcomingarray.count == 0{
                
                Singleton.returnlabel("No Upcoming Data", self.pinBoardTableview)
            }
            else{
                Singleton.returnlabel("", self.pinBoardTableview)
                return self.upcomingarray.count
            }
            
        }
        if segmentController.selectedSegmentIndex == 2{
            if self.pastarray.count == 0{
                Singleton.returnlabel("No Past Data", self.pinBoardTableview)
            }
            else{
                Singleton.returnlabel("", self.pinBoardTableview)
                return self.pastarray.count
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell")
        cell!.backgroundColor = .clear
        cell!.selectionStyle = .none
        cell?.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        let heading = cell?.viewWithTag(45) as? UILabel
        let name = cell?.viewWithTag(46) as? UILabel
        let message = cell?.viewWithTag(47) as? UILabel
        let date = cell?.viewWithTag(48) as? UILabel
        
        if segmentController.selectedSegmentIndex == 0{
            let startDate = todaysArray[indexPath.row].new_startdate
            let endDate = todaysArray[indexPath.row].new_enddate
            heading?.text = todaysArray[indexPath.row].new_heading
            name?.text = todaysArray[indexPath.row].new_name
            message?.text = todaysArray[indexPath.row].new_message
            date?.text = Date.getFormattedDate(string:startDate!, formatter: "dd-MMM") + " to " + Date.getFormattedDate(string:endDate!, formatter: "dd-MMM")
        }
        if segmentController.selectedSegmentIndex == 1{
            let startDate = upcomingarray[indexPath.row].new_startdate
            let endDate = upcomingarray[indexPath.row].new_enddate
            heading?.text = upcomingarray[indexPath.row].new_heading
            name?.text = upcomingarray[indexPath.row].new_name
            message?.text = upcomingarray[indexPath.row].new_message
            date?.text = Date.getFormattedDate(string:startDate!, formatter: "dd-MMM") + " to " + Date.getFormattedDate(string:endDate!, formatter: "dd-MMM")
        }
        if segmentController.selectedSegmentIndex == 2{
            let startDate = pastarray[indexPath.row].new_startdate
            let endDate = pastarray[indexPath.row].new_enddate
            heading?.text = pastarray[indexPath.row].new_heading
            name?.text = pastarray[indexPath.row].new_name
            message?.text = pastarray[indexPath.row].new_message
            date?.text = Date.getFormattedDate(string:startDate!, formatter: "dd-MMM") + " to " + Date.getFormattedDate(string:endDate!, formatter: "dd-MMM")
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       //   return 130
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentController.selectedSegmentIndex == 0{
            AlertManager.shared.showAlertWith(title:todaysArray[indexPath.row].new_heading, message: todaysArray[indexPath.row].new_message)
        }
        if segmentController.selectedSegmentIndex == 1{
            AlertManager.shared.showAlertWith(title:upcomingarray[indexPath.row].new_heading, message: upcomingarray[indexPath.row].new_message)
        }
        if segmentController.selectedSegmentIndex == 2{
            AlertManager.shared.showAlertWith(title:pastarray[indexPath.row].new_heading, message: pastarray[indexPath.row].new_message)
        }
    }

    func getPinBoardData() {
        WebService.shared.GetPinboardList(completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.pinBoardData.removeAll()
                ProgressLoader.shared.showLoader(withText:"Fetching Assignment")
                if let pinBoarddict = responseDict["value"].arrayObject as? [[String:Any]]{
                    
                    for obj in pinBoarddict {
                        CoreDataController.sharedInstance.insertAndUpdatePinBoard(Startdate:(obj["new_startdate"] as? String)!, jsonObject:[obj])
                    }
                  
                    self.fetchPinboardData()
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Pinboard data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchPinboardData() {
        
        CoreDataController.sharedInstance.fetchPinBoardDataRequest(completion:{(response,error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                  self.pastarray.removeAll()
                    self.todaysArray.removeAll()
                    self.upcomingarray.removeAll()
                    self.pinBoardData.removeAll()
                        for pinboardData in itemsJsonArray! {
                            let pinboard = PinBoard(pinboardData)
                            if pinboard.startDate == Date(){
                                self.todaysArray.append(pinboard)
                            }
                            if pinboard.startDate < Date() {
                                self.pastarray.append(pinboard)
                            }
                            if pinboard.startDate > Date(){
                                self.upcomingarray.append(pinboard)
                            }
                        }
                         self.pinBoardTableview.reloadData()
                    
                }
            }
            })
    }
}
