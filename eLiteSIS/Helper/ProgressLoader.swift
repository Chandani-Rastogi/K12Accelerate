//
//  ProgressLoader.swift
//  eLiteSIS
//
//  Created by apar on 15/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import Foundation
import MBProgressHUD

class ProgressLoader {
    
    static var shared = ProgressLoader()
    
    func showLoader(withText text:String){
        
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.last
            let hud = MBProgressHUD.showAdded(to: window!, animated: true)
            hud.label.text = text
            hud.backgroundView.color = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    
    func hideLoader(){
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.last
            MBProgressHUD.hide(for: window!, animated: true)
        }
    }
    
}
