//
//  HealthReportViewController.swift
//  eLiteSIS
//
//  Created by apar on 05/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import Cosmos


class HealthReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var healthTableView: UITableView!
    
    var healthDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.healthTableView.separatorStyle = .none
        self.healthTableView.delegate = nil
        self.healthTableView.dataSource = nil
        self.getHealthReport()
        self.fetchHealthReport()
        // Do any additional setup after loading the view.
    }
    
    func fetchHealthReport(){
        
        CoreDataController.sharedInstance.fetchHealthReportDataRequest(completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.healthDict =  responseDict as! [String:Any]
                if self.healthDict.count > 0{
                    Singleton.setUpTableViewDisplay(self.healthTableView, headerView:"HealthHeaderView","HealthReportTableViewCell")
                    self.healthTableView.delegate = self
                    self.healthTableView.dataSource = self
                }
                
            }else{
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
        })
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 185
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 392
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HealthHeaderView") as! HealthHeaderView
        viewHeader.usernameLabel.text = self.healthDict["Student_Name"] as? String
        viewHeader.weightLabel.text = "Weight(Kg) : " + (self.healthDict["Weight"] as? String ?? "")
        viewHeader.profileImageview.layer.cornerRadius = viewHeader.profileImageview.bounds.width/2.0
        viewHeader.profileImageview.clipsToBounds = true
        if let imgData = UserDefaults.standard.data(forKey:"entityimage") {
            viewHeader.profileImageview.image = UIImage(data: imgData)
        }else
        {
            viewHeader.profileImageview.image = #imageLiteral(resourceName: "profile")
        }
        viewHeader.calssLabel.text = "Class : " + ((self.healthDict["Class"]) as? String ?? "")
        viewHeader.DobLabel.text = "Date Of Birth : " + ((self.healthDict["DateOfBirth"]) as? String ?? "")
        viewHeader.heightLabel.text = "Height(cms) :" + ((self.healthDict["Height"]) as? String ?? "")
        viewHeader.bloodgroupLabel.text = "Blood Group : " + ((self.healthDict["Blood_Group"]) as? String ?? "")
        return viewHeader
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "HealthReportTableViewCell") as! HealthReportTableViewCell
        //cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CELL") as! HealthReportTableViewCell
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        cell.selectionStyle = .none
        cell.smileIndex.text = (self.healthDict["Smile_Index"]) as? String ?? ""
        cell.nutri_index.text = (self.healthDict["Nutrition_Index"]) as? String ?? ""
        cell.behav_index.text = (self.healthDict["Behaviour_Index"]) as? String ?? ""
        cell.clean_index.text = (self.healthDict["Cleanliness_Index"]) as? String ?? ""
        cell.BDM_index.text = (self.healthDict["Body_Mass_Index"]) as? String ?? ""
        cell.hygiene_index.text = (self.healthDict["Hygiene_Index"]) as? String ?? ""
        cell.vision_index.text = (self.healthDict["Vision_Index"]) as? String ?? ""
        cell.recom_Label.text = (self.healthDict["Recommendation"]) as? String ?? ""
        let ratings = (self.healthDict["OverAll"]) as! String
        cell.healthRating.settings.updateOnTouch = false
        // Show only fully filled stars
        cell.healthRating.settings.fillMode = .half
        cell.healthRating.rating = Double(ratings) as! Double
        return cell
    }
    
    func getHealthReport() {
        
        WebService.shared.GetHealthList(studentID:(UserDefaults.standard.value(forKey:"sis_studentid") as? String) ?? "" , completion:{(response, error) in
            if error == nil , let responseDict = response
            {
                if responseDict.count > 0 {
                    
                    var healthDict = [ "Weight" : responseDict["Weight"].stringValue,
                                      "Height" : responseDict["Height"].stringValue,
                                      "DateOfBirth" : Date.getFormattedDate(string:responseDict["DateOfBirth"].stringValue, formatter: "dd-MMM-yyyy"),
                                      "OverAll" :  responseDict["OverAll"].stringValue,
                                      "Student_Name" : responseDict["Student_Name"].stringValue,
                                      "Class" : responseDict["Class"].stringValue,
                                      "Recommendation" : responseDict["Recommendation"].stringValue,
                                      "Behaviour_Index" : responseDict["Indexes"]["Behaviour_Index"].stringValue,
                                      "Nutrition_Index" : responseDict["Indexes"]["Nutrition_Index"].stringValue,
                                      "Hygiene_Index" : responseDict["Indexes"]["Hygiene_Index"].stringValue,
                                      "Cleanliness_Index" : responseDict["Indexes"]["Cleanliness_Index"].stringValue,
                                      "Smile_Index" : responseDict["Indexes"]["Smile_Index"].stringValue,
                                      "Body_Mass_Index" : responseDict["Indexes"]["Body_Mass_Index"].stringValue,
                                      "Vision_Index" : responseDict["Indexes"]["Vision_Index"].stringValue,
                                      "Blood_Group" : responseDict["Blood_Group"].stringValue
                                      
                        ] as? [String:Any]
    
                    CoreDataController.sharedInstance.insertAndUpdateHealthReport(registrationID:(UserDefaults.standard.value(forKey:"sis_studentid") as? String) ?? "", jsonObject:healthDict!)
                    
                }
               self.fetchHealthReport()
             
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Server error. Please contact Admin!!")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
}
