//
//  UploadHomeWorkController.swift
//  eLiteSIS
//
//  Created by apar on 14/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import FileBrowser

struct GetAllSubject {
    var new_serialno : String!
    var subjectName : String!
    var subject_id : String!
    var new_lessonplanstatus : String!
    
    init(_ dict:[String:Any]) {
        self.new_serialno = dict["new_serialno"] as? String
        self.subjectName = dict["subjectName"] as? String
        self.subject_id = dict["subject_id"] as? String
        self.new_lessonplanstatus = dict["new_lessonplanstatus"] as? String
    }
}

class UploadHomeWorkController: UIViewController {
  
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var selectfileTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    var resultString : String = ""
    var dateString : String = ""
    var subjectid : String = ""
    var fileString : String = ""
    var titleString : String = ""
    var descriptionString : String = ""
    
    var allSubject = [GetAllSubject]()
    let SubjectDropdown =  DropDown()
    lazy var subjectDropdown: [DropDown] = {
          return [
              self.SubjectDropdown
          ]
      }()
    let fileBrowser = FileBrowser()
    let date = Date()
    let formatter = DateFormatter()
    var baseStringIamge : String = ""
    var multipleSubjectArray = [String]()
    var  subjectID : [String] = []
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        self.selectButton.layer.cornerRadius = 8
        self.selectButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.selectButton.layer.borderWidth = 1
        self.uploadButton.layer.cornerRadius = 15
        self.uploadButton.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        self.uploadButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.uploadButton.layer.borderWidth = 1
        self.imageView.image = UIImage(named:"documentFile")
        //Call API
    self.getAllSubjects(facultyID:(UserDefaults.standard.value(forKey:"userID") as? String)!)
        // Do any additional setup after loading the view.
    }
    
   
   
 // Mark : DropDown
    func setupSubjectListDropDown() {
        Singleton.customizeDropDown()
        SubjectDropdown.anchorView = selectButton
       
        let Subjectname = (0..<allSubject.count).map { (i) -> String in
            return allSubject[i].subjectName }
        subjectID = (0..<allSubject.count).map { (i) -> String in
            return allSubject[i].subject_id }
        
        SubjectDropdown.dataSource = Subjectname
        SubjectDropdown.bottomOffset = CGPoint(x: 0, y: selectButton.bounds.height)
        // Action triggered on selection
        SubjectDropdown.selectionAction = {[weak self](index, item) in
            self?.selectButton.setTitle("", for: .normal)
            self?.subjectLabel.text = item
            self?.subjectid = (self?.subjectID[index])!
        //   self?.multipleSubjectArray.append(subjectID[index])
            self?.multipleSubjectArray.append((self?.subjectID[index])!)
             
        }
        // Action triggered on selection
        SubjectDropdown.multiSelectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            self?.subjectLabel.text =  items.joined(separator: ",")
        }
        
    }
    
    // Mark : Webservices
    func getAllSubjects(facultyID:String) {
        WebService.shared.getSubjects(facultyID:facultyID,completion: {(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"Fetching HomeWork")
                self.allSubject.removeAll()
                if let homeworkDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in homeworkDict {
                        let subject = GetAllSubject(obj)
                        self.allSubject.append(subject)
                        self.setupSubjectListDropDown()
                    }
                    
                }
            }
            else
            {
               self.view.makeToast("No Subjects Found!!", duration: 1.0, position: .center)
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    
    @IBAction func selectButton(_ sender: Any) {
        self.SubjectDropdown.show()
    }
   
    @IBAction func selectFileButton(_ sender: Any) {
  
    AttachmentHandler.shared.showAttachmentActionSheet(vc:self)
        
    AttachmentHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
            if image != nil {
                self.imageView.image = image
            }
        }
        
        AttachmentHandler.shared.imagePathPickedBlock = { (imagePath,imageData,image,imageName) in
            /* get your image here */
            self.imageView.image = image
            self.resultString = imageName
            self.baseStringIamge = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            self.selectfileTF.text = self.resultString
            
        }

        AttachmentHandler.shared.filePickedBlock = {(fileURL) in
            /* get your file path url here */
            
            let fileName = fileURL.lastPathComponent
            self.selectfileTF.text = fileName
            self.imageView.image = self.drawPDFfromURL(url:fileURL)
            let filePath = fileURL.path
            if FileManager.default.fileExists(atPath: filePath) {
                if let fileData = FileManager.default.contents(atPath: filePath) {
                    print(fileData)
                    self.baseStringIamge = fileData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    self.resultString = fileName
                    print("****",self.baseStringIamge)
                    // process the file data
                } else {
                    print("Could not parse the file")
                }
            } else {
                print("File not exists")
            }
        }
      
    }
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        titleString = (self.titleTF?.text!.trimmingCharacters(in:.whitespaces))!
        descriptionString = (self.descriptionTV?.text!.trimmingCharacters(in:.whitespaces))!
        if titleString.count == 0 && descriptionString.count == 0 && self.selectfileTF.text?.count  == 0  {
            self.titleTF.shake()
            selectfileTF.shake()
            descriptionTV.shake()
        }
        else if self.subjectLabel.text == "Select Subject*" {
          self.view.makeToast("Empty subject field!! \n Please select Any Subject ", duration: 1.0, position: .center)
        }
        else {
            if titleString.count > 0 {
                if descriptionString.count > 0 {
                    
                    if self.subjectLabel.text != "Select Subject*"{
                        self.postHomeWork()
                    }
                    else{
                        self.view.makeToast("Empty subject field!!\nPlease select any subject ", duration: 1.0, position: .center)
                    }
                    
                }
                else{
                    descriptionTV.shake()
                }
            }
            else
            {
                 self.titleTF.shake()
            }
        }
    }
    
      func postHomeWork() {
        
      ProgressLoader.shared.showLoader(withText:"Uploading Homework ...")
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      dateString = formatter.string(from:date)
        WebService.shared.postHomeWork(facultyID:(UserDefaults.standard.value(forKey:"userID") as? String)!, subjectId:self.multipleSubjectArray , title:titleString, description:self.descriptionTV.text!, StartDate:dateString, endDate:dateString, fileName:self.resultString,base64: self.baseStringIamge ,completion: {(response, error ) in
                if error == nil, let responseDict = response {
                    print(responseDict)
                    if responseDict["ErrorMessage"] == "Server error. Please contact Admin!!" {
                        ProgressLoader.shared.hideLoader();
                        AlertManager.shared.showAlertWith(title:"Server error. Please contact Admin!!", message:"")
                    }
                    else{
                        ProgressLoader.shared.hideLoader()
                        let alert = UIAlertController(title: "HomeWork Uploaded SuccessFully!!", message: "", preferredStyle: .alert)
                                               let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                                                   self.descriptionTV.text = ""
                                                   self.subjectLabel.text = "Select Subject*"
                                                   self.titleTF.text = ""
                                                   self.selectfileTF.text = ""
                                                   self.imageView.image = #imageLiteral(resourceName: "documentFile")
                                                   self.SubjectDropdown.clearSelection()
                                                   self.multipleSubjectArray.removeAll()
                                                
                                                   self.getAllSubjects(facultyID:(UserDefaults.standard.value(forKey:"userID") as? String)!)
                                               })
                                               alert.addAction(okButton)
                                               DispatchQueue.main.async(execute: {
                                                   self.present(alert, animated: true)
                                               })
                    }
         
                } else {
                  ProgressLoader.shared.hideLoader()
                }
            
            ProgressLoader.shared.hideLoader()
            })
        }
        
    }

 extension String {
     func ConvertBase64() -> String {
         return Data(self.utf8).base64EncodedString()
     }
 }

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
