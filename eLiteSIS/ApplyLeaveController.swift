//
//  ApplyLeaveController.swift
//  eLiteSIS
//
//  Created by apar on 05/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ApplyLeaveController: UIViewController {
    
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var startdateTextField: UITextField!
    
    @IBOutlet weak var endDateTExtField: UITextField!
    
    @IBOutlet weak var leaveReasonTextView: KMPlaceholderTextView!
    
    let date = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startdateTextField.setLeftView(image: UIImage.init(named: "dob")!)
        endDateTExtField.setLeftView(image: UIImage.init(named: "dob")!)
        
        leaveReasonTextView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        leaveReasonTextView.layer.borderWidth = 1
        leaveButton.layer.cornerRadius = leaveButton.bounds.height / 2
        leaveButton.layer.masksToBounds = true
        
         self.startdateTextField.setInputViewDatePicker2(target: self, selector: #selector(tapDone))
        
         self.endDateTExtField.setInputViewDatePicker2(target: self, selector: #selector(tapDone1))
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func leaveApplyButton(_ sender: Any) {
        
        if (self.startdateTextField.text?.count == 0 && self.endDateTExtField.text?.count == 0 && self.leaveReasonTextView.text?.count == 0){
            self.startdateTextField.shake()
            self.endDateTExtField.shake()
            self.leaveReasonTextView.shake()
        }
        else if (self.startdateTextField.text?.count == 0){
            self.startdateTextField.shake()
        }
        else if (self.endDateTExtField.text?.count == 0){
            self.endDateTExtField.shake()
        }
        else if (self.leaveReasonTextView.text?.count == 0){
            self.leaveReasonTextView.shake()
        }
        else {
            self.postLeave()
        }
    }
    
    func postLeave() {
        ProgressLoader.shared.showLoader(withText:"Applying Leave...")
        WebService.shared.postLeave(fromDate:self.startdateTextField.text!, toDate: self.endDateTExtField.text!, studentID:((UserDefaults.standard.value(forKey:"sis_studentid") as? String)!), leaveREason:self.leaveReasonTextView.text, roleID:"1",completion: {(response, error ) in
            if error == nil, let responseDict = response {
                  print(responseDict)
                self.view.makeToast("Leave Process is been successfull!", duration: 1.0, position: .center)
                                  self.startdateTextField.text = ""
                                  self.endDateTExtField.text = ""
                                  self.leaveReasonTextView.text = ""
                
        
            }
            ProgressLoader.shared.hideLoader()
        })
        
    }
    
    
    
    @objc func tapDone() {
           if let datePicker = self.startdateTextField.inputView as? UIDatePicker {
               datePicker.minimumDate = Date()
               let dateformatter = DateFormatter()
               dateformatter.dateFormat = "MM-dd-yyyy"
               self.startdateTextField.text = dateformatter.string(from: datePicker.date)
           }
           self.startdateTextField.resignFirstResponder()
       }
    
    @objc func tapDone1() {
        if let datePicker = self.endDateTExtField.inputView as? UIDatePicker {
            datePicker.minimumDate = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM-dd-yyyy"
            self.endDateTExtField.text = dateformatter.string(from: datePicker.date)
        }
        self.endDateTExtField.resignFirstResponder()
    }
    
    
}


