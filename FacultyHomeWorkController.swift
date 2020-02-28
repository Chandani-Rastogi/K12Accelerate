//
//  FacultyHomeWorkController.swift
//  eLiteSIS
//
//  Created by apar on 13/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData
import QuickLook
import PDFKit
import MobileCoreServices


class FacultyHomeWorkController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    
    @IBOutlet weak var emptyData: UIImageView!
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
    var numberOfLines: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HomeWorkTableView.delegate = nil
        self.HomeWorkTableView.dataSource = nil
        self.HomeWorkTableView.separatorColor = .clear
        self.HomeWorkTableView.backgroundColor = .clear
        self.HomeWorkTableView.refreshControl = refreshControl
        self.emptyData.isHidden = true
        self.getHomeWorkList(facultyID:(UserDefaults.standard.value(forKey:"userID") as? String)!)
       // self.fetchFacultyProfileData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           let date = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyy"
           let serverString = formatter.string(from:date)
           print(serverString)
           
           if (UserDefaults.standard.value(forKey:"Date") as? String) != serverString {
               UserDefaults.standard.set(false, forKey:"AttendanceMarked")
           }
       }
    @objc func refresh(sender:AnyObject) {
        self.getHomeWorkList(facultyID:(UserDefaults.standard.value(forKey:"userID") as? String)!)
        // Code to refresh table view
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return UITableView.automaticDimension
   // return 100
     
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"HomeWorkTableViewCell") as! HomeWorkTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.assignmentLabel.text = (self.homeList[indexPath.row].sis_name) ?? "NA"
        cell.classLabel.text = self.homeList[indexPath.row].new_subject + "\n" + Date.getFormattedDate(string:(self.homeList[indexPath.row].createdon!) , formatter:"dd-MMM-yyyy")
        cell.homeworkDesciprtion.text = self.homeList[indexPath.row].sis_homeworkdescription
        cell.downLoadButton.tag = indexPath.row
        cell.clipsToBounds = true
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
        let index = sender.tag
        self.downloadAssignment(assignmentValue:self.homeList[index].notesId)
    }
    
    // Mark : Webservices
    func getHomeWorkList(facultyID:String) {
        
        ProgressLoader.shared.showLoader(withText:"Fetching HomeWork")
        WebService.shared.getFacultyHomeWorkList(facultyID:facultyID,completion: {(response, error) in
            if error == nil , let responseDict = response {
                if let homeworkDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    if homeworkDict.count > 0 {
                        self.HomeWorkTableView.isHidden = false
                        self.emptyData.isHidden = true
                        for obj in homeworkDict {
                        TeacherCoreDatacontroller.shared.insertAndUpdateHomeWorkList(facultyID:facultyID, subject:obj["createdon"] as! String, jsonObject:[obj])
                        }
                        self.fetchhomeWorkList(facultyID:facultyID)
                    }
                    else
                    {
                        ProgressLoader.shared.hideLoader()
                        self.HomeWorkTableView.isHidden = true
                        self.emptyData.isHidden = false
                    }
                }
                ProgressLoader.shared.hideLoader()
            }
            else
            {
                self.HomeWorkTableView.isHidden = true
                self.emptyData.isHidden = false
                ProgressLoader.shared.hideLoader()
                self.refreshControl.endRefreshing()
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchhomeWorkList(facultyID :String) {
        
        TeacherCoreDatacontroller.shared.fetchHomeworkList(facultyID:facultyID, completion: {(response, error) in if error == nil , let responseDict = response {
            let itemJsonArray = (Singleton.convertToJSONArray(moArray: responseDict as! [NSManagedObject])) as? [[String:Any]]
            self.homeList.removeAll()
            if itemJsonArray!.count > 0 {
                for obj in itemJsonArray! {
                    print(obj)
                    
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
                
            }
            
            }})
    }
    
    
    func downloadAssignment(assignmentValue :String) {
         ProgressLoader.shared.showLoader(withText: "Downloading...")
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
            self.view.makeToast("No Homework File Found!!", duration: 1.0, position: .center)
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
    
    
    @IBAction func uploadHomeWorkButton(_ sender: Any) {
        AlertManager.shared.showAlertWith(title:" Do you want to add new home work ?", message: "")
        
    }
    
    
}

extension UILabel {

    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
