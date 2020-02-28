//
//  ChangePasswordController.swift
//  eLiteSIS
//
//  Created by apar on 18/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController {

    @IBOutlet weak var submitbutton: UIButton!
    @IBOutlet weak var newpasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
     var md5Hex : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitbutton.layer.cornerRadius = 15
        self.newpasswordTextField.setLeftView(image:#imageLiteral(resourceName: "password"))
        self.confirmPasswordTextField.setLeftView(image:#imageLiteral(resourceName: "password"))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
            if newpasswordTextField.text?.count != 0{
                if confirmPasswordTextField.text?.count != 0 {
                  
                    if newpasswordTextField.text == UserDefaults.standard.value(forKey:"password") as? String {
                        self.newpasswordTextField.shake()
                        self.view.makeToast("Your new password must be different from your previous password.", duration: 1.0, position: .bottom)
                    }
                    else if newpasswordTextField.text != confirmPasswordTextField.text {
                        self.newpasswordTextField.shake()
                        self.confirmPasswordTextField.shake()
                        self.view.makeToast("Your new password and confirm password should be same", duration: 1.0, position: .bottom)
                    }
                    else {
                         self.postChangePassword()
                    }
                   
                }
                else{
                    self.confirmPasswordTextField.shake()
                }
            }
            else{
                self.newpasswordTextField.shake()
            }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
               self.navigationController?.popViewController(animated: true)
    }
    
    func postChangePassword(){
        
        
        // convert password into mdf5 encryption
        let md5Data = Singleton.MD5(string:self.newpasswordTextField.text!)
        md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        
        WebService.shared.ChangePassword(userType: 1, regeID:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!, encryptedPassword:md5Hex, newPassword:self.newpasswordTextField.text!, completion:{(response , error) in
            if error == nil , let responseDict = response {
                print(responseDict)
                ProgressLoader.shared.showLoader(withText:"")
                if responseDict["status"] == "Success" {
                    self.newpasswordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                    self.md5Hex = ""
                    ProgressLoader.shared.hideLoader()
                    UserDefaults.standard.set(self.newpasswordTextField.text, forKey:"password")
                    let alert = UIAlertController(title: "Password Changed Succesfully!!", message: "", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as? LoginViewController{
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: false, completion: nil)
                        }
                    })
                    alert.addAction(okButton)
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true)
                    })
                }
                else
                {
                 ProgressLoader.shared.hideLoader()
                  self.view.makeToast("Server Error!!", duration: 1.0, position: .bottom)
                }
                
            }
             ProgressLoader.shared.hideLoader()
        })
        
        
    }
}
