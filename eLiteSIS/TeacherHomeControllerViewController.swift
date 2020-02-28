//
//  TeacherHomeControllerViewController.swift
//  eLiteSIS
//
//  Created by apar on 20/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class TeacherHomeControllerViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    var homeItems = [String]()
    var thumbImage = [UIImage]()
    var identifier = [String]()
    var userDict = [String:Any]()
    let width = UIScreen.main.bounds.width
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
   TeacherCoreDatacontroller.shared.fetchFacultyDataRequest(regID:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.userDict = responseDict as! [String:Any]
                
                if UserDefaults.standard.value(forKey:"new_rolecode") as? String == "212" {
                    if self.userDict["AllowNotification"] as? Bool == false {
                        self.homeItems = ["Homework","Upload Circular","Upload Syllabus","My Profile","View Notifications"]
                        self.thumbImage = [#imageLiteral(resourceName: "ic_homework_for_home"),#imageLiteral(resourceName: "ic_circular_for_home"),#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_profile_for_home"),#imageLiteral(resourceName: "ic_notification_for_home")]
                        self.identifier = ["facultyHomeWork","uploadcircular","uploadcircular","teacher_profile","Notification"]
                    }
                    else {
                        if self.userDict["IsPrincipal"] as? Bool == false {
                            self.homeItems = ["Homework","Upload Circular","Upload Syllabus","My Profile","View Notifications","Send Notification"]
                            self.thumbImage = [#imageLiteral(resourceName: "ic_homework_for_home"),#imageLiteral(resourceName: "ic_circular_for_home"),#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_profile_for_home") ,#imageLiteral(resourceName: "ic_notification_for_home"),#imageLiteral(resourceName: "ic_create_notification_for_home")]
                            self.identifier = ["facultyHomeWork","uploadcircular","uploadcircular","teacher_profile","Notification","custom"]
                        }
                        else {
                            self.homeItems = ["View Classwise Attendance","Homework Report","My Profile","View Notifications","Send Notification","View Feedback Report"]
                            
                            self.thumbImage = [#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_homework_for_home"),#imageLiteral(resourceName: "ic_profile_for_home") ,#imageLiteral(resourceName: "ic_notification_for_home"),#imageLiteral(resourceName: "ic_create_notification_for_home"),#imageLiteral(resourceName: "ic_teachers_for_home")]
                            self.identifier = ["getAttendance","homeworkReport","teacher_profile","Notification","custom","feedback"]
                        }
                    }
                }
                else {
                    if self.userDict["AllowNotification"] as? Bool == false {
                        self.homeItems = ["Attendance","Homework","Upload Circular","Upload Syllabus","Discussion","My Profile","View Notifications"]
                        self.thumbImage = [#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_homework_for_home"),#imageLiteral(resourceName: "ic_circular_for_home"),#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_discussion_for_home"),#imageLiteral(resourceName: "ic_profile_for_home"),#imageLiteral(resourceName: "ic_notification_for_home")]
                        self.identifier = ["st_attendance","facultyHomeWork","uploadcircular","uploadcircular","studentList","teacher_profile","Notification"]
                    }
                    else{
                        self.homeItems = ["Attendance","Homework","Upload Circular","Upload Syllabus","Discussion","My Profile","View Notifications","Send Notification"]
                        self.thumbImage = [#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_homework_for_home"),#imageLiteral(resourceName: "ic_circular_for_home"),#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_discussion_for_home"),#imageLiteral(resourceName: "ic_profile_for_home"),#imageLiteral(resourceName: "ic_notification_for_home"),#imageLiteral(resourceName: "ic_create_notification_for_home")]
                        self.identifier = ["st_attendance","facultyHomeWork","uploadcircular","uploadcircular","studentList","teacher_profile","Notification","custom"]
                    }
                }
                
            }else{
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
        })
        
        collectionView.register(UINib(nibName:"HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: width/3, height: width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        if indexPath.row == 0
        //        {
        //            return CGSize(width: width, height: width/3)
        //        }
        return CGSize(width: width/3, height: width/3);
        
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.homeItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.textLabel.text = self.homeItems[indexPath.row]
        cell.thumbImage.image = thumbImage[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.homeItems[indexPath.row] == "Upload Circular" {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:self.identifier[indexPath.row]) as? UploadCircularSyllabusController{
                vc.uploadtitle = "Upload Circular"
                vc.uploadType = 2
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if self.homeItems[indexPath.row] == "Upload Syllabus" {
           if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:self.identifier[indexPath.row]) as? UploadCircularSyllabusController{
                vc.uploadtitle = "Upload Syllabus"
                vc.uploadType = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier:self.identifier[indexPath.row])
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        
        
    }
    
    
}
