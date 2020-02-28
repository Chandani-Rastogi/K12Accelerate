//
//  LoginViewController.swift
//  eLiteSIS
//
//  Created by apar on 15/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    var md5Hex : String = ""
    var iconClick = true
    var passswodtext: String = ""
    
    @IBOutlet weak var showPassword: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextfield.setLeftView(image: UIImage.init(named: "user4")!)
        passwordTextField.setLeftView(image: UIImage.init(named: "password")!)
        passwordTextField.setRightView(image: UIImage.init(named: "hide")!)
        
        
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        loginButton.layer.masksToBounds = true
        self.passwordTextField.isSecureTextEntry = true
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func showPassword(_ sender: Any) {
        
        if(iconClick == true) {
               passwordTextField.setRightView(image: UIImage.init(named: "show")!)
            passwordTextField.isSecureTextEntry = false
        } else {
               passwordTextField.setRightView(image: UIImage.init(named: "hide")!)
            passwordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    

    @IBAction func forgotPasswordButton(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "forgotpassword") as? ForgotPasswordController{
            vc.modalPresentationStyle = .fullScreen
            vc.fromLogin = true
            // Show the navigation bar on other view controllers
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if (self.userNameTextfield.text?.count == 0 && self.passwordTextField.text?.count == 0){
            self.userNameTextfield.shake()
            self.passwordTextField.shake()
        }
        else if (self.userNameTextfield.text?.count == 0){
            self.userNameTextfield.shake()
          
        }
        else if (self.passwordTextField.text?.count == 0){
            self.passwordTextField.shake()
        }
        else {
            let username =  self.userNameTextfield.text?.trimmingCharacters(in: .whitespaces)
            self.passswodtext =  (self.passwordTextField.text?.trimmingCharacters(in: .whitespaces))!
            print(self.passswodtext)
            // convert password into mdf5 encryption
            let md5Data = Singleton.MD5(string:self.passswodtext)
            md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
            self.fetchLogin(user: username! , password: md5Hex)
        }
    }
    
    
    func fetchLogin(user:String , password : String)  {
        if InternetReachability.isConnectedToNetwork(){
            WebService.shared.loginUserWith(username:user, password:password, completion:{(response, error) in
                
                if error == nil , let responseDict = response {
                    ProgressLoader.shared.showLoader(withText:"")

                    if responseDict.count>0 {
                        print(responseDict)
                        
                        if responseDict["value"].count > 0 {
                            UserDefaults.standard.set(self.passswodtext, forKey:"password")
                            
                            let userID : String? = responseDict["value"][0]["UserId"].stringValue
                            UserDefaults.standard.set(userID, forKey:"userID")
                            
                            let roleID : String? = responseDict["value"][0]["new_rolecode"].stringValue
                            UserDefaults.standard.set(roleID, forKey:"new_rolecode")
                            
                            let registrationID:String? = responseDict["value"][0]["_sis_registration_value"].stringValue
                            UserDefaults.standard.set(registrationID, forKey: "_sis_registration_value")
                            
                            let loginMasterId = responseDict["value"][0]["sis_loginmasterid"].stringValue
                            UserDefaults.standard.set(loginMasterId, forKey:"loginMasterID")
                            
                            let sisSchoolValue = responseDict["value"][0]["sis_registration"]["_sis_school_value"].stringValue
                            print(sisSchoolValue)
                            
                            let notificationID = responseDict["value"][0]["NotificationId"].stringValue
                            UserDefaults.standard.set(notificationID, forKey:"NotificationId")
                    
                            UserDefaults.standard.set(sisSchoolValue, forKey:"sisSchoolValue")
                            
                            
                            self.postTokenID(loginMasterId:loginMasterId)
                        
                            UserDefaults.standard.setIsLoggedIn(value:true)
                            
                            if UserDefaults.standard.value(forKey:"new_rolecode") as? String == "1" {
                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as? TabBarViewController{
                                     vc.modalPresentationStyle = .fullScreen
                                     vc.selectedIndex = 1
                                    self.present(vc, animated: false, completion: nil)
                                }
                            }
                                
                            else if UserDefaults.standard.value(forKey:"new_rolecode") as? String == "211" {
                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teacherTabeBar") as? TeacherTabController{
                                    vc.modalPresentationStyle = .fullScreen
                                    vc.selectedIndex = 1
                                   self.present(vc, animated: false, completion: nil)
                                    
                                }
                            }
                                
                            else if UserDefaults.standard.value(forKey:"new_rolecode") as? String == "212" {
                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teacherTabeBar") as? TeacherTabController{
                                    vc.modalPresentationStyle = .fullScreen
                                    vc.selectedIndex = 1
                                   self.present(vc, animated: false, completion: nil)
                                    
                                }
                            }
                        }
                        else{
                            
                            ProgressLoader.shared.hideLoader()
                             self.view.makeToast("Invalid Login Details!", duration: 1.0, position: .bottom)
                            
                        }
                        
                    }
                    
                }else{
                    ProgressLoader.shared.hideLoader()
                    self.view.makeToast("Invalid Details!!!", duration: 1.0, position: .bottom)
                   
                }
                ProgressLoader.shared.hideLoader()
            })
        }
        else{
           self.view.makeToast("Internet connection not available!", duration: 1.0, position: .bottom)
        }
        
    }
    
    func postTokenID(loginMasterId : String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                WebService.shared.postToken(deviceID:result.token, firebaseID: "", LoginMasterId: loginMasterId,completion: {(response, error ) in
                    if error == nil, let responseDict = response {
                        print(responseDict)
                    }
                })
            }
        }
    }
}
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
  func setLeftView(image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25)) // set your Own size
    iconView.image = image
    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
    iconContainerView.addSubview(iconView)
    leftView = iconContainerView
    leftViewMode = .always
    self.tintColor = .lightGray
  }
}

extension UITextField {
  func setRightView(image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 5, y: 10, width: 25, height: 25)) // set your Own size
    iconView.image = image
    let iconContainerView: UIView = UIView(frame: CGRect(x:0, y: 0, width: 35, height: 45))
    
    iconContainerView.addSubview(iconView)
    rightView = iconContainerView
    rightViewMode = .always
    self.tintColor = .lightGray
  }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

