//
//  DiscussionViewController.swift
//  eLiteSIS
//
//  Created by apar on 16/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import Toolbar
import CoreData
import KMPlaceholderTextView

struct MessageModel
{
    var newRecipientValue : String!
    var newSenderValue : String!
    var createdon : String!
    var newMessage : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        newRecipientValue = dictionary["_new_recipient_value"] as? String
        newSenderValue = dictionary["_new_sender_value"] as? String
        createdon = dictionary["createdon"] as? String
        newMessage = dictionary["new_message"] as? String
    }
}

class DiscussionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var chatTableView: UITableView!
   
    var facultyID : String = ""
    var receipeintValue : String = ""
    var facultyprofileImage : String = ""
    var facultyname : String = ""
    var fromTeacherList = Bool()

    fileprivate var messages: [MessageModel] = []
    var toolbarBottomConstraint: NSLayoutConstraint?
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


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = self.facultyname
        chatTableView.separatorStyle = .none
        // ToolBar
        self.toolbar.maximumHeight = 200
        let view: KMPlaceholderTextView = KMPlaceholderTextView(frame: .zero)
        view.placeholder = "Type a message"
        view.delegate = self
        view.font = UIFont.systemFont(ofSize: 14)
        self.textView = view as? KMPlaceholderTextView
        self.item0 = ToolbarItem(customView: view)
        self.item1 = ToolbarItem(title: "Send", target: self, action: #selector(send))
        self.toolbar.setItems([self.item0!, self.item1!], animated: false)
        // API
        self.getchat(self.facultyID)
        registerForKeyboardWillShowNotification(self.chatTableView) { (keyboardSize) in
            print("size 1 - \(keyboardSize!)")
        }
        registerForKeyboardWillHideNotification(self.chatTableView) { (keyboardSize) in
            print("size 2 - \(keyboardSize!)")
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func refreshChatButton(_ sender: Any) {
    // API
        self.getchat(self.facultyID)
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

    var constraint: NSLayoutConstraint?
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.item1?.isEnabled = !textView.text.isEmpty
        
        let size: CGSize = textView.sizeThatFits(textView.bounds.size)
        if let constraint: NSLayoutConstraint = self.constraint {
            textView.removeConstraint(constraint)
        }
        self.constraint = textView.heightAnchor.constraint(equalToConstant: size.height)
        self.constraint?.priority = UILayoutPriority.defaultHigh
        self.constraint?.isActive = true
    }

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentID = UserDefaults.standard.value(forKey:"_sis_registration_value") as? String ?? ""
        if messages[indexPath.row].newSenderValue == facultyID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell") as! SenderTableViewCell
            cell.senderImageView.layer.cornerRadius = 15
            cell.senderMessageTextView.layer.cornerRadius = 8
            cell.senderImageView.image = #imageLiteral(resourceName: "profile")
            let teacherImage = UIImage.decodeBase64(toImage:facultyprofileImage)
            let imgData = teacherImage.pngData()
            if imgData != nil{
                cell.senderImageView.image = UIImage(data:imgData!)
            }
            else{
                cell.senderImageView.image = #imageLiteral(resourceName: "profile")
            }
            
            
            cell.senderMessageTextView.text = messages[indexPath.row].newMessage
            cell.lastTimeLabel.text = Date.getFormattedDate(string:messages[indexPath.row].createdon, formatter: "hh:mm")
            
            
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as! ReceiverTableViewCell
            cell.receiverImageView.layer.cornerRadius = 15
            cell.receiverMessageTextView.layer.cornerRadius = 8
            cell.receiverImageView.image = #imageLiteral(resourceName: "profile")
            if let imgData = UserDefaults.standard.data(forKey:"entityimage") {
                cell.receiverImageView.image = UIImage(data: imgData)
            }
            cell.receiverMessageTextView.text = messages[indexPath.row].newMessage
            cell.lastTimeLabel.text = Date.getFormattedDate(string:messages[indexPath.row].createdon, formatter: "hh:mm")
            return cell
        }
    }
   
    
    func textViewSettings (){
        // TextView
        self.textView?.layer.borderWidth = CGFloat(0.5)
        self.textView?.layer.borderColor = UIColor.darkGray.cgColor
        self.textView?.layer.cornerRadius = CGFloat(13)
        self.textView?.delegate = self
        self.textView?.placeholder = "Type a message"
        self.textView?.textColor = UIColor.lightGray
        self.textView?.font = UIFont.italicSystemFont(ofSize: (self.textView?.font?.pointSize)!)
        self.textView?.returnKeyType = .done
       // Button
       // self.sendButton.layer.cornerRadius = CGFloat(13)
        
    }

   //MARK:- UITextViewDelegates
   func textViewDidBeginEditing(_ textView: UITextView) {
    
       
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func tableViewSettings() {
        
        self.chatTableView.rowHeight = UITableView.automaticDimension
        self.chatTableView.estimatedRowHeight = 140
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.reloadData()
        let indexPath = NSIndexPath(row: messages.count-1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
    }
    
    
    func getchat(_ facultyId:String) {
        
        ProgressLoader.shared.showLoader(withText:"Loading Chat ....")
        WebService.shared.GetChat(studentNameValue:UserDefaults.standard.value(forKey:"_sis_registration_value") as? String ?? "",facultyNameValue:self.facultyID, completion:{(response, error) in

            if error == nil , let responseDict = response {
               self.messages.removeAll()
                
                if let chatDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in chatDict {
                        let msg = MessageModel(fromDictionary: obj)
                        self.messages.append(msg)
                        self.receipeintValue = (msg.newRecipientValue)!
                        self.textViewSettings()
                        self.tableViewSettings()
                        ProgressLoader.shared.hideLoader()
                    }
                }
                 ProgressLoader.shared.hideLoader()
            }else{
                 ProgressLoader.shared.hideLoader()
               
            }
           
        })
    }
    
    func postChat(_ textMessage:String) {
        
        WebService.shared.postChat(senderValue:UserDefaults.standard.value(forKey:"_sis_registration_value") as? String ?? "", recepientValue:   self.facultyID, newMessage:textMessage, completion: {(response, error ) in
            if error == nil, let responseDict = response {
                if responseDict["status"] == "Success" {
                    self.textView?.text = ""
                    self.getchat(self.facultyID)
                }
            } else {
             
            }
        })
    }
 
}
extension DiscussionViewController {

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
