//
//  AssignmentTableViewController.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import QuickLook
import PDFKit
import MobileCoreServices
import CoreData

struct Assignment {
    let new_duedate: String!
    let new_name : String!
    let notesId : String!
    let new_submitdate : String!
    let Entityimage : String!
    let new_taskstatus : Int!
    let new_tat : String!
    let sis_gender : String!
    let new_taskassignment : String!
    let new_taskassignment_value : String!
    let new_taskdescription: String!
    
    init(_ dict:[String:Any]) {
         self.new_duedate = dict["dueDate"] as? String
         self.new_name = dict["name"] as? String
         self.notesId = dict["notesID"] as? String
         self.new_submitdate = dict["submitDate"] as? String
         self.Entityimage = dict["entityImage"] as? String
         self.new_taskstatus = dict["taskStatus"] as? Int
         self.new_tat = dict["tat"] as? String
         self.sis_gender = dict["gender"] as? String
         self.new_taskassignment = dict["assignment"] as? String
         self.new_taskassignment_value = dict["assignmentID"] as? String
         self.new_taskdescription = dict["taskDesription"] as? String
    }
}

struct DownloadAssignment {
    let filename : String!
    let documentbody : String!
    init(_ dict:[String:Any]) {
        self.filename = dict["filename"] as? String
        self.documentbody = dict["documentbody"] as? String
    }
}

class AssignmentTableViewController: UITableViewController,UINavigationControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate {

    @IBOutlet var bottomView: UITableView!
    var assignmentList = [Assignment]()
    var fileList = [DownloadAssignment]()
    
    let pdfView = PDFView()
    let quickLookController = QLPreviewController()
    var fileURLs = [URL]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.separatorColor = .clear
        
        self.fetchAssignement()
        self.getAssignments()
    }

    // MARK: - Table view data source
    func setUpTableViewDisplay() {
        self.tableView.separatorStyle = .none
        self.tableView.scrollsToTop = false
        self.tableView.bounces = false
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName:"AssingnmentHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier:"AssignmentHeaderView")
        self.tableView.register(UINib(nibName:"AssignmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AssignmentTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assignmentList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AssignmentHeaderView") as! AssignmentHeaderView
        return viewHeader
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"AssignmentTableViewCell") as! AssignmentTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        
        let userName = assignmentList[indexPath.row].new_name
        let fullName = userName!.components(separatedBy: " ")
        
        cell.userNameLabel.text = fullName[0] + fullName[1]
        cell.subjectAssignmentLabel.text = assignmentList[indexPath.row].new_taskassignment 
        cell.subjectAssignmentLabel.layer.cornerRadius = 5
        cell.subjectAssignmentLabel.layer.masksToBounds = true
       
        let duedate = assignmentList[indexPath.row].new_duedate
        let issueDate = assignmentList[indexPath.row].new_tat
     
        cell.dueDateLabel.text = Date.getFormattedDate(string: duedate!, formatter: "dd-MMM")
        cell.issueDateLabel.text = Date.getFormattedDate(string: issueDate!, formatter: "dd-MMM")
        
        //Cell Button
        cell.viewButton.tag = indexPath.row
        cell.viewButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        
        cell.DownloadButton.tag = indexPath.row
        cell.DownloadButton.addTarget(self, action:#selector(downloadButtonSelected), for:.touchUpInside)
        return cell
    }
    
    @objc func buttonSelected(sender: UIButton){
        let index = sender.tag
        AlertManager.shared.showAlertWith(title:assignmentList[index].new_name, message:assignmentList[index].new_taskdescription)
    }
    @objc func downloadButtonSelected(sender: UIButton){
        let index = sender.tag
        self.downloadAssignment(assignmentValue:assignmentList[index].new_taskassignment_value)
    }
    
    func fetchAssignement() {
        CoreDataController.sharedInstance.fetchStudentAssignmentRequest(completion:{(response,error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.assignmentList.removeAll()
                    for assignmentData in itemsJsonArray! {
                        let assign = Assignment(assignmentData)
                        self.assignmentList.append(assign)
                    }
                    self.setUpTableViewDisplay()
                }
            }
        })
    }
    
    func getAssignments() {
        ProgressLoader.shared.showLoader(withText:"Fetching Assignment")
        let studentID = UserDefaults.standard.value(forKey:"sis_studentid") as? String ?? ""
        WebService.shared.GetAssignmentList(studentID:studentID,completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let assignmentdict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for assignmentData in assignmentdict {
                CoreDataController.sharedInstance.insertAndUpdateStudentAssignment(assignmentID:(assignmentData["_new_taskassignment_value"] as? String)!, jsonObject:[assignmentData])
                    }
                    self.fetchAssignement()
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Assignment data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    
    
    func downloadAssignment(assignmentValue :String) {
        
        ProgressLoader.shared.showLoader(withText: "Downloading...")
        WebService.shared.downloadAssignmentList(assignmentValue:assignmentValue,completion:{(response, error) in
            if error == nil , let responseDict = response {
                if responseDict.count > 0 {
                     let filename = responseDict["value"][0]["filename"].stringValue
                   let result = filename.filter { !$0.isNewline && !$0.isWhitespace }
                    let documentBody = responseDict["value"][0]["documentbody"].stringValue
                     self.saveBase64StringToPDF(documentBody, fileName: result)
                }
            }else{
                 ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Assignment data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }

    func saveBase64StringToPDF(_ base64String: String , fileName:String) {
        
        guard
            var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last,
            let convertedData = Data(base64Encoded: base64String)
            else {
                //handle error when getting documents URL
                return
        }
        //name your file however you prefer
        documentsURL.appendPathComponent(fileName)
        
        do {
            try convertedData.write(to: documentsURL)
        } catch {
            print("can not convert to pdf")
            //handle write error here
        }
        self.showSavedPdf(url:base64String, fileName:fileName)
        
    }
    
    func showSavedPdf(url:String, fileName:String) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName)") {
                        // its your file! do what you want with it!
                        fileURLs = [url]
                        let viewPDF = QLPreviewController()
                        viewPDF.dataSource = self
                        self.present(viewPDF, animated: true, completion: nil)
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
    }
    
    
    // MARK:  QLPreviewController data source method
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURLs[0] as QLPreviewItem
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
        
    }
    
    //MARK: QLPreviewController delegate method
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

