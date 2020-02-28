//
//  AlertManager.swift
//  eLiteSIS
//
//  Created by apar on 15/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit


class AlertManager {
    
    var rootWindow: UIWindow!
    static var shared = AlertManager()
    
    
    func showAlertWith(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.rootViewController = UIViewController()
        AlertManager.shared.rootWindow = UIApplication.shared.windows.first
        window.windowLevel = UIWindow.Level.alert
        window.makeKeyAndVisible()
        window.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.rootViewController = UIViewController()
        AlertManager.shared.rootWindow = UIApplication.shared.windows.first
        window.windowLevel = UIWindow.Level.alert
        window.makeKeyAndVisible()
        window.rootViewController?.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                guard window.rootViewController?.presentedViewController == alert else { return}
                window.rootViewController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}
