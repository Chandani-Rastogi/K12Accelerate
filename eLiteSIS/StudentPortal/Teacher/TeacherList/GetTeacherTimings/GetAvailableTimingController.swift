//
//  GetAvailableTimingController.swift
//  eLiteSIS
//
//  Created by apar on 03/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

struct Timings {
    let   new_timesunday : String
    let   new_timetuesday : String
    let  new_timemonday : String
    let  new_timewednesday : String
    let  new_timethursday : String
    let new_timefriday : String
    let new_timesaturday : String
    
    init(_ dict:[String:Any]) {
        if let sunday = dict["new_timesunday"] as? String{
            self.new_timesunday = sunday
        }else{
            self.new_timesunday = ""
        }
        if let tuesday = dict["new_timetuesday"] as? String{
            self.new_timetuesday = tuesday
        }else{
            self.new_timetuesday = ""
        }
        if let monday = dict["new_timemonday"] as? String{
            self.new_timemonday = monday
        }else{
            self.new_timemonday = ""
        }
        if let wednesday = dict["new_timewednesday"] as? String{
            self.new_timewednesday = wednesday
        }else{
            self.new_timewednesday = ""
        }
        if let thursday = dict["new_timethursday"] as? String{
            self.new_timethursday = thursday
        }else{
            self.new_timethursday = ""
        }
        if let friday = dict["new_timefriday"] as? String{
            self.new_timefriday = friday
        }else{
            self.new_timefriday = ""
        }
        if let saturday = dict["new_timesaturday"] as? String{
            self.new_timesaturday = saturday
        }else{
            self.new_timesaturday = ""
        }
        
    }
}

class GetAvailableTimingController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var facultyValue : String = ""
    var facultyName : String = ""
    var facultySubject : String = ""
    var facultyProfilePicture : String = ""
    
    var timingList = [Timings]()
    @IBOutlet weak var timingsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timingsList.separatorStyle = .none
        self.timingsList.delegate = nil
        self.timingsList.dataSource = nil
        self.getFacultyAvailability()
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timingList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier:"GetTimeHeaderView") as! GetTimeHeaderView
        let teacherImage = UIImage.decodeBase64(toImage:self.facultyProfilePicture)
        let imgData = teacherImage.pngData()
        viewHeader.facultyProfileImage.layer.cornerRadius =  viewHeader.facultyProfileImage.bounds.width/2.0
        viewHeader.facultyProfileImage.clipsToBounds = true
        if imgData != nil {
           viewHeader.facultyProfileImage.image = UIImage(data:imgData!)
        }else{
            viewHeader.facultyProfileImage.image = #imageLiteral(resourceName: "profile")
        }
        viewHeader.facultyName.text = facultyName
        viewHeader.facultySubject.text = facultySubject
        viewHeader.chatButton.tag = section
        viewHeader.chatButton.addTarget(self, action: #selector(chatSelected), for: .touchUpInside)
        return viewHeader
    }
    
     @objc func chatSelected(sender: UIButton) {   
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "discuss") as? DiscussionViewController{
            vc.facultyID = facultyValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"GetTimeTableViewCell") as! GetTimeTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.sunday.text = self.timingList[indexPath.row].new_timesunday
        cell.Monday.text = self.timingList[indexPath.row].new_timemonday
        cell.tuesday.text = self.timingList[indexPath.row].new_timetuesday
        cell.wedneday.text = self.timingList[indexPath.row].new_timewednesday
        cell.thursday.text = self.timingList[indexPath.row].new_timethursday
        cell.saturday.text = self.timingList[indexPath.row].new_timesaturday
        cell.friday.text = self.timingList[indexPath.row].new_timefriday
        
        return cell
    }
    
    func getFacultyAvailability() {
        WebService.shared.GetAvailableTime(facultyValue:facultyValue,completion:{(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"")
                if let dict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for data in dict {
                        let list = Timings(data)
                        self.timingList.append(list)
                    }
                    Singleton.setUpTableViewDisplay(self.timingsList,headerView:"GetTimeHeaderView","GetTimeTableViewCell")
                    self.timingsList.delegate = self
                    self.timingsList.dataSource = self
                }
                
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Server error. Please contact Admin!!")
            }
            ProgressLoader.shared.hideLoader()
        })
    }


}
