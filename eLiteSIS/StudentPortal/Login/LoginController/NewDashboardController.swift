//
//  NewDashboardController.swift
//  eLiteSIS
//
//  Created by apar on 07/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData
import Charts
import QuickLook
import PDFKit
import MobileCoreServices
import Firebase

struct BarMonthPercentage {
    
    let year : String!
    let month : String!
    let percentage : Double!
    
    init(_ dict:[String:Any]) {
        year = dict["year"] as? String
        month = dict["month"] as? String
        percentage = dict["percentage"] as? Double
    }
    
}

struct HomeWork {
    let new_subject : String!
    let sis_name: String!
    let notesId : String!
    let new_enddate: String!
    let new_startdate: String!
    let createdon : String!
    let sis_homeworkdescription: String!
    var startDate : Date = Date()

    init(_ dict:[String:Any]) {
        self.new_subject = dict["subject"] as? String
        self.sis_name = dict["sisName"] as? String
        self.notesId = dict["notesID"] as? String
        self.new_enddate = dict["endDate"] as? String
        self.new_startdate = dict["startDate"] as? String
        self.createdon = dict["createdOn"] as? String
        self.sis_homeworkdescription = dict["homedescription"] as? String
        let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let startdate = dateFormatter.date(from:(dict["createdOn"] as? String)!) {
            self.startDate = startdate
        }
    }
}

class NewDashboardController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"
      let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
  
    var homeList = [HomeWork]()
    var chartData = [BarMonthPercentage]()
    var attendanceData = [Attendance]()
    var presentMonthPercantage = [PresentPercentage]()
    var regID : String = ""
    var profileDict = [String:Any]()
    var presenList = [String]()
    var absentList = [String]()
    var weekendList = [String]()
    
    var months: [String]!
    var unitsSold = [Double]()
    var abc = [Double]()
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    let pdfView = PDFView()
    let quickLookController = QLPreviewController()
    var fileURLs = [URL]()
    
    @IBOutlet weak var emptyData: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.isUserInteractionEnabled = false
        self.emptyData.isHidden = true
        barChartView.noDataText = "You need to provide data for the chart."
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        regID = (UserDefaults.standard.object(forKey: "_sis_registration_value") as? String)!
        self.getProfileData()
        self.fetchProfile(regid:regID)
        
        axisFormatDelegate = self as! IAxisValueFormatter
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        barChartView.noDataText = "No Chart Found!!"
        // Do any additional setup after loading the view.
    }
    
    func setChart(dataEntryX forX:[String],dataEntryY forY: [Double]) {
    
            var dataEntries:[BarChartDataEntry] = []
                   for i in 0..<forX.count {
                       let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]) , data: months as AnyObject?)
                       dataEntries.append(dataEntry)
                   }
                   let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Attendance in percentage")
                   chartDataSet.colors = [UIColor.blue]
                   let chartData = BarChartData(dataSet: chartDataSet)
                   barChartView.data = chartData

                   let xAxisValue = barChartView.xAxis
                   xAxisValue.valueFormatter = axisFormatDelegate
                   barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
       
       

    }
    func getProfileData() {
        
        WebService.shared.getUserProfile(registrationValue:regID,completion:{(response,error) in
         
            if error == nil , let responseDict = response{
                if responseDict.count>0 {
                    print(responseDict)
                    
                    let currentclasssession:String? = responseDict["value"][0]["_sis_currentclasssession_value"].stringValue
                    UserDefaults.standard.set(currentclasssession, forKey: "_sis_currentclasssession_value")
                    
                    let sisectionvalue = responseDict["value"][0]["_sis_section_value"].stringValue
                    UserDefaults.standard.set(sisectionvalue, forKey:"_sis_section_value")
                    
                    print(sisectionvalue)
                    print(UserDefaults.standard.value(forKey:"_sis_section_value")!)
                    
                    
                    let classvalue = responseDict["value"][0]["_sis_class_value"].stringValue
                    UserDefaults.standard.set(classvalue, forKey:"_sis_class_value")
                    
                    
                    let studentid:String? = responseDict["value"][0]["sis_studentid"].stringValue
                    UserDefaults.standard.set(studentid, forKey: "sis_studentid")
                    
                    let studentValue:String? = responseDict["value"][0]["_sis_studentname_value"].stringValue
                    UserDefaults.standard.set(studentValue, forKey: "_sis_studentname_value")
                    
                    let profileImage:String? = responseDict["value"][0]["entityimage"].stringValue
                    let studentImage = UIImage.decodeBase64(toImage:profileImage)
                    let imgData = studentImage.pngData()
                    UserDefaults.standard.set(imgData, forKey: "entityimage")
                    
                    let studentName:String? = responseDict["value"][0]["sis_name"].stringValue
                    UserDefaults.standard.set(studentName, forKey: "studentName")
                    
                    let registration:String? = responseDict["value"][0]["_sis_registration"].stringValue
                    UserDefaults.standard.set(registration, forKey: "_sis_registration")
                    
                    let userID : String? = UserDefaults.standard.object(forKey: "userID") as? String
                    
                    if let profiledict = responseDict["value"].arrayObject as? [[String:Any]]{
                        for data in profiledict {
                            CoreDataController.sharedInstance.insertAndUpdateUserProfile(registrationID:self.regID, jsonObject:[data])
                        }
                        
                    }
                    
                    
                    self.fetchProfile(regid:self.regID)
                    self.getHomeWorkList(UserID:userID!)
                    
                }
                
            }else{
                ProgressLoader.shared.hideLoader()
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchProfile(regid:String) {
        
        self.fetchhomeWorkList(userId:(UserDefaults.standard.object(forKey: "userID") as? String)!)
        
        CoreDataController.sharedInstance.fetchProfileDataRequest(regID:regid, completion:{(response, error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0{
                    for  data in itemsJsonArray! {
                        self.profileDict  = (data as? [String:Any])!
                        self.nameLabel.text = self.profileDict["name"] as? String
                        let studentImage = UIImage.decodeBase64(toImage:(self.profileDict["entityImage"] as? String))
                        let imgData = studentImage.pngData()
                        self.imageView.layer.cornerRadius = self.imageView.bounds.width/2.0
                        self.imageView.clipsToBounds = true
                        self.imageView.image = UIImage(data:imgData!)
                        self.schoolName.text = (self.profileDict["programName"] as? String)!
                        
                        Messaging.messaging().subscribe(toTopic:(self.profileDict["sectionValue"] as? String)!) { error in
                            print(self.profileDict["sectionValue"] as? String)
                            print(error as Any)
                            print("App Subscribed")
                        }
                        Messaging.messaging().subscribe(toTopic:UserDefaults.standard.value(forKey:"_sis_class_value") as! String) { error in
                            print(error as Any)
                            print("App Subscribed")
                        }
                        Messaging.messaging().subscribe(toTopic:"whole_school") { error in
                            print(error as Any)
                            print("App Subscribed")
                        }
                        
                    }
                }
                
            }else{
                debugPrint(error?.localizedDescription ?? "Profile Not Found")
            }
        })
        
    }
    
    func getHomeWorkList(UserID:String) {
        WebService.shared.getHomeWorkList(userID:UserID,completion: {(response, error) in
            if error == nil , let responseDict = response {
                if let homeworkDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    if homeworkDict.count > 0{
                        self.collectionView.isHidden = false
                                        self.emptyData.isHidden = true
                        for obj in homeworkDict {
                                               CoreDataController.sharedInstance.insertAndUpdateHomeWorkList(userID:UserID, subject:obj["createdon"] as! String, jsonObject:[obj])
                                           }
                                           self.fetchhomeWorkList(userId:UserID)
                        
                    }
                    else
                    {
                        self.collectionView.isHidden = true
                        self.emptyData.isHidden = false
                    }
                    
                      self.getStudentAttendance()
                }
            }
            else
            {
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchhomeWorkList(userId:String) {
        
        CoreDataController.sharedInstance.fetchHomeworkList(userID:userId, completion: {(response, error) in if error == nil , let responseDict = response {
            let itemJsonArray = (Singleton.convertToJSONArray(moArray: responseDict as! [NSManagedObject])) as? [[String:Any]]
            if itemJsonArray!.count > 0 {
                self.homeList.removeAll()
                for obj in itemJsonArray! {
                    let list = HomeWork(obj)
                    self.homeList.append(list)
                   
                }
                self.setUpCollectionViewDisplay()
                
            }
            }})
    }
    
    func downloadAssignment(assignmentValue :String) {
        
        if assignmentValue.count > 0 {
            
            ProgressLoader.shared.showLoader(withText: "Downloading...")
            WebService.shared.DownloadHomeWorktList(notesID:assignmentValue,completion:{(response, error) in
                          if error == nil , let responseDict = response {
                              if responseDict.count > 0 {
                               
                                   let filename = responseDict["value"][0]["filename"].stringValue
                                 let result = filename.filter { !$0.isNewline && !$0.isWhitespace }
                                  let documentBody = responseDict["value"][0]["documentbody"].stringValue
                                   self.saveBase64StringToPDF(documentBody, fileName: result)
                              }
                          }else{
                       
                            ProgressLoader.shared.hideLoader()
                          }
                          ProgressLoader.shared.hideLoader()
                      })
        }
        else {
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
    
    func setUpCollectionViewDisplay()  {
        
        self.collectionView.bounces = false
        self.collectionView.register(UINib(nibName:"homeworkCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"homeworkCollectionViewCell")
         self.collectionView.register(UINib(nibName:"ViewMoreCollectionCell", bundle:nil), forCellWithReuseIdentifier:"ViewMoreCollectionCell")
        
        //  self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        
    }
    
    
    //MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 10) / 2 //some width
        let height = width / 2.8 //ratio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.homeList.count >= 3
        {
            return 4
        }
        else if self.homeList.count == 2 {
           return 3
        }
        else if self.homeList.count == 1 {
            return 2
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.homeList.count >= 3
        {
            if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewMoreCollectionCell", for: indexPath)
                return cell
            }
        }
        else if self.homeList.count == 2 {
            if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewMoreCollectionCell", for: indexPath)
                return cell
            }
        }
        else if self.homeList.count == 1 {
            if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewMoreCollectionCell", for: indexPath)
                return cell
            }
        }
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier:"homeworkCollectionViewCell", for: indexPath)
            as? homeworkCollectionViewCell
        
        cell?.assignmentNameLabel.text = self.homeList[indexPath.row].sis_name
        cell?.dateLabel.text =  Date.getFormattedDate(string:(self.homeList[indexPath.row].createdon)!, formatter: "dd-MMM-yyyy")
        cell?.downloadButton.tag = indexPath.row
        if (self.homeList[indexPath.row].notesId).count > 0 {
            cell?.downloadButton.isHidden = false
            cell?.downloadButton.addTarget(self, action: #selector(downloadButtonSelected), for: .touchUpInside)
        }
        else {
            cell?.downloadButton.isHidden = true
        }
       
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var destViewController : UIViewController
        
        if self.homeList.count >= 3
        {
            if indexPath.row == 3 {
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "homework")
                self.navigationController?.pushViewController(destViewController, animated: true)
            }
        }
        else if self.homeList.count == 2 {
            if indexPath.row == 2 {
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "homework")
                self.navigationController?.pushViewController(destViewController, animated: true)
            }
        }
        else if self.homeList.count == 1 {
            if indexPath.row == 1 {
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "homework")
                self.navigationController?.pushViewController(destViewController, animated: true)
            }
        }
        if indexPath.row == 3  {
            
        }
    }
    @objc func downloadButtonSelected(sender: UIButton){
        let index = sender.tag
        self.downloadAssignment(assignmentValue:self.homeList[index].notesId)
    }
    
    
    // Mark : Attedance
     func getStudentAttendance() {
       //   ProgressLoader.shared.showLoader(withText:"")
            guard let StudentID = UserDefaults.standard.object(forKey:"sis_studentid") as? String else {
                return
            }
            WebService.shared.GetStudentAttendance(studentID:StudentID,completion:{(response, error) in
                if error == nil , let responseDict = response {
                  
                    if let attendanceDict = responseDict["value"].arrayObject as? [[String:Any]]{
                        for monthAttendance in attendanceDict {
                            let attendance = Attendance(fromDictionary:monthAttendance)
                            self.attendanceData.append(attendance)
                            self.setUpAttendance(result:attendance.newAttendancedata, session:attendance.newClassSession.session)
                               ProgressLoader.shared.hideLoader()
                        }
                        
                        self.fetchAttendance()
                    }
                }else{
                    ProgressLoader.shared.hideLoader()
                  
                }
                ProgressLoader.shared.hideLoader()
            })
        }
        
    
    func fetchAttendance() {
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day , .month , .year], from: date as Date)
        let year =  components.year
        
        CoreDataController.sharedInstance.fetchPercentageDataRequest(regID:regID, completion:{(response,error) in
            if error == nil, let resposneDict = response {
                let itemJsonArray = (Singleton.convertToJSONArray(moArray: resposneDict as! [NSManagedObject])) as? [[String:Any]]
                if itemJsonArray!.count > 0 {
                    self.chartData.removeAll()
                    self.unitsSold = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                    for obj in itemJsonArray! {
                      
                        let list = BarMonthPercentage(obj)
                        self.chartData.append(list)
                        
                        self.chartData.sort(by: { $0.month.compare($1.month) == .orderedAscending })
                        
                        let monthName = DateFormatter().monthSymbols![Int(list.month)! - 1]
                        let m =   monthName.dropLast(monthName.count - 3)

                        for i in 0..<self.months.count {
                            if self.months[i] == m {
                                if Int(list.year) == year {
                                    self.unitsSold[i] = list.percentage
                                }
                                else{
                                    
                                    self.unitsSold[i] = list.percentage
                                }
                                self.setChart(dataEntryX: self.months, dataEntryY: self.unitsSold)
                            }
                        }
                    
                    }
                    self.setUpCollectionViewDisplay()
                }
            }
        })
        
        
        
    }
    /*    func setUpAttendance(result: String, session: String) {
            var year : String = ""
            let resultList = result.split(separator: "[")
            var month : Int = 0
             var index : Int = 0
            for it in resultList{
                if (it != "") {
                    month = Int((it as NSString).substring(with:NSMakeRange(0, 2)))!
                    let attendance = (it as NSString).substring(from: 3)
                    let pCount = attendance.numberOfOccurrences("P") // aCount = 4
                    let aCount = attendance.numberOfOccurrences("A") // aCount = 4
                   
                    if month < 4 {
                        index = 0
                        year = session.substring(from:5)
                       // print(year)
                    }else{
                        index = 0
                        year = session.substring(to: 3)
                    }
                    
                    let finalString = String(month) + "-" + year
    
                    CoreDataController.sharedInstance.insertAndUpdateAttenadancePercentage(present:Int16(pCount), absent:Int16(aCount), dateString:finalString)
                    
                }
             
            }
        }*/
    
    func setUpAttendance(result: String, session: String) {
           
           var year : String = ""
           let resultList = result.split(separator: "[")
           var index : Int = 0
           var dateString : String = ""
           var month : Int = 0
           for it in resultList {
               if (it != "") {
                   month = Int((it as NSString).substring(with:NSMakeRange(0, 2)))!
                   let attendance = (it as NSString).substring(from: 3)
                   let pCount = attendance.numberOfOccurrences("P") // aCount = 4
                   let aCount = attendance.numberOfOccurrences("A") // aCount = 4
                   let lCount = attendance.numberOfOccurrences("L")
                   let percentage : Int
                   if month < 4 {
                       index = 0
                       year = session.substring(from:5)
                       
                       if pCount != 0 && aCount == 0 {
                            percentage = 100
                       }
                       else {
                       let total = (pCount + aCount)
                           if total > 0 {
                               percentage = ((pCount) * 100) / total
                             
                           }
                           else{
                           percentage = 0
                       }
                       }
                       
                       CoreDataController.sharedInstance.insertAndUpdateStudentAttendance(month:String(month), percentage: percentage, year:year, registrationID:(UserDefaults.standard.object(forKey:"_sis_registration_value") as? String)! )
                       
                       
                   }else{
                       index = 0
                       year = session.substring(to: 3)
                       if pCount != 0 && aCount == 0 {
                           percentage = 100
                       }
                       else {
                           let total = (pCount + aCount)
                           if total > 0 {
                               percentage = ((pCount) * 100) / total
                             
                           }
                           else{
                               percentage = 0
                           }
                           
                       }
                       CoreDataController.sharedInstance.insertAndUpdateStudentAttendance(month:String(month), percentage: percentage, year:year, registrationID:(UserDefaults.standard.object(forKey:"_sis_registration_value") as? String)! )
                   }
                   
                   
                   let finalString = String(month) + "-" + year
                   
                CoreDataController.sharedInstance.insertAndUpdateAttenadancePercentage(present:Int16(pCount), absent:Int16(aCount), leave: Int16(lCount), dateString:finalString)
                   
                   
                   for char in attendance{
                       index = index + 1
                       
                       if char == "P" {
                           
                           if month < 10  {
                               if index < 10{
                                   dateString =  year + "-0" + String(month) + "-0" + String(index)
                               }
                               else{
                                   dateString =  year + "-0" + String(month) + "-" + String(index)
                               }
                           }
                           else{
                               
                               dateString =  year + "-" + String(month) + "-" + String(index)
                           }
                           self.presenList.append(dateString)
                           
                       }
                       
                       if char == "A"{
                           if month < 10  {
                               
                               if index < 10{
                                   dateString =  year + "-0" + String(month) + "-0" + String(index)
                               }
                               else{
                                   dateString =  year + "-0" + String(month) + "-" + String(index)
                               }
                           }
                           else{
                               
                               dateString =  year + "-" + String(month) + "-" + String(index)
                           }
                           self.absentList.append(dateString)
                           
                       }
                       if char == "W"{
                           if month < 10  {
                               
                               if index < 10{
                                   dateString =  year + "-0" + String(month) + "-0" + String(index)
                               }
                               else{
                                   dateString =  year + "-0" + String(month) + "-" + String(index)
                               }
                               
                           }
                           else{
                               
                               dateString =  year + "-" + String(month) + "-" + String(index)
                           }
                           self.weekendList.append(dateString)
                           
                       }
                   }
               }
           }
           
       }
    
}

extension NewDashboardController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return months[Int(value)]
    }
}


