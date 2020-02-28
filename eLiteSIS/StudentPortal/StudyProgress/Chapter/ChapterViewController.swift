//
//  ChapterViewController.swift
//  eLiteSIS
//
//  Created by apar on 14/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
struct Chapters {
    let  new_name: String
    let  new_lessonplanstatus : Int
    
    init(_ dict:[String:Any]) {
        if let name = dict["new_name"] as? String {
            self.new_name = name
        }
        else{
            self.new_name = ""
        }
        
        let status = dict["new_lessonplanstatus"] as? Int
        self.new_lessonplanstatus = status!
        
    }
}

class ChapterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var chapterTableView: UITableView!
    var examinationId : String = ""
    var chapterList = [Chapters]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.fetchChapters()
        self.chapterTableView.separatorStyle = .none
        self.chapterTableView.delegate = nil
        self.chapterTableView.dataSource = nil
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.chapterList.count == 0 {
             Singleton.returnlabel("No Chapter's Found", self.chapterTableView)
        }
        else{
          Singleton.returnlabel("", self.chapterTableView)
            return self.chapterList.count
        }
        return 0
    }
   
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier:"ChapterHeaderview") as! ChapterHeaderview
    
        return viewHeader
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChapterTableViewCell") as! ChapterTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.chapterNaame.text = self.chapterList[indexPath.row].new_name
        let status =  self.chapterList[indexPath.row].new_lessonplanstatus
        if status == 3 {
            cell.status.text = "Completed"
        }
        if status == 2{
            cell.status.text = "Initiated"
        }
        return cell
    }
    
    // Mark : Webservice Call
    func fetchChapters() {
        WebService.shared.GetChapters(examinationID:examinationId,completion:{(response, error) in
            self.chapterList.removeAll()
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"")
                if let dict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in dict {
                        let chapter = Chapters(obj)
                        self.chapterList.append(chapter)
                    }
                    Singleton.setUpTableViewDisplay(self.chapterTableView, headerView:"ChapterHeaderview","ChapterTableViewCell")
                    self.chapterTableView.delegate = self
                    self.chapterTableView.dataSource = self
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Chapter List")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
}
