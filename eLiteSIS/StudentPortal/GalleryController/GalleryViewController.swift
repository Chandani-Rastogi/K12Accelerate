//
//  GalleryViewController.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

struct GalleryFolders {
    let new_name : String!
    let entityimage : String!
    let new_albumsid : String!
    
    init(_ dict:[String:Any]) {
        self.new_name  = dict["name"] as? String
        self.entityimage = dict["entityImage"] as? String
        self.new_albumsid = dict["albumID"] as? String
    }
}

class GalleryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  

    @IBOutlet weak var galleryTableView: UITableView!
    
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    var galleryfolderList = [GalleryFolders]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Singleton.sharedInstance.deleteAllRecords(EntityName: "GalleryFolder")
        self.galleryTableView.dataSource = self
        self.galleryTableView.delegate = self
        self.galleryTableView.separatorColor = .clear
        self.galleryTableView.delegate = nil
        self.galleryTableView.dataSource = nil
         self.fetchGalleryFolder()
        self.getGalleryFolders()
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.galleryfolderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell") as! GalleryTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.imageNameLabel.text = self.galleryfolderList[indexPath.row].new_name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "image") as! ImageGalleryController
        destViewController.folderID = self.galleryfolderList[indexPath.row].new_albumsid
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    func getGalleryFolders(){
        WebService.shared.GetGalleryFolders(completion:{(response, error) in
            
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"Fetching Gallery Folder")
                if let galleryDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in galleryDict {
              CoreDataController.sharedInstance.insertAndUpdateGalleryFolder(albumID:(obj["new_albumsid"] as? String)!, jsonObject:[obj])
                    }
                    
                    
                    self.fetchGalleryFolder()
                }
                
            }else{
               // AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Holiday List")
                self.view.makeToast("No Gallery Found!!")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchGalleryFolder() {
    
        CoreDataController.sharedInstance.fetchGalleryFolderDataRequest(completion:{(response,error) in
            if error == nil , let responseDict = response {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:responseDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.galleryfolderList.removeAll()
                        for obj in itemsJsonArray! {
                            let gallery = GalleryFolders(obj)
                            self.galleryfolderList.append(gallery)
                            self.galleryTableView.delegate = self
                            self.galleryTableView.dataSource = self
                      Singleton.setUpTableViewDisplay(self.galleryTableView, headerView: "","GalleryTableViewCell")
                            self.galleryTableView.reloadData()
                        }
                }
            }
        })
    }
}

