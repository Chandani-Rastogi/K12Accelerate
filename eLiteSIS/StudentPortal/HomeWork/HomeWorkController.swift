//
//  HomeWorkController.swift
//  eLiteSIS
//
//  Created by apar on 07/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData
import QuickLook
import PDFKit
import MobileCoreServices

class HomeWorkController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var HomeWorkTableView: UITableView!
    var homeList = [HomeWork]()
    var profileDict = [String:Any]()
    let pdfView = PDFView()
    let quickLookController = QLPreviewController()
    var fileURLs = [URL]()
    var refreshControl = UIRefreshControl()
       
   
    @IBOutlet weak var emptyData: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emptyData.isHidden = true
        self.HomeWorkTableView.delegate = nil
        self.HomeWorkTableView.dataSource = nil
        self.HomeWorkTableView.separatorColor = .clear
        self.HomeWorkTableView.backgroundColor = .clear
        self.HomeWorkTableView.refreshControl = refreshControl
        self.fetchhomeWorkList()
     //   self.fetchProfile(regid:(UserDefaults.standard.object(forKey: "_sis_registration_value") as? String)!)
       
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   //   return 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"HomeWorkTableViewCell") as! HomeWorkTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.assignmentLabel.text = (self.homeList[indexPath.row].sis_name) ?? "NA"
        cell.classLabel.text = self.homeList[indexPath.row].new_subject + "\n" + Date.getFormattedDate(string:(self.homeList[indexPath.row].createdon)!, formatter:"dd-MM-YYYY")
        
        cell.homeworkDesciprtion.text = self.homeList[indexPath.row].sis_homeworkdescription
        
        cell.downLoadButton.tag = indexPath.row
        if (self.homeList[indexPath.row].notesId).count > 0 {
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
           self.downloadAssignment(assignmentValue:self.homeList[index].notesId)
       }

    
    func fetchhomeWorkList() {
        ProgressLoader.shared.showLoader(withText:"Fetching HomeWork ......")
        
        CoreDataController.sharedInstance.fetchHomeworkList(userID:(UserDefaults.standard.object(forKey:"userID") as? String)!, completion: {(response, error) in
            if error == nil , let responseDict = response {
                let itemJsonArray = (Singleton.convertToJSONArray(moArray: responseDict as! [NSManagedObject])) as? [[String:Any]]
                self.homeList.removeAll()
                if itemJsonArray!.count > 0 {
                    
                    self.HomeWorkTableView.isHidden = false
                    self.emptyData.isHidden = true
                    
                    for obj in itemJsonArray! {
                        let list = HomeWork(obj)
                        self.homeList.append(list)
                        self.homeList.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
                        self.homeList.reverse()
                        self.refreshControl.endRefreshing()
                    }
                    Singleton.setUpTableViewDisplay(self.HomeWorkTableView, headerView:"","HomeWorkTableViewCell")
                    self.HomeWorkTableView.delegate = self
                    self.HomeWorkTableView.dataSource = self
                    self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                    self.refreshControl.addTarget(self, action: #selector(self.refresh), for:.valueChanged)
                    self.HomeWorkTableView.addSubview(self.refreshControl)
                    self.HomeWorkTableView.bounces = true
                    self.HomeWorkTableView.estimatedRowHeight = 100
                    self.HomeWorkTableView.rowHeight = UITableView.automaticDimension
                    ProgressLoader.shared.hideLoader()
                }
                else
                {
                    self.HomeWorkTableView.isHidden = true
                    self.emptyData.isHidden = false
                    ProgressLoader.shared.hideLoader()
                }
            }
            else
            {
                self.HomeWorkTableView.isHidden = true
                self.emptyData.isHidden = false
                ProgressLoader.shared.hideLoader()
            }
            
            
        })
    }
    @objc func refresh(sender:AnyObject) {
     
        self.fetchhomeWorkList()
          // Code to refresh table view
       }

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
                             self.view.makeToast("No Homework File Found!!", duration: 1.0, position: .center)
                            ProgressLoader.shared.hideLoader()
                          }
                          ProgressLoader.shared.hideLoader()
                      })
        }
        else{
              ProgressLoader.shared.hideLoader()
             self.view.makeToast("No Homework File Found!!", duration: 1.0, position: .center)
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
