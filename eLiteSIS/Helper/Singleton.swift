//
//  Singleton.swift
//  eLiteSIS
//
//  Created by apar on 25/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData
import DropDown
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class Singleton: NSObject {
  
    static let sharedInstance = Singleton()
    static func convertToJSONArray(moArray: [NSManagedObject]) -> [[String:Any]] {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
    // Custom Method fro Drop Down
  static func customizeDropDown() {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
        if #available(iOS 11.0, *) {
            appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        }
    }
    
    func deleteAllRecords(EntityName:String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName:EntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    // return single cell label
    
   static func returnlabel(_ text:String , _ tableView:UITableView) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width:tableView.bounds.size.width, height:tableView.bounds.size.width))
        label.text = text
        label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        label.textAlignment = .center
        label.sizeToFit()
        tableView.backgroundView = label
        tableView.separatorStyle = .none
    }
    
    static func setUpTableViewDisplay(_ tableView : UITableView ,headerView :String ,_ tableViewCell: String) {
         tableView.separatorStyle = .none
         tableView.scrollsToTop = false
         tableView.bounces = false
         tableView.sectionHeaderHeight = UITableView.automaticDimension
         if headerView.count > 0{
           tableView.register(UINib(nibName:headerView, bundle: nil), forHeaderFooterViewReuseIdentifier:headerView)
         }
         tableView.register(UINib(nibName:tableViewCell, bundle: nil), forCellReuseIdentifier:tableViewCell)
         tableView.reloadData()
     }
    
   static func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
}
