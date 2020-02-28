//
//  FacultyDiscussionViewController.swift
//  eLiteSIS
//
//  Created by apar on 14/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import CoreData
import Toolbar
import Toast_Swift
import KMPlaceholderTextView

class FacultyDiscussionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var chatTableView: UITableView!
    var facultyprofileImage : String = ""
    var receipeintValue : String = ""
    var studentid : String = ""
    var studentName : String = ""
    fileprivate var messages: [MessageModel] = []
    
    let toolbar: Toolbar = Toolbar()
    var textView: KMPlaceholderTextView?
    var item0: ToolbarItem?
    var item1: ToolbarItem?

    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return toolbar
    }
    
    var constraint: NSLayoutConstraint?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = self.studentName
        navigationItem.largeTitleDisplayMode = .automatic

        self.navigationController?.navigationBar.isHidden = false
        // ToolBar
        self.toolbar.maximumHeight = 100
        self.toolbar.backgroundColor =  #colorLiteral(red: 0.8555480647, green: 0.8555480647, blue: 0.8555480647, alpha: 1)
        self.toolbar.isTranslucent = true
        let view: KMPlaceholderTextView = KMPlaceholderTextView(frame: .zero)
        
        view.delegate = self
        view.font = UIFont.systemFont(ofSize: 14)
        view.placeholder = "Type a message"
        self.textView = view as? KMPlaceholderTextView
        self.item0 = ToolbarItem(customView: view)
        self.item1 = ToolbarItem(title: "Send", target: self, action: #selector(send))
     
        self.toolbar.setItems([self.item0!, self.item1!], animated: false)
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .clear
        
        /// API Call
        self.getchat((UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!)

        registerForKeyboardWillShowNotification(self.chatTableView) { (keyboardSize) in
            print("size 1 - \(keyboardSize!)")
        }
        registerForKeyboardWillHideNotification(self.chatTableView) { (keyboardSize) in
            print("size 2 - \(keyboardSize!)")
        }

  
    }
    
    
    
    @IBAction func refreshChatButton(_ sender: Any) {
    /// API Call
   self.getchat((UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
  
    }
    
    @objc func send() {
        self.toolbar.setNeedsLayout()
        let string = (self.textView?.text.trimmingCharacters(in:.whitespaces))
        if string?.count == 0 {
         
            self.view.makeToast("Cannot Send Empty Text!", duration: 1.0, position: .center)
        }
        else{
             self.postChat(string!)
        }
      
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:true)
    }

    // TExtView
    func textViewSettings (){
        // TextView
        self.textView?.placeholder = "Type a message"
        self.textView?.layer.borderWidth = CGFloat(0.5)
        self.textView?.layer.borderColor = UIColor.darkGray.cgColor
        self.textView?.layer.cornerRadius = CGFloat(13)
        self.textView?.delegate = self
        self.textView?.textColor = UIColor.lightGray
        self.textView?.font = UIFont.italicSystemFont(ofSize: (self.textView?.font?.pointSize)!)
        self.textView?.returnKeyType = .done
        
        // Button
        // self.sendButton.layer.cornerRadius = CGFloat(13)
        
    }
    
    //MARK:- UITextViewDelegates
    func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name:"Helvetica Neue", size:12)

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
    }
    
   // UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let size: CGSize = textView.sizeThatFits(textView.bounds.size)
        if let constraint: NSLayoutConstraint = self.constraint {
            textView.removeConstraint(constraint)
        }
        self.constraint = textView.heightAnchor.constraint(equalToConstant: size.height)
        self.constraint?.priority = UILayoutPriority.defaultHigh
        self.constraint?.isActive = true
    }

    
    
    // Table View
    
    func tableViewSettings() {
        
        self.chatTableView.rowHeight = UITableView.automaticDimension
        self.chatTableView.estimatedRowHeight = 140
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.reloadData()
        let indexPath = NSIndexPath(row: messages.count-1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentID = UserDefaults.standard.value(forKey:"_sis_studentname_value") as? String ?? ""
        if messages[indexPath.row].newSenderValue == studentID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderTableViewCell
            cell.senderImageView.layer.cornerRadius = 15
            cell.senderMessageTextView.layer.cornerRadius = 8
            cell.senderImageView.image = #imageLiteral(resourceName: "profile")
            if let imgData = UserDefaults.standard.data(forKey:"entityimage") {
                cell.senderImageView.image = UIImage(data: imgData)
            }
            cell.senderMessageTextView.text = messages[indexPath.row].newMessage
            cell.lastTimeLabel.text = Date.getFormattedDate(string:messages[indexPath.row].createdon, formatter: "hh:mm")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell") as! ReceiverTableViewCell
            cell.receiverImageView.layer.cornerRadius = 15
            cell.receiverMessageTextView.layer.cornerRadius = 8
            cell.receiverImageView.image = #imageLiteral(resourceName: "profile")
            let teacherImage = UIImage.decodeBase64(toImage:facultyprofileImage)
            let imgData = teacherImage.pngData()
            
            if imgData != nil {
                cell.receiverImageView.image = UIImage(data:imgData!)
            }
            else
            {
                cell.receiverImageView.image = #imageLiteral(resourceName: "profile")
            }
            
            cell.receiverMessageTextView.text = messages[indexPath.row].newMessage
            cell.lastTimeLabel.text = Date.getFormattedDate(string:messages[indexPath.row].createdon, formatter: "hh:mm")
            
            return cell
        }
    }
    
    
    // API Call
    func getchat(_ facultyId:String) {
        
     ProgressLoader.shared.showLoader(withText:"Loading Chat ....")
    WebService.shared.GetChat(studentNameValue:studentid,facultyNameValue:(UserDefaults.standard.value(forKey:"_sis_registration_value") as? String)!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.messages.removeAll()
                if let chatDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in chatDict {
                        let msg = MessageModel(fromDictionary: obj)
                        self.messages.append(msg)
                        self.receipeintValue = (msg.newRecipientValue)!
                        self.textViewSettings()
                        self.tableViewSettings()
                    }
                }
                ProgressLoader.shared.hideLoader()
            }else{
                ProgressLoader.shared.hideLoader()
                
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func postChat(_ textMessage:String) {
        if textMessage.count > 0 {
            WebService.shared.postChat(senderValue:UserDefaults.standard.value(forKey:"_sis_registration_value") as? String ?? "", recepientValue:studentid, newMessage:textMessage, completion: {(response, error ) in
                if error == nil, let responseDict = response {
                    if responseDict["status"] == "Success" {
                        self.textView?.text = ""
                        self.getchat(textMessage)
                    }
                } else {
                  
                }
            })
        }
    }
    
}

//MARK:- Scroll to bottom function
extension UITableView {
    func scrollToBottom(animated: Bool = true, scrollPostion: UITableView.ScrollPosition = .bottom) {
    let no = self.numberOfRows(inSection: 0)
    if no > 0 {
      let index = IndexPath(row: no - 1, section: 0)
      scrollToRow(at: index, at: scrollPostion, animated: animated)
    }
  }
}
extension FacultyDiscussionViewController {

    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height, right: scrollView.contentInset.right)

            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }

    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)

            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }
}

extension UIScrollView {

    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}
