//
//  TeacherDashboardController.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData
import Firebase


struct FacultyDashBoard {
  
    let sectionId : String!
    let sectionName : String!
    let SubjectName : String!
    let SubjectId: String!
    let LessonPlanId : String!
    let Studyprogress : Int!
    let Checked : Int!
    
    init(_ dict:[String:Any]) {
        
        sectionId = dict["sectionId"] as? String
        sectionName = dict["sectionName"] as? String
        SubjectName = dict["subjectName"] as? String
        SubjectId = dict["subjectId"] as? String
        LessonPlanId = dict["lessonPlanId"] as? String
        Studyprogress = dict["studyprogress"] as? Int
        Checked = dict["checked"] as? Int
    }
}

struct SectionAttendance {
    var sectionName : String!
    var PresentCount : String!
    var AbsentCount : String!
    var LeaveCount : String!
    
    init(_ dict:[String:Any]) {
        sectionName = dict["sectionName"] as? String
        PresentCount = dict["PresentCount"] as? String
        AbsentCount = dict["AbsentCount"] as? String
        LeaveCount = dict["LeaveCount"] as? String
    }
}
    struct LatestChat {
        var SenderName : String!
        var Message : String!
        var SenderId : String!
        var RecepientId : String!
        var CreatedOn : String!
        var Class : String!
        var Section : String!
        
        init(_ dict:[String:Any]) {
           SenderName = dict["SenderName"] as? String
           Message = dict["Message"] as? String
           SenderId = dict["SenderId"] as? String
           RecepientId = dict["RecepientId"] as? String
           CreatedOn = dict["CreatedOn"] as? String
           Class = dict["Class"] as? String
           Section = dict["Section"] as? String
   
        }
    }

extension TeacherDashboardController {
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 60
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
    }
}


class TeacherDashboardController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emptyData: UIImageView!
    @IBOutlet weak var dashBoardCollectionView: UICollectionView!
    @IBOutlet weak var TeacherDashboardList: UITableView!
    @IBOutlet weak var classHeaderLabel: UILabel!
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    var facultyDashBoard = [FacultyDashBoard]()
    var sectionAttendance = [SectionAttendance]()
    var latestChat = [LatestChat]()
    var profileDict = [String:Any]()
    var userDict = [String:Any]()
    var registrationID : String = ""
    var userID : String = ""
    var ContactID : String = ""
    
    private let imageView = UIImageView(image:#imageLiteral(resourceName: "profile"))
    private var shoulResize: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Dashboard"
        self.navigationItem.prompt = ""
        self.classHeaderLabel.text = ""
        if UIDevice.current.orientation.isPortrait {
            shoulResize = true
        } else if UIDevice.current.orientation.isLandscape {
            shoulResize = false
        }
        
        self.scrollView.contentSize = CGSize(width:self.view.frame.width, height:self.scrollView.frame.height)
        self.emptyData.isHidden = true
        registrationID = (UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!
        userID = (UserDefaults.standard.value(forKey:"userID") as? String)!
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("0000000000000  ",self.registrationID)
     self.getProfileData()
        self.getDashBoardData(regID:self.registrationID)
        self.TeacherDashboardList.separatorStyle = .none
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        let serverString = formatter.string(from:date)
        print(serverString)
        
        if (UserDefaults.standard.value(forKey:"Date") as? String) != serverString {
            UserDefaults.standard.set(false, forKey:"AttendanceMarked")
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        guard let shoulResize = shoulResize
//            else {
//
//       //         assertionFailure("shoulResize wasn't set. reason could be non-handled device orientation state"); return
//
//        }
//        
//        if shoulResize{
//           
//        }
        
         moveAndResizeImageForPortrait()
    }
    
    // MARK: - Scroll View Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let shoulResize = shoulResize
            else { assertionFailure("shoulResize wasn't set. reason could be non-handled device orientation state"); return }
        
        if shoulResize {
            moveAndResizeImageForPortrait()
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .white
        label.text =  ((self.userDict["ApplicantFullName"] as? String)!) //+ "\n" + (self.userDict["ID"] as? String)!
        self.navigationItem.titleView = label
        self.tabBarItem.title = "Dashboard"
    
        navigationController?.navigationBar.prefersLargeTitles = true
      
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    private func moveAndResizeImageForPortrait() {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    
    
    func setUpCollectionViewDisplay()  {
        self.dashBoardCollectionView.bounces = false
        self.dashBoardCollectionView.register(UINib(nibName:"dashboardCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"dashboardCollectionViewCell")
        self.dashBoardCollectionView.collectionViewLayout.invalidateLayout()
        self.dashBoardCollectionView.delegate = self
        self.dashBoardCollectionView.dataSource = self
        self.dashBoardCollectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionAttendance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "TeacherDashboardTableViewCell") as? TeacherDashboardTableViewCell
        
        let total = (CGFloat(Double(self.sectionAttendance[indexPath.row].AbsentCount)!) + CGFloat(Double(self.sectionAttendance[indexPath.row].PresentCount)!) + CGFloat(Double(self.sectionAttendance[indexPath.row].LeaveCount)!))
        cell?.subjectProgressBar1.maxValue = (CGFloat(Double(self.sectionAttendance[indexPath.row].PresentCount)!)) / total
        
        cell?.subjectProgressBar2.maxValue = (CGFloat(Double(self.sectionAttendance[indexPath.row].AbsentCount)!)) / total
        
        cell?.subjectProgressBar3.maxValue = (CGFloat(Double(self.sectionAttendance[indexPath.row].LeaveCount)!)) / total
        // Present
        cell?.subjectProgressBar1?.progressStrokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        cell?.subjectProgressBar1?.progressColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            cell?.subjectProgressBar1?.value = CGFloat(Double(self.sectionAttendance[indexPath.row].PresentCount)!)
            
        }, completion: { finished in
        })
        // Absent
        cell?.subjectProgressBar2?.progressStrokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        cell?.subjectProgressBar2?.progressColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            cell?.subjectProgressBar2?.value = CGFloat(Double(self.sectionAttendance[indexPath.row].AbsentCount)!)
            
        }, completion: { finished in
        })
        
        // Leave
        cell?.subjectProgressBar3?.progressStrokeColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
           cell?.subjectProgressBar3?.progressColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
           UIView.animate(withDuration:1.0, delay: 0.0, options:.curveEaseOut, animations: {
               self.view.layoutIfNeeded()
               cell?.subjectProgressBar3?.value = CGFloat(Double(self.sectionAttendance[indexPath.row].LeaveCount)!)
               
           }, completion: { finished in
           })
        
        
        cell?.subjectLabel.text = sectionAttendance[indexPath.row].sectionName
        cell?.subject1percentage.text = String(self.sectionAttendance[indexPath.row].PresentCount)
        cell?.subject2Percentage.text = String(self.sectionAttendance[indexPath.row].AbsentCount)
        cell?.subject3percentage.text = String(self.sectionAttendance[indexPath.row].LeaveCount)
        
        
               
        
        
        
        
        cell!.selectionStyle = .none
        return cell!
    }
    //UICollectionViewDelegateFlowLayout method
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/2.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.latestChat.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier:"dashboardCollectionViewCell", for: indexPath)
            as? dashboardCollectionViewCell
        
        cell?.timings.text =  latestChat[indexPath.row].CreatedOn
        cell?.subject1.text = latestChat[indexPath.row].SenderName //+ " (" + latestChat[indexPath.row].Class + "-" + latestChat[indexPath.row].Section + ")"
        cell?.subject2.text = latestChat[indexPath.row].Message
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "facultyChat") as! FacultyDiscussionViewController
        destViewController.studentid =  self.latestChat[indexPath.row].SenderId
        destViewController.studentName = self.latestChat[indexPath.row].SenderName
        self.navigationController?.pushViewController(destViewController, animated: true)
        
    }
    
    func getDashBoardData(regID:String) {
        WebService.shared.getFacultyDashBoard(registrationValue:regID, UserID: userID, completion:{(response, error) in
            if error == nil , let responseDict = response {
                
                ProgressLoader.shared.showLoader(withText:"Fetching Dashboard..")
                
                if let latestChatDict = responseDict["LatestChat"].arrayObject as? [[String:Any]]{
                    self.latestChat.removeAll()
                    if latestChatDict.count > 0{
                        self.emptyData.isHidden = true
                        self.dashBoardCollectionView.isHidden = false
                        for data in latestChatDict {
                            let chat = LatestChat(data)
                            self.latestChat.append(chat)
                            self.setUpCollectionViewDisplay()
                        }
                    }
                        
                    else
                    {
                        self.dashBoardCollectionView.isHidden = true
                        self.emptyData.isHidden = false
                    }
                    
                }
                
                if let dashBoardDict = responseDict["Dashboard_List"]["SectionAttendance"].arrayObject as? [[String:Any]]{
                    
                    self.sectionAttendance.removeAll()
                    for data in dashBoardDict {
                        let attendance = SectionAttendance(data)
                        self.sectionAttendance.append(attendance)
                        Singleton.setUpTableViewDisplay(self.TeacherDashboardList, headerView: "", "TeacherDashboardTableViewCell")
                        self.TeacherDashboardList.delegate = self
                        self.TeacherDashboardList.dataSource = self
                    }
                }
                ProgressLoader.shared.hideLoader()
                
            }else{
                self.dashBoardCollectionView.isHidden = true
                self.emptyData.isHidden = false
                ProgressLoader.shared.hideLoader()
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    //Mark : Profile
    func fetchFacultyProfileData() {
        TeacherCoreDatacontroller.shared.fetchFacultyDataRequest(regID:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.userDict = responseDict as! [String:Any]
                
                if self.userDict.count > 0 {
                    self.setupUI()
                    self.imageView.layer.cornerRadius = self.imageView.bounds.width/2.0
                    self.imageView.clipsToBounds = true
                    let FacultyImage = UIImage.decodeBase64(toImage:(self.userDict["Entityimage"] as? String))
                    print(self.userDict["Entityimage"] as? String)
                    let imgData = FacultyImage.pngData()
                    if imgData != nil {
                        self.imageView.image = UIImage(data: imgData!)
                    }
                    else{
                      if(self.userDict["GenderText"] as? String) == "Female" {
                          self.imageView.image = #imageLiteral(resourceName: "female")
                      }
                      else{
                          self.imageView.image = #imageLiteral(resourceName: "profile")
                      }
                    }
                    
                    if self.userDict["IsPrincipal"] as? Bool == true {
                        self.classHeaderLabel.text = ""
                        if self.tabBarController?.tabBar.items![3].title == "HomeWork"
                        {
                            if let tabBarController = self.tabBarController {
                                let indexToRemove = 3
                                    var viewControllers = tabBarController.viewControllers
                                    viewControllers?.remove(at: indexToRemove)
                                    tabBarController.viewControllers = viewControllers
                                }
                           
                        }
    
//                        if self.tabBarController?.tabBar.items![2].title == "Attendance"
//                        {
//                            if let tabBarController = self.tabBarController {
//                                let indexToRemove = 2
//                                if indexToRemove < tabBarController.viewControllers!.count {
//                                    var viewControllers = tabBarController.viewControllers
//                                    viewControllers?.remove(at: indexToRemove)
//                                    tabBarController.viewControllers = viewControllers
//                                }
//                            }
//                            
//                        }
                    }
                    else {
                     self.classHeaderLabel.text = "Class Strength"
                    }
                    Messaging.messaging().subscribe(toTopic:"employee") { error in
                        print(error as Any)
                        print("App Subscribed")
                    }
                    Messaging.messaging().subscribe(toTopic:"whole_school") { error in
                        print(error as Any)
                        print("App Subscribed")
                    }
                }
            }else{
                self.getProfileData()
                debugPrint(error?.localizedDescription ?? "Profile Not found")
            }
        })
    }

    func getProfileData() {
        
        WebService.shared.GetFacultyProfiledetails(registrationValue:registrationID,completion:{(response,error) in
            
            if error == nil , let responseDict = response {
                if responseDict.count > 0 {
                    print(responseDict)
                    self.profileDict = ["DateOfBirth" : responseDict["DateOfBirth"].stringValue,
                                        "FatherName" : responseDict["FatherName"].stringValue,
                                        "MotherName" :responseDict["MotherName"].stringValue,
                                        "GenderText" : responseDict["GenderText"].stringValue,
                                        "ApplicantFullName" : responseDict["ApplicantFullName"].stringValue,
                                        "PrimaryEmailAddress" : responseDict["PrimaryEmailAddress"].stringValue,
                                        "PrimaryMobileNumber" : responseDict["PrimaryMobileNumber"].stringValue,
                                        "CategoryText" : responseDict["CategoryText"].stringValue,
                                        "Entityimage" : responseDict["Entityimage"].stringValue,
                                        "HouseNo" : responseDict["HouseNo"].stringValue,
                                        "StreetNo" : responseDict["StreetNo"].stringValue,
                                        "City": responseDict["City"].stringValue,
                                        "State" : responseDict["State"].stringValue,
                                        "Country" : responseDict["Country"].stringValue,
                                        "QualificationName": responseDict["QualificationName"].stringValue,
                                        "Year" : responseDict["Year"].stringValue,
                                        "CGPA" : responseDict["CGPA"].doubleValue,
                                        "PostalCode" : responseDict["PostalCode"].stringValue,
                                        "ClassName" : responseDict["className"].stringValue,
                                        "ID" : responseDict["ID"].stringValue,
                                        "Percentage" : responseDict["Percentage"].stringValue,
                                        "AddressLine" : responseDict["AddressLine"].stringValue,
                                        "AllowNotification" : responseDict["AllowNotification"].boolValue,
                                        "IsPrincipal" : responseDict["IsPrincipal"].boolValue
                        ] as [String : Any]

                    TeacherCoreDatacontroller.shared.insertAndUpdateFacultyProfile(registrationID:self.registrationID, jsonObject:self.profileDict)
                    
                }
                self.fetchFacultyProfileData()
                
            }else{
                self.dashBoardCollectionView.isHidden = true
                               self.emptyData.isHidden = false
                
            }
            
        })
    }
    
}

 
