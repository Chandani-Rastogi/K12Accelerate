//
//  Date.swift
//  eLiteSIS
//
//  Created by apar on 06/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import Foundation

extension Date {
    
    static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!)
    }
    
    static func getFormattedDate3(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy HH:mm:ss aa"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!)
    }
    
    static func getFormattedDate1(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!)
    }
    static func getFormattedTime(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!)
    }
    
    static func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
}
