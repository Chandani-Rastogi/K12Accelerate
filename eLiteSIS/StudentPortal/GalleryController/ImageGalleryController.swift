//
//  ImageGalleryController.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import INSPhotoGallery

struct ImageItem {
    let name: String?
    let image: UIImage
    
    init(name: String?, image: UIImage) {
        self.name = name
        self.image = image
      

    }
}

class ImageGalleryController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
     
    @IBOutlet weak var imagecollectionView: UICollectionView!
    var folderID : String = ""
    var gallery: [ImageItem] = []
    var imgUrlArr = [UIImage]()
    var useCustomOverlay = false
    var imageNAme = UIImage()
    
    lazy var photosL: [INSPhotoViewable] = {
        return [
           
        ]
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if folderID.count > 0 {
           self.getImages()
        }
        imagecollectionView.delegate = self
        imagecollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    //UICollectionViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
           let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (self.imagecollectionView.frame.size.width - space) / 2.0
           return CGSize(width: size, height: size)
       }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.photosL.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleCollectionViewCell", for: indexPath) as! ExampleCollectionViewCell
        cell.populateWithPhoto(photosL[(indexPath as NSIndexPath).row])
        
        return cell
    }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ExampleCollectionViewCell
        let currentPhoto = photosL[(indexPath as NSIndexPath).row]
        let galleryPreview = INSPhotosViewController(photos: photosL, initialPhoto: currentPhoto, referenceView: cell)
        if useCustomOverlay {
            galleryPreview.overlayView = CustomOverlayView(frame: CGRect.zero)
        }
        
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photosL.firstIndex(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? ExampleCollectionViewCell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
 
    func getImages(){
        
        WebService.shared.GetImages(folderID:folderID,completion:{(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"Fetching Gallery Folder")
                let images = responseDict["value"].arrayValue
                for item in images {
                    let name = item["filename"].string
                    if let imgString = item["documentbody"].string {
                        self.imageNAme = UIImage.decodeBase64(toImage: imgString)
                        let imgItem = ImageItem(name: name, image:self.imageNAme)
                        self.gallery.append(imgItem)
                        self.imgUrlArr.append(imgItem.image)
                       
                    }
                       self.photosL  = self.imgUrlArr.map { INSPhoto(image:$0, thumbnailImage:self.imageNAme)}
                       self.imagecollectionView.reloadData()
                       ProgressLoader.shared.hideLoader()
                }
                
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Holiday List")
            }
            ProgressLoader.shared.hideLoader()
        })
        }
}

//MARK:- UIImage extension

extension UIImage {
    /*
     @brief decode image base64
     */
    static func decodeBase64(toImage strEncodeData: String!) -> UIImage {
        if strEncodeData != nil {
            if let decData = Data(base64Encoded: strEncodeData, options: .ignoreUnknownCharacters), strEncodeData.count > 0 {
                       return UIImage(data: decData)!
                   }
                   return UIImage()
        }
        else{
            return UIImage.init(named:"profile")!
        }
    }
    
    static func decodeNotificationBase64(toImage strEncodeData: String!) -> UIImage {
           if strEncodeData != nil {
               if let decData = Data(base64Encoded: strEncodeData, options: .ignoreUnknownCharacters), strEncodeData.count > 0 {
                          return UIImage(data: decData)!
                      }
                      return UIImage()
           }
           else{
               return UIImage.init(named:"download (2)")!
           }
       }
}

