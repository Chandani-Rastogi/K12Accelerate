//
//  ForgotPasswordController.swift
//  eLiteSIS
//
//  Created by apar on 16/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit


class ForgotPasswordController: UIViewController {
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    var registrationID : String = ""
   
     var fromFaculty = Bool()
     var fromStudent = Bool()
    var fromLogin = Bool()
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userNameTF.setLeftView(image: UIImage.init(named: "user4")!)
        mobileNumberTF.setLeftView(image: UIImage.init(named: "mobile")!)
        dobTextField.setLeftView(image: UIImage.init(named: "dob")!)
        
        self.mobileNumberTF.keyboardType = .numberPad
        self.hideKeyboardWhenTappedAround() 
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
        submitButton.layer.masksToBounds = true
        
        registrationID = (UserDefaults.standard.object(forKey: "_sis_registration_value") as? String ?? "")
        
        if fromStudent == true
        {
            self.backImage.isHidden = true
            self.backButton.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.isHidden = false
         
        }
        
        else if fromLogin == true {
              self.backImage.isHidden = false
             self.backButton.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.isHidden = true
        }
        else
        {
            self.backImage.isHidden = true
            self.backButton.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.isHidden = false
           
        }
        
        self.dobTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if fromStudent == true
        {
            self.tabBarController?.tabBar.isHidden = false
        }
        else if fromLogin == true
        {
            self.tabBarController?.tabBar.isHidden = true
        }
        else
        {
            self.tabBarController?.tabBar.isHidden = false
        }
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
   

    @IBAction func submitButton(_ sender: Any) {
        
        if (self.userNameTF.text?.count == 0 && self.mobileNumberTF.text?.count == 0 && self.dobTextField.text?.count == 0){
            self.userNameTF.shake()
            self.mobileNumberTF.shake()
            self.dobTextField.shake()
        }
        else if (self.userNameTF.text?.count == 0){
            self.userNameTF.shake()
        }
        else if (self.mobileNumberTF.text?.count == 0){
            self.mobileNumberTF.shake()
        }
        else if (self.dobTextField.text?.count == 0){
                self.dobTextField.shake()
            }
        else {
            
            self.postforgetPassword()
        }
      
    }

    func postforgetPassword() {
        WebService.shared.getForgetPassword(userName:self.userNameTF.text!, mobileNumber:self.mobileNumberTF.text!, Dob:self.dobTextField.text!,completion:{(response, error) in
            if error == nil , let responseDict = response
            {
                if responseDict.count > 0 {
                    if responseDict["status"].stringValue == "Fail" {
                        self.view.makeToast("Invalid information Provided!", duration: 1.0, position: .bottom)
                    }
                    else{
                         self.view.makeToast("Password Reset Succesfully!! \n We have sent you new password on your registered Mobile Number. ", duration: 1.0, position: .bottom)
                        self.userNameTF.text = ""
                        self.mobileNumberTF.text = ""
                        self.dobTextField.text = ""
                    }
                    ProgressLoader.shared.hideLoader()
                }
            }
            else{
                  self.view.makeToast("Server error. Please contact Admin!", duration: 1.0, position: .bottom)
                 ProgressLoader.shared.hideLoader()
            }
            ProgressLoader.shared.hideLoader()
        })
    }
 
    @IBAction func DOB_textfield(_ sender: UITextField) {
  
    }
    
    //2
    @objc func tapDone() {
        if let datePicker = self.dobTextField.inputView as? UIDatePicker {
            datePicker.maximumDate = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM-dd-yyyy"
            //dateformatter.dateStyle = .medium
            self.dobTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.dobTextField.resignFirstResponder()
    }
}

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        self.inputView = datePicker 
        datePicker.maximumDate = Date()
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    func setInputViewDatePicker2(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        datePicker.minimumDate = Date()
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
