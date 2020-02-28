//
//  Reusable.swift
//  eLiteSIS
//
//  Created by apar on 20/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import Foundation


public class ReusableAPI: NSObject {
    
     static var shared = ReusableAPI()
    
    func fetchclasses(value:String) {
        WebService.shared.GetAllFacultyClasses(registrationValue:value, completion:{(response, error) in
            if error == nil , let responseDict = response {
                if let classDict = responseDict.arrayObject as? [[String:Any]]{
                    for data in classDict {
                        let classes = Classes(data)
//                        self.getClasses.append(classes)
//                        self.setupStudentlistDropDown()
//                        self.fetchAllStudents()
                        
                    }
                }
            }else{
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
          
        })
    }
    
}
