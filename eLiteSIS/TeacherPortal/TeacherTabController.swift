//
//  TeacherTabController.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class TeacherTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if  item.title == "Attendance" {
            if UserDefaults.standard.value(forKey:"new_rolecode") as? String == "212" {
                      
                  let alert = UIAlertController(title: "Alert!", message: "Only class teacher can mark the attendance!!", preferredStyle: .alert)
                             let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                                item.isEnabled = false
                             })
                             alert.addAction(okButton)
                             DispatchQueue.main.async(execute: {
                                 self.present(alert, animated: true)
                             })
                      
                  }
        }
        print("Selected item")
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
    }

   

}
