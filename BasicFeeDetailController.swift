//
//  BasicFeeDetailController.swift
//  eLiteSIS
//
//  Created by Apar256 on 26/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit
import Foundation
import DropDown
import BottomPopup

struct Feepayment{

    var courseDetails : [CourseDetail]!
    var feeStructure : [FeeStructure]!
    var personalDetails : PersonalDetail!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        courseDetails = [CourseDetail]()
        if let courseDetailsArray = dictionary["CourseDetails"] as? [[String:Any]]{
            for dic in courseDetailsArray{
                let value = CourseDetail(fromDictionary: dic)
                courseDetails.append(value)
            }
        }
        feeStructure = [FeeStructure]()
        if let feeStructureArray = dictionary["FeeStructure"] as? [[String:Any]]{
            for dic in feeStructureArray{
                let value = FeeStructure(fromDictionary: dic)
                feeStructure.append(value)
            }
        }
        if let personalDetailsData = dictionary["PersonalDetails"] as? [String:Any]{
                personalDetails = PersonalDetail(fromDictionary: personalDetailsData)
            }
    }
}

struct PersonalDetail{

    var emailId : String!
    var enroll : String!
    var mobileNumber : String!
    var studentName : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        emailId = dictionary["EmailId"] as? String
        enroll = dictionary["Enroll"] as? String
        mobileNumber = dictionary["MobileNumber"] as? String
        studentName = dictionary["StudentName"] as? String
    }
}

struct FeeStructure{

    var creditNoteAmount : Int!
    var creditNoteAvailable : Bool!
    var feePaymentDetailslist : [FeePaymentDetailslist]!
    var netFee : Int!
    var totalAmountPaid : Int!
    var totalBalance : Int!
    var totalDiscount : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        creditNoteAmount = dictionary["CreditNoteAmount"] as? Int
        creditNoteAvailable = dictionary["CreditNoteAvailable"] as? Bool
        feePaymentDetailslist = [FeePaymentDetailslist]()
        if let feePaymentDetailslistArray = dictionary["FeePaymentDetailslist"] as? [[String:Any]]{
            for dic in feePaymentDetailslistArray{
                let value = FeePaymentDetailslist(fromDictionary: dic)
                feePaymentDetailslist.append(value)
            }
        }
        netFee = dictionary["NetFee"] as? Int
        totalAmountPaid = dictionary["TotalAmountPaid"] as? Int
        totalBalance = dictionary["TotalBalance"] as? Int
        totalDiscount = dictionary["TotalDiscount"] as? Int
    }
}

struct FeePaymentDetailslist{

    var feeItemPaymentDetailslist : [FeeItemPaymentDetailslist]!
    var feePaymentId : String!
    var feePaymentName : String!
    var monthName : String!
    var totalAmountPaid : Int!
    var totalBalance : Int!
    var totalDiscount : Int!
    var totalDue : Int!
    var totalMonthlyDue : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        feeItemPaymentDetailslist = [FeeItemPaymentDetailslist]()
        if let feeItemPaymentDetailslistArray = dictionary["FeeItemPaymentDetailslist"] as? [[String:Any]]{
            for dic in feeItemPaymentDetailslistArray{
                let value = FeeItemPaymentDetailslist(fromDictionary: dic)
                feeItemPaymentDetailslist.append(value)
            }
        }
        feePaymentId = dictionary["FeePaymentId"] as? String
        feePaymentName = dictionary["FeePaymentName"] as? String
        monthName = dictionary["MonthName"] as? String
        totalAmountPaid = dictionary["TotalAmountPaid"] as? Int
        totalBalance = dictionary["TotalBalance"] as? Int
        totalDiscount = dictionary["TotalDiscount"] as? Int
        totalDue = dictionary["TotalDue"] as? Int
        totalMonthlyDue = dictionary["TotalMonthlyDue"] as? Int
    }
}

struct FeeItemPaymentDetailslist{

    var appliedDiscount : Int!
    var concessionFee : Int!
    var feeItemName : String!
    var feeItemPaymentId : String!
    var totalAmountPaid : Int!
    var totalBcF : Int!
    var totalDiscount : Int!
    var totalDue : Int!
    var totalMonthly : Int!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        appliedDiscount = dictionary["AppliedDiscount"] as? Int
        concessionFee = dictionary["ConcessionFee"] as? Int
        feeItemName = dictionary["FeeItemName"] as? String
        feeItemPaymentId = dictionary["FeeItemPaymentId"] as? String
        totalAmountPaid = dictionary["TotalAmountPaid"] as? Int
        totalBcF = dictionary["TotalBcF"] as? Int
        totalDiscount = dictionary["TotalDiscount"] as? Int
        totalDue = dictionary["TotalDue"] as? Int
        totalMonthly = dictionary["TotalMonthly"] as? Int
    }
}
struct CourseDetail{

    var academicYear : String!
    var classField : String!
    var section : String!

/**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        academicYear = dictionary["AcademicYear"] as? String
        classField = dictionary["Class"] as? String
        section = dictionary["Section"] as? String
    }
}

class BasicFeeDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var payFromMonth: UILabel!
    @IBOutlet weak var payUptoMonth: UILabel!
    @IBOutlet weak var PayuptoButton: UIButton!
    @IBOutlet weak var feeStructure: UITableView!
   
    var item = [FeeItemPaymentDetailslist]()
    var countArray = [Int]()
    var feeStructureDetails = [FeeStructure]()
    var courseDetails = [CourseDetail]()
    var personaleDetails = [PersonalDetail]()
    var monthID : [String] = []
    var monthName : [String] = []
    var monthDueCount : [String] = []
    let monthDropDown =  DropDown()
    
    var arraCount : Int = 0
    var total : Int = 0
    lazy var Dropdown: [DropDown] = {
        return [
            self.monthDropDown
        ]
    }()
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countArray.removeAll()
        self.feeStructure.separatorColor = .clear
        self.feeStructure.delegate = nil
        self.feeStructure.dataSource = nil
        FeePaymentDetails()
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    
        self.getFeeReceiptDetail(from: self.feeStructureDetails[0].feePaymentDetailslist[0].feePaymentId, to: (self.feeStructureDetails[0].feePaymentDetailslist.last?.feePaymentId)!, paymentID:"")
        

    }
    
    func setupMonthDropDown() {
        
        Singleton.customizeDropDown()
        monthDropDown.anchorView = PayuptoButton
        monthName = (0..<self.feeStructureDetails[0].feePaymentDetailslist.count).map { (i) -> String in
            return  self.feeStructureDetails[0].feePaymentDetailslist[i].monthName
        }
        arraCount = monthName.count
        monthDropDown.dataSource = monthName
        monthDropDown.bottomOffset = CGPoint(x: 0, y: PayuptoButton.bounds.height)
        // Action triggered on selection
        monthDropDown.selectionAction = {[weak self](index, item) in
            self?.PayuptoButton.setTitle("", for: .normal)
            self?.payUptoMonth.text = item
            self?.arraCount = index + 1
            self?.feeStructure.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "BasicPayTableViewCell") as! BasicPayTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        payFromMonth.text = self.feeStructureDetails[0].feePaymentDetailslist[0].monthName
        payUptoMonth.text = self.feeStructureDetails[0].feePaymentDetailslist.last?.monthName
        cell.monthLabel.text = self.feeStructureDetails[0].feePaymentDetailslist[indexPath.row].monthName
        cell.monthDue.text = "Rs." + String(self.feeStructureDetails[0].feePaymentDetailslist[indexPath.row].totalMonthlyDue)
        cell.paidAmt.text = "Rs." + String(self.feeStructureDetails[0].feePaymentDetailslist[indexPath.row].totalAmountPaid)
        cell.balance.text = "Rs." + String(self.feeStructureDetails[0].feePaymentDetailslist[indexPath.row].totalBalance)
        cell.dropDownButton.tag = indexPath.row
        countArray.append(self.feeStructureDetails[0].feePaymentDetailslist[indexPath.row].totalBalance)
         total = countArray.reduce(0, +)
        cell.dropDownButton.addTarget(self, action: #selector(dropDownButton), for: .touchUpInside)
        return cell
    }
    
    @objc func dropDownButton(sender:UIButton) {
        
        let index = sender.tag
        guard let popupNavController = storyboard?.instantiateViewController(withIdentifier: "pay") as? PayDetailController else { return }
        popupNavController.fromMonth = self.feeStructureDetails[0].feePaymentDetailslist[0].feePaymentId
        popupNavController.toMonth = self.feeStructureDetails[0].feePaymentDetailslist![index].feePaymentId
        popupNavController.item =  feeStructureDetails[0].feePaymentDetailslist![index].feeItemPaymentDetailslist
        present(popupNavController, animated: true, completion: nil)
        //present(popupNavController, animated: true, completion: nil)
    }
    
    func FeePaymentDetails()
    {
        let studentID = UserDefaults.standard.value(forKey:"_sis_studentname_value") as? String ?? ""
        ProgressLoader.shared.showLoader(withText:"Fee Payment Detail Loading..... ")
        WebService.shared.GetBasicFeeDetailForStudent(studentID:studentID,completion: {(response, error ) in
            if error == nil, let responseDict = response {
                
                if let coursedetail = responseDict["Data"]["CourseDetails"].arrayObject as? [[String:Any]]{
                    for data in coursedetail {
                        let obj = CourseDetail(fromDictionary:data)
                        self.courseDetails.append(obj)
                    }
                }
                
                if let personaldetail = responseDict["Data"]["PersonalDetails"].arrayObject as? [[String:Any]]{
                    for data in personaldetail {
                        let obj = PersonalDetail(fromDictionary:data)
                        self.personaleDetails.append(obj)
                    }
                }
                
                if let feeStuctureDict = responseDict["Data"]["FeeStructure"].arrayObject as? [[String:Any]]{
                    
                    for data in feeStuctureDict {
                        let obj = FeeStructure(fromDictionary: data)
                        self.feeStructureDetails.append(obj)
                    }
                  
                    self.setupMonthDropDown()
                    self.feeStructure.delegate = self
                    self.feeStructure.dataSource = self
                    let customView = UIView(frame: CGRect(x: self.feeStructure.frame.origin.x, y:0, width:self.feeStructure.frame.size.width, height: 50))
                    customView.backgroundColor = .clear
                    let button = UIButton(frame: CGRect(x:self.feeStructure.frame.size.width/2 - self.feeStructure.frame.size.width/4 , y: 0, width:self.feeStructure.frame.size.width/2 , height: 50))
                    button.setTitle("Pay Now", for: .normal)
                    button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    button.backgroundColor = #colorLiteral(red: 0.02255458048, green: 0.2434142492, blue: 0.625588613, alpha: 1)
                    customView.addSubview(button)
                    button.layer.cornerRadius = 5
                    self.feeStructure.tableFooterView = customView
                    Singleton.setUpTableViewDisplay(self.feeStructure, headerView:"", "BasicPayTableViewCell")
                    Singleton.setUpTableViewDisplay(self.feeStructure, headerView:"", "PerformanceTableViewCell")
                }
                ProgressLoader.shared.hideLoader()
                
            } else {
                ProgressLoader.shared.hideLoader()
            }
        })
    }
    
    
    
    func getFeeReceiptDetail(from:String,to:String,paymentID:String) {
        
        ProgressLoader.shared.showLoader(withText: "Forwarding to Payment Gateway .....")
        WebService.shared.GetFeeDetailForUppPayment(regID:"", fromMonth: from, toMonth: to, paymentID: paymentID, amount:String(total),completion:{(response, error) in
            if error == nil , let responseDict = response {
                print("response ***********\(response)")
            
                let vc  = self.mainStoryboard.instantiateViewController(withIdentifier: "web") as! WebViewController
                vc.email = responseDict["PayerEmail"].stringValue
                vc.mobile = responseDict["PayerPhone"].stringValue
                vc.payerName = responseDict["PayerName"].stringValue
                vc.instituteID = responseDict["InstituteUniqueID"].stringValue
                vc.PayerGUID = responseDict["PayerGUID"].stringValue
                vc.UPPMID = responseDict["eUPPMMID"].stringValue
                vc.transactionType = responseDict["TransactionType"].stringValue
                vc.totalAmount = self.total
                vc.responseURL = responseDict["ResponseURL"].stringValue
                vc.modalPresentationStyle = .fullScreen
                vc.fromBasicFee = true
                self.present(vc, animated: true, completion: nil)
                ProgressLoader.shared.hideLoader()
            }
            else{
                ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    @IBAction func paymentButton(_ sender: Any) {
        self.monthDropDown.show()
    }
    
}

