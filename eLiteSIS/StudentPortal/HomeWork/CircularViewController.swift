//
//  CircularViewController.swift
//  eLiteSIS
//
//  Created by apar on 17/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import QuickLook
import PDFKit
import MobileCoreServices
import CoreData

struct Circular {
  
    let ClassId : String!
    let FacultyID : String!
    let Title: String!
    let Description : String!
    let UploadType : Int!
    let Base64 : String!
    let file_name : String!
    let notesId : String!
    let createdon : String!
    var startDate : Date = Date()
   
    init(_ dict : [String:Any]) {
        
        self.ClassId = dict["ClassId"] as? String
        self.FacultyID = dict["FacultyID"] as? String
        self.Title = dict["Title"] as? String
        self.Description = dict["Description"] as? String
        self.UploadType = dict["UploadType"] as? Int
        self.Base64 = dict["Base64"] as? String
        self.file_name = dict["file_name"] as? String
        self.notesId = dict["notesId"] as? String
        self.createdon = dict["createdon"] as? String
        let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let startdate = dateFormatter.date(from:(dict["createdon"] as? String)!) {
            self.startDate = startdate
        }
        
    }
}


class CircularViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate  {
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var circularTableView: UITableView!
    @IBOutlet weak var emptyData: UIImageView!
    
    var profileDict = [String:Any]()
    let pdfView = PDFView()
    let quickLookController = QLPreviewController()
    var fileURLs = [URL]()
    var refreshControl = UIRefreshControl()
    var circularList = [Circular]()
    var uploadtitle : String = ""
    var uploadType : Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = uploadtitle
        self.emptyData.isHidden = true
        self.circularTableView.delegate = nil
        self.circularTableView.dataSource = nil
        self.circularTableView.separatorColor = .clear
        self.circularTableView.backgroundColor = .clear
        self.circularTableView.refreshControl = refreshControl
        self.circularTableView.separatorColor = .clear
      //   self.fetchProfile(regid:(UserDefaults.standard.object(forKey: "_sis_registration_value") as? String)!)
        self.getCicularList(UserID:(UserDefaults.standard.value(forKey:"userID") as? String)!)
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          // return 100
           return UITableView.automaticDimension
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.circularList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           var cell = tableView.dequeueReusableCell(withIdentifier:"HomeWorkTableViewCell") as! HomeWorkTableViewCell
           cell.selectionStyle = .none
           cell.backgroundColor = .clear
           cell.assignmentLabel.text = self.circularList[indexPath.row].Title
           cell.classLabel.text =  (self.circularList[indexPath.row].createdon!)
           // cell.dateLabel.text = (self.circularList[indexPath.row].createdon!)
           cell.homeworkDesciprtion.text = self.circularList[indexPath.row].Description
           cell.downLoadButton.tag = indexPath.row
           if (self.circularList[indexPath.row].notesId).count > 0 {
               cell.downLoadButton.isHidden = false
           }
           else {
               cell.downLoadButton.isHidden = true
           }
           
           cell.downLoadButton.addTarget(self, action: #selector(downloadButtonSelected), for: .touchUpInside)
           return cell
       }
    
    
      @objc func downloadButtonSelected(sender: UIButton) {
              ProgressLoader.shared.showLoader(withText: "Downloading...")
              let index = sender.tag
              self.downloadAssignment(assignmentValue:self.circularList[index].notesId)
          }

    
    func getCicularList(UserID:String) {
        
        ProgressLoader.shared.showLoader(withText:"Fetching ......")
        WebService.shared.GetDigitalContent(uploadType:uploadType ,userID:UserID,completion: {(response, error) in
            if error == nil , let responseDict = response {
                if let homeworkDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    
                    if homeworkDict.count > 0{
                        self.circularList.removeAll()
                        self.circularTableView.isHidden = false
                        self.emptyData.isHidden = true
                        for obj in homeworkDict {
                            let list = Circular(obj)
                            self.circularList.append(list)
                            self.circularList.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
                            self.circularList.reverse()
                            self.refreshControl.endRefreshing()
                        }
                     Singleton.setUpTableViewDisplay(self.circularTableView, headerView:"","HomeWorkTableViewCell")
                     self.circularTableView.delegate = self
                     self.circularTableView.dataSource = self
                     self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                     self.refreshControl.addTarget(self, action: #selector(self.refresh), for:.valueChanged)
                     self.circularTableView.addSubview(self.refreshControl)
                     self.circularTableView.bounces = true
                     self.circularTableView.estimatedRowHeight = 100
                     self.circularTableView.rowHeight = UITableView.automaticDimension
                     ProgressLoader.shared.hideLoader()
                        
                    }
                    else
                    {
                        self.circularTableView.isHidden = true
                        self.emptyData.isHidden = false
                        ProgressLoader.shared.hideLoader()
                        
                        self.view.makeToast("No Circular/Syllabus Uploaded!!", duration: 1.0, position:.bottom)
                    }
                }
            }
            else
            {
                self.circularTableView.isHidden = true
                self.emptyData.isHidden = false
                ProgressLoader.shared.hideLoader()
                self.view.makeToast("No Circular/Syllabus Uploaded!!", duration: 1.0, position:.bottom)
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    @objc func refresh(sender:AnyObject) {
        self.getCicularList(UserID:(UserDefaults.standard.value(forKey:"userID") as? String)!)
        // Code to refresh table view
    }
       
//       func fetchProfile(regid:String) {
//       CoreDataController.sharedInstance.fetchProfileDataRequest(regID:regid, completion:{(response, error) in
//                      if error == nil , let responseDict = response {
//                       let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
//                       if itemsJsonArray!.count > 0{
//                           for  data in itemsJsonArray! {
//                               self.profileDict  = (data as? [String:Any])!
//                               self.nameLabel.text = self.profileDict["name"] as? String
//                               let studentImage = UIImage.decodeBase64(toImage:(self.profileDict["entityImage"] as? String))
//                               let imgData = studentImage.pngData()
//                               self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2.0
//                               self.profileImageView.clipsToBounds = true
//                               self.profileImageView.image = UIImage(data:imgData!)
//                               self.schoolNameLabel.text = (self.profileDict["programName"] as? String)!
//                           }
//                       }
//
//                      }else{
//                          debugPrint(error?.localizedDescription ?? "Profile Not Found")
//                      }
//                  })
//
//              }
       
       func downloadAssignment(assignmentValue :String) {
           
           if assignmentValue.count > 0 {
               WebService.shared.DownloadHomeWorktList(notesID:assignmentValue,completion:{(response, error) in
                             if error == nil , let responseDict = response {
                                 if responseDict.count > 0 {
                                    
                                      let filename = responseDict["value"][0]["filename"].stringValue
                                    let result = filename.filter { !$0.isNewline && !$0.isWhitespace }
                                     let documentBody = responseDict["value"][0]["documentbody"].stringValue
                                      self.saveBase64StringToPDF(documentBody, fileName: result)
                                     ProgressLoader.shared.hideLoader()
                                 }
                             }else{
                                self.view.makeToast("No File Found!!", duration: 1.0, position: .center)
                               ProgressLoader.shared.hideLoader()
                             }
                             ProgressLoader.shared.hideLoader()
                         })
           }
           else{
                 ProgressLoader.shared.hideLoader()
                self.view.makeToast("No File Found!!", duration: 1.0, position: .center)
           }
         
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
