//
//  RecentChatHistoryController.swift
//  eLiteSIS
//
//  Created by apar on 07/01/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit



class RecentChatHistoryController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    @IBOutlet weak var recentChatTable: UITableView!
     var refreshControl = UIRefreshControl()
    
    var allTeacherlist = [LatestChat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recentChatTable.separatorColor = .clear
        self.recentChatTable.delegate = self
        self.recentChatTable.dataSource = self
        self.getFacultyList()
        // Do any additional setup after loading the view.
    }
   
    
    func getFacultyList() {
        
        ProgressLoader.shared.showLoader(withText:"Fetching recent chat history ...")
        guard let registrationID = UserDefaults.standard.object(forKey:"_sis_registration_value") as? String else {
            return
        }
        WebService.shared.StudentChatHistory(registrationID:registrationID,completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let teacherdict = responseDict["LatestChat"].arrayObject as? [[String:Any]]{
                        if teacherdict.count > 0 {
                        for data in teacherdict {
                            let list = LatestChat(data)
                            self.allTeacherlist.append(list)
                            Singleton.setUpTableViewDisplay(self.recentChatTable, headerView:"","RecentChatCell")
                            self.recentChatTable.delegate = self
                            self.recentChatTable.dataSource = self
                            self.recentChatTable.bounces = true
                            ProgressLoader.shared.hideLoader()
                        }
                        ProgressLoader.shared.hideLoader()
                    }
                        else {
                            self.view.makeToast("No Recent Found!!", duration: 1.0, position: .center)
                         ProgressLoader.shared.hideLoader()
                    }
                }
            }else{
                 self.view.makeToast("No Recent Found!!", duration: 1.0, position: .center)
               ProgressLoader.shared.hideLoader()
            }
            
        })
    }

    @IBAction func initiateNewChatButton(_ sender: Any) {
     
        let destViewController  = mainStoryboard.instantiateViewController(withIdentifier:"studentChat") as! SelectStudentController
      self.navigationController?.pushViewController(destViewController, animated: true)
        
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.allTeacherlist.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "RecentChatCell") as? RecentChatCell
            cell!.selectionStyle = .none
            cell!.backgroundColor = .clear
          
            cell!.sendername.text = self.allTeacherlist[indexPath.row].SenderName
            cell!.dateLabel.text = "Last Seen: " + "\n" + self.allTeacherlist[indexPath.row].CreatedOn
            cell!.messageLabel.text = self.allTeacherlist[indexPath.row].Message
            return cell!
        }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "discuss") as! DiscussionViewController
        destViewController.facultyname = self.allTeacherlist[indexPath.row].SenderName
        destViewController.facultyID = self.allTeacherlist[indexPath.row].SenderId
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
}
