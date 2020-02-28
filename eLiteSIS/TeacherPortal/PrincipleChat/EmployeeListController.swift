//
//  EmployeeListController.swift
//  eLiteSIS
//
//  Created by Apar256 on 24/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit
import DropDown
import CoreData

struct Department {
    let departmentID : String!
    let departmentName : String!
    
    init(_ dict:[String:Any]) {
        self.departmentID = dict["DepartmentId"] as? String
        self.departmentName = dict["DepartmentName"] as? String
    }
}

struct Employee {
    let registrationId : String!
    let employeeName : String!
    
    init(_ dict:[String:Any]) {
        self.registrationId = dict["RegistrationId"] as? String
        self.employeeName = dict["EmployeeName"] as? String
    }
}

class EmployeeListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var employeeList: UITableView!
    @IBOutlet weak var selectDepartmentButton: UIButton!
    @IBOutlet weak var emptyImage: UIImageView!
    
    var departmenttid : String = ""
    var getDepartment = [Department]()
    var getAllEmployee = [Employee]()
    var presentStatus : String = ""
    var presentString : String = ""
    
    
    let departmentDropdown =  DropDown()
    lazy var DepartmentDropdown: [DropDown] = {
        return [
            self.departmentDropdown
        ]
    }()
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectDepartmentButton.layer.cornerRadius = 8
        self.selectDepartmentButton.layer.borderWidth = 1
        self.selectDepartmentButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        employeeList.separatorColor = .clear
        //Call API
        self.getAllDepartment()
        self.emptyImage.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    // Mark : DropDown
    func setupDepartmentListDropDown() {
        Singleton.customizeDropDown()
        departmentDropdown.anchorView = selectDepartmentButton
        let  subjectID : [String]
        let name = (0..<getDepartment.count).map { (i) -> String in
            return getDepartment[i].departmentName }
        subjectID = (0..<getDepartment.count).map { (i) -> String in
            return getDepartment[i].departmentID }
        departmentDropdown.dataSource = name
        departmentDropdown.bottomOffset = CGPoint(x: 0, y: selectDepartmentButton.bounds.height)
        // Action triggered on selection
        departmentDropdown.selectionAction = {[weak self](index, item) in
            self?.selectDepartmentButton.setTitle("", for: .normal)
            self?.departmentLabel.text = item
            self?.departmenttid = subjectID[index]
            self?.getAllEmployee(departmentID:self!.departmenttid)
            //   self?.fetchAllEmployee(departmentID:self!.departmenttid)
        }
    }
    
    
    // Mark : Webservices
    func getAllDepartment() {
        WebService.shared.GetDepartment(completion: {(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"Fetching Department...")
                if let departmentDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    if departmentDict.count > 0 {
                        for obj in departmentDict {
                            
                            self.employeeList.isHidden = false
                            let depart = Department(obj)
                            self.getDepartment.append(depart)
                            self.setupDepartmentListDropDown()
                            self.emptyImage.isHidden = true
                        }
                    }
                    else
                    {
                        self.employeeList.isHidden = true
                        self.emptyImage.isHidden = false
                    }
                }
            }
            else
            {
                self.employeeList.isHidden = true
                self.emptyImage.isHidden = false
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    func getAllEmployee(departmentID:String) {
        self.getAllEmployee.removeAll()
        ProgressLoader.shared.showLoader(withText:"Fetching Employee list..")
        WebService.shared.GetEmployeeList(departmentID: departmentID, completion:{(response, error) in
            if error == nil , let responseDict = response {
                
                if let employeeDict = (responseDict["value"].arrayObject as? [[String:Any]]){
                    if employeeDict.count > 0 {
                        for obj in employeeDict {
                            
                            self.employeeList.isHidden = false
                            let employee = Employee(obj)
                            self.getAllEmployee.append(employee)
                            Singleton.setUpTableViewDisplay(self.employeeList, headerView:"dashboardTableViewCell", "SelectStudentTableViewCell")
                            self.employeeList.delegate = self
                            self.employeeList.dataSource = self
                            self.emptyImage.isHidden = true
                        }
                    }
                    else
                    {
                        self.employeeList.isHidden = true
                        self.emptyImage.isHidden = false
                    }
                    
                    ProgressLoader.shared.hideLoader()
                }
                
            }
            else{
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getAllEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SelectStudentTableViewCell") as? SelectStudentTableViewCell
        cell!.selectionStyle = .none
        cell!.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell!.textLabel?.text = self.getAllEmployee[indexPath.row].employeeName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destViewController  = mainStoryboard.instantiateViewController(withIdentifier: "facultyChat") as! FacultyDiscussionViewController
        destViewController.studentid = self.getAllEmployee[indexPath.row].registrationId
        destViewController.studentName = self.getAllEmployee[indexPath.row].employeeName 
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    @IBAction func selectDepartment(_ sender: Any) {
        self.departmentDropdown.show()
    }
}

