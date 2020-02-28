//
//  CustomNotificationController.swift
//  eLiteSIS
//
//  Created by apar on 06/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import KMPlaceholderTextView
import FileBrowser

struct ClassSection {
    
    var classId : String!
    var className : String!
    var sections : [Section]!

    init(fromDictionary dictionary: [String:Any]){
        classId = dictionary["ClassId"] as? String
        className = dictionary["ClassName"] as? String
        sections = [Section]()
        if let sectionsArray = dictionary["Sections"] as? [[String:Any]]{
            for dic in sectionsArray{
                let value = Section(fromDictionary: dic)
                sections.append(value)
            }
        }
    }
}
struct Section {
       
       var sectionId : String!
       var sectionName : String!

       init(fromDictionary dictionary: [String:Any]){
           sectionId = dictionary["SectionId"] as? String
           sectionName = dictionary["SectionName"] as? String
       }
   }

class CustomNotificationController: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var selectButton1: UIButton!
    @IBOutlet weak var selectButton2: UIButton!
    @IBOutlet weak var selectButton3: UIButton!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var category: UIImageView!
    @IBOutlet weak var classdrop: UIImageView!
    @IBOutlet weak var section: UIImageView!
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var subtitle1: KMPlaceholderTextView!
    @IBOutlet weak var title2: UITextField!
    @IBOutlet weak var subtitle2: KMPlaceholderTextView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var submit2: UIButton!
    @IBOutlet weak var multipleClassLabel: UILabel!
    @IBOutlet weak var multipleClass: UIButton!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var title3: UITextField!
    @IBOutlet weak var subtitle3: KMPlaceholderTextView!
    @IBOutlet weak var submit3: UIButton!
    @IBOutlet weak var selectfileTF3: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageview3: UIImageView!
    @IBOutlet weak var selectFileTF: UITextField!
    @IBOutlet weak var selectFileTF2: UITextField!
    var uploadtitle : String = ""
       var uploadType : Int = 0
     var resultString : String = ""
      var baseStringIamge : String = ""
    
    let categoryDropdown =  DropDown()
    let classDropdown =  DropDown()
    let sectionDropdown = DropDown()
    let multipleClassDropdown = DropDown()
    var getSectionClass = [ClassSection]()
    var filteredSectionClass = [ClassSection]()
    var getSections = [Section]()
    var SectionsArray = [String]()
    var multipleClassArray = [String]()
    var ClaasID : [String] = []
    var Classname : [String] = []
    var SectionName : [String] = []
    var SectionID : [String] = []
    var multipleClaasID : [String] = []
    var multipleClassName : [String] = []
    var categoryNAme : [String] = []
    
    var titleString1 : String = ""
    var titleString2 : String = ""
    var titleString3 : String = ""
    var subtitleString1 : String = ""
    var subtitleString2 : String = ""
    var subtitleString3 : String = ""
    
   
    
    lazy var Dropdown: [DropDown] = {
        return [
            self.categoryDropdown,
            self.classDropdown,
            self.multipleClassDropdown,
            self.sectionDropdown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.imageView.image = #imageLiteral(resourceName: "documentFile")
       self.imageView2.image = #imageLiteral(resourceName: "documentFile")
       self.imageview3.image = #imageLiteral(resourceName: "documentFile")
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDisplay()
        self.getclassesAPI()
        
    }
    
    // Mark : DropDown
    func setupcategorylistDropDown() {
        self.selectFileTF.text?.removeAll()
        self.selectFileTF2.text?.removeAll()
        self.selectfileTF3.text?.removeAll()
        self.baseStringIamge = ""
        self.resultString = ""
        self.classLabel.text = "Select Class*"
        self.sectionLabel.text = "Select Section*"
        self.subtitle1.text.removeAll()
        self.subtitle2.text.removeAll()
        self.subtitle3.text.removeAll()
        self.multipleClassLabel.text  = "Select/Single/Multiple Class*"
        self.title1.text?.removeAll()
        self.title2.text?.removeAll()
        self.title3.text?.removeAll()
        
        Singleton.customizeDropDown()
        categoryDropdown.anchorView = selectButton1
        
        categoryDropdown.dataSource = ["Student","Employee","Whole School","MultipleClasses"]
        categoryDropdown.bottomOffset = CGPoint(x: 0, y: selectButton1.bounds.height)
        // Action triggered on selection
        categoryDropdown.selectionAction = {[weak self](index, item) in
            self?.selectButton1.setTitle("", for: .normal)
            self?.categoryLabel.text = item
              if item == "Employee" {
                self?.secondView.isHidden = false
                self?.thirdView.isHidden = true
            }
            else if item == "Whole School" {
                self?.secondView.isHidden = false
                self?.thirdView.isHidden = true
            }
                
            else if item == "MultipleClasses"  {
                self?.setupmultipleClasslistDropDown()
                self?.thirdView.isHidden = false
                self?.secondView.isHidden = true
            }
            else{
                self?.secondView.isHidden = true
                self?.thirdView.isHidden = true
            }
        }
    }

    func setupClasslistDropDown() {
        
        Singleton.customizeDropDown()
        classDropdown.anchorView = selectButton2
        
        Classname = (0..<getSectionClass.count).map { (i) -> String in
                   return getSectionClass[i].className
        }
        
        ClaasID = (0..<getSectionClass.count).map { (i) -> String in
        return getSectionClass[i].classId
            
        }
        
        classDropdown.dataSource = Classname
        classDropdown.bottomOffset = CGPoint(x: 0, y: selectButton2.bounds.height)
        // Action triggered on selection
        classDropdown.selectionAction = {[weak self](index, item) in
            self?.selectButton2.setTitle("", for: .normal)
            self?.classLabel.text = item
            self?.classLabel.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self?.selectButton2.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self?.setupSectionlistDropDown(classID:(self?.ClaasID[index])!)
          
        }
    }
    
    func setupSectionlistDropDown(classID:String) {
        
           Singleton.customizeDropDown()
           sectionDropdown.anchorView = selectButton3
           filteredSectionClass = getSectionClass.filter{($0.classId!) == classID }
        
            SectionName = (0..<filteredSectionClass[0].sections.count).map { (i) -> String in
              return filteredSectionClass[0].sections[i].sectionName
           }
        
            SectionID = (0..<filteredSectionClass[0].sections.count).map { (i) -> String in
               return filteredSectionClass[0].sections[i].sectionId
           }
           sectionDropdown.dataSource = SectionName
           sectionDropdown.bottomOffset = CGPoint(x: 0, y: selectButton3.bounds.height)
           // Action triggered on selection
           sectionDropdown.selectionAction = {[weak self](index, item) in
               self?.selectButton3.setTitle("", for: .normal)
               self?.sectionLabel.text = item
               self?.sectionLabel.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
               self?.selectButton3.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
               self?.SectionsArray.append(self!.SectionID[index])
               print(self?.SectionsArray)
           }
        
        // Action triggered on selection
        sectionDropdown.multiSelectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            self?.sectionLabel.text =  items.joined(separator: ",")

        }
           
       }
       
    
    func setupmultipleClasslistDropDown() {
        
        Singleton.customizeDropDown()
        multipleClassDropdown.anchorView = selectButton2
        multipleClassName = (0..<getSectionClass.count).map { (i) -> String in
            return getSectionClass[i].className
        }
        
        multipleClaasID = (0..<getSectionClass.count).map { (i) -> String in
              return getSectionClass[i].classId
        }
        
        multipleClassDropdown.dataSource = multipleClassName
        multipleClassDropdown.bottomOffset = CGPoint(x: 0, y: selectButton2.bounds.height)
        
        // Action triggered on selection
        multipleClassDropdown.selectionAction = {[weak self](index, item) in
            self?.selectButton2.setTitle("", for: .normal)
            self?.multipleClassLabel.textColor =  #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self?.selectButton2.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self?.multipleClassArray.append(self!.multipleClaasID[index])
        }
        
        // Action triggered on selection
        multipleClassDropdown.multiSelectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            self?.multipleClassLabel.text =  items.joined(separator: ",")
            
            
        }
    }
    
   
    @IBAction func selectionButton1(_ sender: Any) {
        
        self.categoryDropdown.show()
    }
    
    @IBAction func sectionButton2(_ sender: Any) {
        
        if self.thirdView.isHidden == false {
            self.multipleClassDropdown.show()
        }
        else {
        self.classDropdown.show()
        }
      
    }
    
    @IBAction func sectionButton3(_ sender: Any) {
        self.sectionDropdown.show()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        classDropdown.hide()
        
        titleString1 = (self.title1?.text!.trimmingCharacters(in:.whitespaces))!
        titleString2 = (self.title2?.text!.trimmingCharacters(in:.whitespaces))!
        titleString3 = (self.title3?.text!.trimmingCharacters(in:.whitespaces))!
        
        subtitleString1 = (self.subtitle1?.text!.trimmingCharacters(in:.whitespaces))!
        subtitleString2 = (self.subtitle2?.text!.trimmingCharacters(in:.whitespaces))!
        subtitleString3 = (self.subtitle3?.text!.trimmingCharacters(in:.whitespaces))!
        
        if self.secondView.isHidden == true && self.thirdView.isHidden == true {
            
            if self.categoryLabel.text == "Select Category*" && self.classLabel.text == "Select Class*"  && self.sectionLabel.text == "Select Section*" && self.titleString1.count == 0 && self.subtitleString1.count  == 0 {
                self.selectButton1.shake()
                self.selectButton2.shake()
                self.selectButton3.shake()
                self.title1.shake()
                self.subtitle1.shake()
            }
            else {
                if self.categoryLabel.text != "Select Category*" {
                    if self.classLabel.text != "Select Class*" {
                        if self.sectionLabel.text != "Select Section*"{
                            if self.titleString1.count > 0 {
                                if self.subtitleString1.count > 0 {
                                    self.postCustomNotifications(title:self.title1.text!, body: self.subtitle1.text!, type: "1", fileNAme: selectFileTF.text!, topicsList:self.SectionsArray)
                                }
                                else{ self.subtitle1.shake()}
                            }
                            else { self.title1.shake()}
                        }
                        else{
                            self.selectButton3.shake()
                        }
                    }
                    else{ self.selectButton2.shake()}
                }
                else{ self.selectButton1.shake()}
            }
        }
            
        else if self.secondView.isHidden == false {
            
            if  self.titleString2.count == 0 && self.subtitleString2.count == 0 {
                self.title2.shake()
                self.subtitle2.shake()
            }
            else{
                if self.categoryLabel.text == "Employee" {
                    self.SectionsArray.append("employee")
                }
                else {
                    self.SectionsArray.append("whole_school")
                }
                
                if self.titleString2.count > 0 {
                    if self.subtitleString2.count > 0 {
                        if self.categoryLabel.text == "Employee"{
                            self.postCustomNotifications(title:self.title2.text!, body: self.subtitle2.text!, type: "2", fileNAme: selectFileTF2.text!, topicsList:self.SectionsArray)
                        }
                        else if self.categoryLabel.text == "Whole School" {
                            self.postCustomNotifications(title:self.title2.text!, body: self.subtitle2.text!, type: "3", fileNAme:selectFileTF2.text!, topicsList:self.SectionsArray)
                        }
                    }
                    else{ self.subtitle2.shake()}
                }
                else { self.title2.shake()}
            }
        }
            
        else if self.thirdView.isHidden == false {
            
            if  self.multipleClassLabel.text == "Select Single/Multiple CLass*"  && self.title3.text?.count == 0 && self.subtitle3.text.count == 0 {
                self.multipleClass.shake()
                self.title3.shake()
                self.subtitle3.shake()
            }
            else
            {
                if self.multipleClassLabel.text != "Select Single/Multiple CLass*"{
                    if self.titleString3.count > 0 {
                        if self.subtitleString3.count > 0 {
                            self.postCustomNotifications(title:self.title3.text!, body: self.subtitle3.text!, type: "4", fileNAme: selectfileTF3.text!, topicsList:self.multipleClassArray)
                        }
                        else{ self.subtitle3.shake()}
                    }
                    else { self.title3.shake()}
                }
                else{
                    self.multipleClass.shake()
                }
            }
        }
    }
    
    func getclassesAPI() {
    WebService.shared.GetAllClassSection(registrationValue:UserDefaults.standard.value(forKey:"_sis_registration_value") as? String ?? "", completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let classDict = responseDict["Classes"].arrayObject as? [[String:Any]]
                {
                    self.getSectionClass.removeAll()
                    if classDict.count > 0 {
                        for data in classDict {
                            let obj = ClassSection(fromDictionary: data)
                            self.getSectionClass.append(obj)
                        }
                         self.setupClasslistDropDown()
                        
                    }
                }
                else {
                    
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func postCustomNotifications(title:String,body:String,type:String,fileNAme:String,topicsList:[String]){
        
       // classDropdown.selectionBackgroundColor = .clear
        
     ProgressLoader.shared.showLoader(withText:"Notification Uploading..... ")
        
        WebService.shared.postCustomNotifications(title:title, body:body, RecipientType:type, topicList:topicsList, fileName:fileNAme, base64String: baseStringIamge ,completion: {(response, error ) in
               if error == nil, let responseDict = response {
                
                if responseDict == "Process is been successfull" {
                    
                    self.view.makeToast("Process is been successfull", duration: 1.0, position:.center)
                    self.categoryLabel.text = "Select Category*"
                    self.classLabel.text = "Select Class*"
                    self.sectionLabel.text = "Select Section*"
                    self.title1.text = ""
                    self.subtitle1.text = ""
                    self.title2.text = ""
                    self.subtitle2.text = ""
                    self.title3.text = ""
                    self.subtitle3.text = ""
                    self.multipleClassLabel.text = "Select Single/Multiple CLass*"
                    self.SectionsArray.removeAll()
                    self.multipleClassArray.removeAll()
                    self.getSectionClass.removeAll()
                    self.filteredSectionClass.removeAll()
                    self.view.setNeedsLayout()
                    self.Classname.removeAll()
                    self.ClaasID.removeAll()
                    self.SectionID.removeAll()
                    self.SectionName.removeAll()
                    self.multipleClassName.removeAll()
                    self.multipleClaasID.removeAll()
                    
                    self.categoryDropdown.clearSelection()
                    self.classDropdown.clearSelection()
                    self.sectionDropdown.clearSelection()
                    self.multipleClassDropdown.clearSelection()
                    self.getclassesAPI()
                    
                    ProgressLoader.shared.hideLoader()
                }
                else if responseDict["ErrorMessage"] == "Server error. Please contact Admin!!" {
                    
                    self.view.makeToast("Server error. Please contact Admin!!", duration: 1.0, position:.center)
                    self.categoryLabel.text = "Select Category*"
                    self.classLabel.text = "Select Class*"
                    self.sectionLabel.text = "Select Section*"
                    self.title1.text = ""
                    self.subtitle1.text = ""
                    self.title2.text = ""
                    self.subtitle2.text = ""
                    self.title3.text = ""
                    self.subtitle3.text = ""
                    self.multipleClassLabel.text = "Select Single/Multiple CLass*"
                    self.SectionsArray.removeAll()
                    self.multipleClassArray.removeAll()
                    self.getSectionClass.removeAll()
                    self.filteredSectionClass.removeAll()
                    self.view.setNeedsLayout()
                    self.Classname.removeAll()
                    self.ClaasID.removeAll()
                    self.SectionID.removeAll()
                    self.SectionName.removeAll()
                    self.multipleClassName.removeAll()
                    self.multipleClaasID.removeAll()
                    self.categoryDropdown.clearSelection()
                    self.classDropdown.clearSelection()
                    self.sectionDropdown.clearSelection()
                    self.multipleClassDropdown.clearSelection()
                    self.getclassesAPI()
                    ProgressLoader.shared.hideLoader()
                    
                }
                
                   ProgressLoader.shared.hideLoader()
                
               } else {
                
                   ProgressLoader.shared.hideLoader()
                
               }
           })
       }
    
    
    @IBAction func selectFileButton(_ sender: Any) {
        
        AttachmentHandler.shared.showAttachmentActionSheet(vc:self)
        
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
           
                if self.secondView.isHidden == false {
                  self.imageView2.image = image
                }
                if  self.thirdView.isHidden == false  {
                    self.imageview3.image = image
                }
                else {
                  self.imageView.image = image
                }
            
        }
        
        AttachmentHandler.shared.imagePathPickedBlock = { (imagePath,imageData,image,imageName) in
            /* get your image here */
        
                if self.secondView.isHidden == false {
                  self.imageView2.image = image
                    self.selectFileTF2.text = self.resultString
                }
                if  self.thirdView.isHidden == false  {
                    self.imageview3.image = image
                    self.selectfileTF3.text = self.resultString
                }
                else {
                  self.selectFileTF.text = self.resultString
                  self.imageView.image = image
                }
            
            self.resultString = imageName
            self.baseStringIamge = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            
        }
        
        AttachmentHandler.shared.filePickedBlock = {(fileURL) in
            /* get your file path url here */
            
            let fileName = fileURL.lastPathComponent
            
                if self.secondView.isHidden == false {
                    self.selectFileTF2.text = fileName
                  self.imageView2.image = self.drawPDFfromURL(url:fileURL)
                }
                if  self.thirdView.isHidden == false  {
                    self.selectfileTF3.text = fileName
                     self.imageview3.image = self.drawPDFfromURL(url:fileURL)
                }
                else {
                    self.selectFileTF.text = fileName
                 self.imageView.image = self.drawPDFfromURL(url:fileURL)
                }
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
    
    func setupDisplay() {
        self.setupcategorylistDropDown()
          
            self.selectButton1.layer.cornerRadius = 8
            self.selectButton1.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.selectButton1.layer.borderWidth = 1
            
            self.selectButton2.layer.cornerRadius = 8
            self.selectButton2.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.selectButton2.layer.borderWidth = 1
            
            self.selectButton3.layer.cornerRadius = 8
            self.selectButton3.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.classLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.selectButton3.layer.borderWidth = 1
            
            self.title1.layer.borderWidth = 1
            self.title1.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.title1.layer.cornerRadius = 8
            
            self.submit.layer.cornerRadius = 8
            self.submit.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            
            self.subtitle1.layer.cornerRadius = 8
            self.subtitle1.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.subtitle1.layer.borderWidth = 1
            
            self.title2.layer.borderWidth = 1
            self.title2.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.title2.layer.cornerRadius = 8
            
            self.classLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.sectionLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
            self.subtitle2.layer.cornerRadius = 8
            self.subtitle2.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.subtitle2.layer.borderWidth = 1
            self.submit2.layer.cornerRadius = 8
            self.submit2.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.secondView.isHidden = true
            
            self.thirdView.isHidden = true
            
            self.subtitle3.layer.cornerRadius = 8
            self.subtitle3.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.subtitle3.layer.borderWidth = 1
            
            
            self.multipleClass.layer.cornerRadius = 8
            self.multipleClass.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.multipleClass.layer.borderWidth = 1
            
            self.title3.layer.borderWidth = 1
            self.title3.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            self.title3.layer.cornerRadius = 8
            
            self.submit3.layer.cornerRadius = 8
            self.submit3.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
    }
}
