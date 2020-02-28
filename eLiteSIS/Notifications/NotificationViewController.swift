//
//  NotificationViewController.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

struct NotificationList{
    
    var createdon : String!
    var newDate : String!
    var newDescription : String!
    var newHeading : String!
    var newTitle : String!
    var startDate : Date = Date()
    var base64 : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        createdon = dictionary["createdOn"] as? String
        newDate = dictionary["newDate"] as? String
        newDescription = dictionary["message"] as? String
        newHeading = dictionary["heading"] as? String
        newTitle = dictionary["title"] as? String
        base64 = dictionary["base64"] as? String
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss aa"
        if let startdate = dateFormatter.date(from:createdon) {
            self.startDate = startdate
        }
    }
}


class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var segmentcontroller: UISegmentedControl!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var notificationTableview: UITableView!
    
    let kDefaultPhotoWidth: CGFloat = 131
    let kDefaultPhotoRightMargin: CGFloat = 88

    
    var allnotification = [NotificationList]()
    var allArray = [NotificationList]()
    var missedArray = [NotificationList]()
    var todaysArray = [NotificationList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Singleton.sharedInstance.deleteAllRecords(EntityName:"Notifications")
        
        self.notificationTableview.dataSource = nil
        self.notificationTableview.delegate = nil
       
        self.notificationTableview.separatorColor = .clear
        self.fetchNotification()
        self.getNotificationst()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentController(_ sender: Any) {
      self.notificationTableview.reloadData()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentcontroller.selectedSegmentIndex == 0{
            if self.todaysArray.count == 0{
                self.thumbImage.isHidden = false
               self.notificationTableview.isHidden = true
            }
            else{
                 self.thumbImage.isHidden = true
                 self.notificationTableview.isHidden = false
                return self.todaysArray.count
            }
            
        }
        
        if segmentcontroller.selectedSegmentIndex == 1{
            if self.allArray.count == 0{
           self.thumbImage.isHidden = false
           self.notificationTableview.isHidden = true
            }
            else{
                  self.thumbImage.isHidden = true
                 self.notificationTableview.isHidden = false
                return self.allArray.count
            }
            
        }
      
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.allArray[indexPath.row].base64 == nil {
            var cell = tableView.dequeueReusableCell(withIdentifier: "sampleTableViewCell") as! sampleTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
            cell.title.font = .boldSystemFont(ofSize:12)
            
            if segmentcontroller.selectedSegmentIndex == 0 {
                cell.title.text = self.todaysArray[indexPath.row].newHeading
                cell.detailTextView.text = (self.todaysArray[indexPath.row].newTitle ?? "") + "\n" + self.todaysArray[indexPath.row].newDescription
                cell.dateLabel.text = Date.getFormattedDate3(string:self.todaysArray[indexPath.row].createdon, formatter:"dd-MMM-yyyy")
                let greetingImage = UIImage.decodeNotificationBase64(toImage:self.todaysArray[indexPath.row].base64)
                let imgData = greetingImage.pngData()
                //cell.greetingImageView.image = UIImage(data: imgData!)
            }
            if segmentcontroller.selectedSegmentIndex == 1 {
                cell.title.text = self.allArray[indexPath.row].newHeading
                cell.detailTextView.text = (self.allArray[indexPath.row].newTitle ?? "") + "\n" + self.allArray[indexPath.row].newDescription
                cell.dateLabel.text = Date.getFormattedDate3(string:self.allArray[indexPath.row].createdon, formatter:"dd-MMM-yyyy")
                let greetingImage = UIImage.decodeNotificationBase64(toImage:self.allArray[indexPath.row].base64)
                let imgData = greetingImage.pngData()
                //cell.greetingImageView.image = UIImage(data: imgData!)
                if self.allArray[indexPath.row].base64 == nil {
                    // cell.heightLayout.constant = 0
                }
            }
            return cell
        }
        else  {
          var cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
            cell.title.font = .boldSystemFont(ofSize:12)
            
            if segmentcontroller.selectedSegmentIndex == 0 {
                cell.title.text = self.todaysArray[indexPath.row].newHeading
                cell.detailTextView.text = (self.todaysArray[indexPath.row].newTitle ?? "") + "\n" + self.todaysArray[indexPath.row].newDescription
                cell.dateLabel.text = Date.getFormattedDate3(string:self.todaysArray[indexPath.row].createdon, formatter:"dd-MMM-yyyy")
                let greetingImage = UIImage.decodeNotificationBase64(toImage:self.todaysArray[indexPath.row].base64)
                let imgData = greetingImage.pngData()
                cell.greetingImageView.image = UIImage(data: imgData!)
            }
            if segmentcontroller.selectedSegmentIndex == 1 {
                cell.title.text = self.allArray[indexPath.row].newHeading
                cell.detailTextView.text = (self.allArray[indexPath.row].newTitle ?? "") + "\n" + self.allArray[indexPath.row].newDescription
                cell.dateLabel.text = Date.getFormattedDate3(string:self.allArray[indexPath.row].createdon, formatter:"dd-MMM-yyyy")
                let greetingImage = UIImage.decodeNotificationBase64(toImage:self.allArray[indexPath.row].base64)
                let imgData = greetingImage.pngData()
                cell.greetingImageView.image = UIImage(data: imgData!)
            }
            return cell
        }
      return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 125
        return UITableView.automaticDimension
    }
    
    func getNotificationst() {
        ProgressLoader.shared.showLoader(withText: "Fetching Notifications ....")
        WebService.shared.GetNotification(studentNameValue:(UserDefaults.standard.value(forKey:"NotificationId") as? String) ?? "", completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let notificationDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for data in notificationDict {
                        CoreDataController.sharedInstance.insertAndUpdateNotifications(newDate:(data["createdon"] as? String)!, jsonObject:[data])
                    }
                    self.fetchNotification()
                }
                ProgressLoader.shared.hideLoader()
                
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Server error. Please contact Admin!!")
            }
            ProgressLoader.shared.hideLoader()
        })
        
    }
    
    
    func fetchNotification() {
        CoreDataController.sharedInstance.fetchNotificationsRequest(completion:{(response,error) in
            if error == nil , let responseDict = response {
                
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    
                    
                    self.allnotification.removeAll()
                    self.todaysArray.removeAll()
                    self.allArray.removeAll()
                    self.missedArray.removeAll()
                    
                    let date : Date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    let todaysDate = dateFormatter.string(from: date)
                    
                    for data in itemsJsonArray! {
                        
                        let notification = NotificationList(fromDictionary: data)
                        
                        
                        let notificationDate =  Date.getFormattedDate3(string:notification.createdon, formatter:"dd-MMM-yyyy")
                       
                      
                        if notificationDate == todaysDate {
                            self.todaysArray.append(notification)
                        }
                        else {
                            self.allArray.append(notification)
                            self.allArray.sort(by:{$0.startDate.compare($1.startDate) == .orderedAscending})
                            self.allArray.reverse()
                        }
                        
                    }
                    Singleton.setUpTableViewDisplay(self.notificationTableview, headerView:"","sampleTableViewCell")
                     Singleton.setUpTableViewDisplay(self.notificationTableview, headerView:"","NotificationTableViewCell")
                    
                    
                    self.notificationTableview.delegate = self
                    self.notificationTableview.dataSource = self
                    
                }
            }
        })
    }
}
