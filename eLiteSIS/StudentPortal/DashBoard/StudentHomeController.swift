//
//  StudentHomeController.swift
//  eLiteSIS
//
//  Created by apar on 20/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class StudentHomeController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var homeItems = [String]()
    var thumbImage = [UIImage]()
    var identifierDict = [String]()
     let width = UIScreen.main.bounds.width

    @IBOutlet weak var collectionView: UICollectionView!
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
       //"Leave Application""leave",#imageLiteral(resourceName: "ic_applyLeave_for_home")
       // "Teachers"3,#imageLiteral(resourceName: "ic_teachers_for_home"),"teacherList"
        homeItems = ["My Profile","Attendance","Homework","Circular","My Notifications","Syllabus","Discussions"]
        
        thumbImage = [#imageLiteral(resourceName: "ic_profile_for_home"),#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_homework_for_home"),#imageLiteral(resourceName: "ic_circular_for_home"),#imageLiteral(resourceName: "ic_notification_for_home"),#imageLiteral(resourceName: "ic_syllabus_for_home"),#imageLiteral(resourceName: "ic_discussion_for_home")]
        
        identifierDict = ["profile","attendance","homework","circular","Notification","circular","recentChat"]
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
        
        if self.homeItems[indexPath.row] == "Syllabus"
        {
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "circular") as! CircularViewController
            
            destViewController.uploadtitle = "Syllabus"
            destViewController.uploadType = 1
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        else if self.homeItems[indexPath.row] == "Circular"
        {
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "circular") as! CircularViewController
            destViewController.uploadtitle = "Circular"
            destViewController.uploadType = 2
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        else{
            let destViewController  = mainStoryboard.instantiateViewController(withIdentifier:self.identifierDict[indexPath.row])
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        
    }


}
