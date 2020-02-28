//
//  WebService.swift
//  eLiteSIS
//
//  Created by apar on 05/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class WebService: NSObject {
    
    static var shared = WebService()
    
    //Port : 5359
    // fee : 5360
    
    
    // Prdoduction Student   "http://104.211.88.67:5147/SIS_Student/"
    // Production Faculty    "http://104.211.88.67:5147/SIS/"
    // Production Common URL "http://104.211.88.67:5347/SIS_Common/"
    // Production SchoolID   "K12_PRO_003P"
    // Sandbox Student       "http://104.211.88.67:5344/SIS_Student/"
    // Sandbox Faculty       "http://104.211.88.67:5344/SIS/"
    // Sandbox Common URL    "http://104.211.88.67:5344/SIS_Common/"
    // Sandbox SchoolID      "K12_PRO_003"
    
    
    let baseURL = "http://104.211.88.67:5344/SIS_Student/"
    let facultlyBaseURL = "http://104.211.88.67:5344/SIS/"
    let schoolid = "K12_PRO_003"
    let commonURL = "http://104.211.88.67:5344/SIS_Common/"
    
    
    //Mark : Student Webservices
    
    // Mark : Login
    func loginUserWith(username: String, password: String, completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        
        let requestURL = baseURL + "Login/" + username + "/" + password + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    func GetFacultyFromRegistrationID(regId:String ,  completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ){
        
        let requestURL = facultlyBaseURL + "GetFacultyFromRegistrationID/" + regId + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : GetUserProfile
    func getUserProfile(registrationValue:String,completion: @escaping(_ success:JSON?, _ error: Error? ) -> Void){
        
        let requestURL = baseURL + "GetProfile/" + registrationValue + "/" + schoolid
        print(requestURL)
        let encodeURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodeURL!,headers:nil).responseJSON {(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    //Mark : GetAddress
    func getAddress(registrationValue:String,completion: @escaping(_ success:JSON?, _ error: Error? ) -> Void){
        let requestURL = baseURL + "GetAddress/" + registrationValue + "/" + schoolid
        print(requestURL)
        let encodeURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodeURL!,headers:nil).responseJSON {(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    //Mark : getDashBoardDate
    func GetDashboardData(currentClassSession: String, studentID: String, completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        
        let requestURL = baseURL + "GetDashboardData/" + currentClassSession + "/" + studentID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : GetPinboardList    
    func GetPinboardList(completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetPinboardList/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    // Mark : getFacultyList
    
    func getFacultyList(sectionValue : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "TeacherList/" + sectionValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : StudentChatHistory
    func StudentChatHistory(registrationID : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "StudentChatHistory/" + registrationID + "/" + schoolid
        
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetTeacherDetail
    func GetTeacherDetail(facultyID : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetTeacherDetail/" + facultyID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetAvailableTime
    func GetAvailableTime(facultyValue : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetAvailableTime/" + facultyValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    
    
    
    // Mark : getScore
    func GetScore(marksID : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetScore/" + marksID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // Mark : GetAssignmentList
    func GetAssignmentList(studentID : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetAssignmentList/" + studentID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : DownloadAssignmentList
    func downloadAssignmentList(assignmentValue : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "DownloadAssignment/" + assignmentValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetStudentAttendance
    func GetStudentAttendance(studentID : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        //  let requestURL = baseURL + "GetStudentAttendance/" + studentID + "/" + schoolid
        //        print(requestURL)
        let requestURL = "http://104.211.88.67:5147/SIS_Student/GetStudentAttendance/EBFCC2E8-D981-E911-A977-000D3AF2C75A/K12_PRO_003P"
        
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetHealthList
    func GetHealthList(studentID : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetHealthList/" + studentID +  "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                // debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    // Mark : getPerformanceList
    func getPerformanceList(studentID : String,currentclasssession:String,sectionValue:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "getPerformanceList/" + studentID + "/" + currentclasssession + "/" + sectionValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // Mark : GetTimeTable
    func GetTimeTable(currentclasssession:String,sectionValue:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        
        let requestURL = baseURL + "GetTimeTable/" + currentclasssession + "/" + sectionValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    // Mark : GetMonthlyTimeTable
    func GetMonthlyTimeTable(currentclasssession:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        
        let requestURL = baseURL + "GetMonthlyTimeTable/" + currentclasssession + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    // Mark : GetStudyProgress
    func GetStudyProgress(currentclasssessionmarksid:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetStudyProgress/" + currentclasssessionmarksid + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetHolidayList
    func GetHolidayList(completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "Holidays/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark: GetGalleryFolder
    func GetGalleryFolders(completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetGalleryFolders/" + "K12_PRO_002"
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    //Mark: GetImages
    func GetImages(folderID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetImages/" + folderID + "/" + "K12_PRO_002"
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark: GetChapter
    func GetChapters(examinationID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetChapters/" + examinationID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    
    //Mark: GetChat
    func GetChat(studentNameValue:String,facultyNameValue:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetChat/" + studentNameValue + "/" + facultyNameValue + "/nodate/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                completion(responseDict, nil)
            }else{
                debugPrint(responseData.error)
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark: GteNotification
    func GetNotification(studentNameValue:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetNotificationList/" + studentNameValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : NotificationSummary
    func postNotificationSummary(fromDate:String,toDate:String,description:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void )  {
        let requestURL = facultlyBaseURL + "GetNotificationSummary/" + schoolid
        
        print(requestURL)
        let params = ["FromDate" : fromDate,
                      "ToDate" : toDate,
                      "Description" : description]
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    
    
    //Mark : PostChat
    func postChat(senderValue: String, recepientValue: String,newMessage:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = baseURL + "CreateDiscussion/" + schoolid
        
        print(requestURL)
        let params = ["_new_sender_value" : senderValue,
                      "_new_recipient_value" : recepientValue,
                      "new_message" : newMessage]
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : ChangePassword
    func ChangePassword(userType:Int,regeID:String, encryptedPassword: String,newPassword:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        
        let requestURL = commonURL + "ChangePass/" + regeID + "/" + String(userType) + "/" + schoolid
        
        print(requestURL)
        
        let params = ["Newpass_Encrypt":encryptedPassword,
                      "Newpass":newPassword,]
        
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                print(responseDict)
                
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    /////Mark : Faculty Webservices
    
    // Mark : Faculty Login
    func loginFacultyWith(username: String, password: String, completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        
        let requestURL = facultlyBaseURL + "Login/" + username + "/" + password + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : Faculty DashBaord
    func getFacultyDashBoard(registrationValue : String ,UserID :String, completion: @escaping  (_ success: JSON?, _ error: Error?) -> Void) {
        
        //        let requestURL = facultlyBaseURL + "GetFacultydashboard/" + registrationValue  + "/" + UserID + "/" + schoolid
        let requestURL = "http://104.211.88.67:5344/SIS/GetFacultydashboard/b3d7683d-5180-e911-a976-000d3af2c9f1/b6311e09-5f80-e911-a95c-000d3af266c5/K12_PRO_003"
        
        print(requestURL)
        let encodedUrl = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedUrl!,headers:nil).responseJSON{ (responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
            
        }
    }
    
    // Mark: Faculty DailySchedule
    func getFacultyDailySchedule(value : String , completion :@escaping  (_ success: JSON?, _ error: Error?) -> Void){
        let requestURL =  facultlyBaseURL + "DailySchedule/" + value + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{ (responseDara) -> Void in
            if let result = responseDara.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseDara.error)
            }
            
        }
    }
    
    // Mark : GetFacultyProfiledetails
    func GetFacultyProfiledetails(registrationValue:String , completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        let requestURL = facultlyBaseURL + "GetProfiledetails/" + registrationValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    // Mark : GetFacultyContact
    func GetFacultyContactFromRegistration(registrationValue:String , completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        let requestURL = facultlyBaseURL + "GetFacultyFromRegistrationID/" + registrationValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    // Mark : GetAllClasses
    func GetAllFacultyClasses(registrationValue:String , completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        
        let requestURL = facultlyBaseURL + "GetAllClassbyTeacherid/" + registrationValue + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    // Mark : GetAllClassSection
    func GetAllClassSection(registrationValue:String , completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        let requestURL = facultlyBaseURL + "GetAllClassSection/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    
    // Mark : Getstudentlistbyclasssession
    func Getstudentlistbyclasssession(sectionID:String , completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        let requestURL = facultlyBaseURL + "Getstudentlistbyclasssession/" + sectionID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    // Mark : GetFacultyLessonPlan
    func GetFacultyLessonPlan(registrationValue:String,SubjectId:String, completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        var requestURL : String = ""
        if SubjectId.count == 0 {
            requestURL = facultlyBaseURL + "GetFacultyLessonPlan/" + registrationValue + "/NA/" + schoolid
        }
        else{
            requestURL = facultlyBaseURL + "GetFacultyLessonPlan/" + registrationValue + "/" + SubjectId + "/" + schoolid
        }
        
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    // Mark : GetFacultyLessonPlan
    func GetFacultyStudyProgress(registrationValue:String ,subjectID:String, completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        
        let requestURL = facultlyBaseURL + "GetFacultyLessonPlan/" + registrationValue + "/" + subjectID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    // Mark : GetTaskAssignment
    func GetTaskAssignment(value:String , completion : @escaping (_ success: JSON?, _ error:Error?) -> Void){
        let requestURL = facultlyBaseURL + "GetTaskAssignment/" + value + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!,headers:nil).responseJSON{(responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    
    // Mark :PostAssignment
    func PostAssignment(LessonPlanId: String, FacultyID: String,Title:String,Description:String,issue_date:String,submit_date:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = facultlyBaseURL + "PostAssignment/" + schoolid
        print(requestURL)
        let params = ["LessonPlanId" : LessonPlanId,
                      "FacultyID" : FacultyID,
                      "Title" :Title,
                      "Description" : Description,
                      "issue_date" : issue_date,
                      "submit_date" : submit_date
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // Mark : Post Attendance
    func postAttendencebyFaculty(date: String, sectionValue: String,studentlist:[[String:Any]], completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = facultlyBaseURL + "PostAttendence/" + schoolid
        print(requestURL)
        
        let params = ["date" : date,
                      "Section" : sectionValue,
                      "StudentList" :studentlist] as [String : Any]
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // Mark : GetHomeWorkList
    func getHomeWorkList(userID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetHomeworkList/" + userID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    // Mark : DownloadHomeWorktList
    func DownloadHomeWorktList(notesID : String ,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        
        let requestURL = baseURL + "DownloadAssignment/" + notesID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //                debugPrint(responseDict)
                completion(responseDict, nil)
            }else {
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : ForgetPassword
    
    func getForgetPassword(userName : String ,mobileNumber:String,Dob:String, completion: @escaping  (_ success: JSON?, _ error: Error?) -> Void) {
        
        let requestURL = commonURL + "ForgetPassword/" + mobileNumber + "/" + userName + "/" + Dob + "/" + schoolid
        
        print(requestURL)
        let encodedUrl = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedUrl!,headers:nil).responseJSON{ (responseData) -> Void in
            if let result = responseData.result.value{
                let responseDict = JSON(result)
                completion(responseDict,nil)
            }else{
                completion(nil,responseData.error)
            }
        }
    }
    
    // Mark : GetHomeWorkList
    func getFacultyHomeWorkList(facultyID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = facultlyBaseURL + "GetHomeworkList_Faculty/" + facultyID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetSubjects
    func getSubjects(facultyID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = facultlyBaseURL + "GetSubjects/" + facultyID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : PostHomeWork
    func postHomeWork(facultyID :String,subjectId:[String], title: String,description:String,StartDate : String , endDate : String ,fileName:String,base64:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = facultlyBaseURL + "PostHomework/" + schoolid
        
        print(requestURL)
        let params = [
            "FacultyID":facultyID,
            "SubjectID" : subjectId,
            "Title" : title,
            "Description" : description,
            "EndDate" : endDate,
            "StartDate" : StartDate,
            "file_name" : fileName,
            "Base64" : base64
            ] as [String : Any]
        
        
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : PostLeave
    
    func postLeave(fromDate :String,toDate: String, studentID: String,leaveREason:String,roleID : String , completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = baseURL + "ApplyLeave/" + schoolid
        
        print(requestURL)
        let params = [
            "FromDate":fromDate,
            "ToDate" : toDate,
            "StudentId" : studentID,
            "LeaveReason" : leaveREason,
            "LogedinRole" : roleID
        ]
        
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    // PostToken
    
    func postToken(deviceID :String,firebaseID: String, LoginMasterId: String , completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        
        let requestURL = commonURL + "UpdateTokenId/" + schoolid
        
        print(requestURL)
        let params = [
            "FirebaseId":firebaseID,
            "DeviceId" :deviceID ,
            "LoginMasterId" : LoginMasterId
        ]
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : postCustomNotifications
    func postCustomNotifications(title :String,body: String,RecipientType : String, topicList:[String],fileName : String,base64String:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = facultlyBaseURL + "PostNotification/" + schoolid
        print(requestURL)
        
        let params = [
            "Title": title,
            "Body" : body,
            "RecipientType" : RecipientType,
            "TopicIds" : topicList,
            "Base64" : base64String,
            "file_name" : fileName
            ] as [String : Any]
        
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    //Mark : PostHomeWork
    
    func postCicularAndSyllabus(uploadType:Int,facultyID :String,subjectId:String, title: String,description:String,StartDate : String , endDate : String ,fileName:String,base64:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = facultlyBaseURL + "PostDigitalContent/" + schoolid
        print(requestURL)
        
        let params = [
            "FacultyID":facultyID,
            "Base64" : base64,
            "UploadType" : uploadType,
            "Description" : description,
            "file_name" : fileName,
            "Title" : title,
            "ClassId" : subjectId
            
            ] as [String : Any]
        
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // Mark : GetDigitalContent
    func GetDigitalContent(uploadType:Int,userID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetDigitalContent/" + String(uploadType) + "/" + userID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // GetattendanceforPrincipal
    
    func GetAttendanceforPrincipal(classID:String,AttendanceDate:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = facultlyBaseURL + "GetAttendanceforPrincipal/" + AttendanceDate + "/" + classID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // GetAllFacultyList
    func getallFacultyList(completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = facultlyBaseURL + "/allFacultyList/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // GetAllFacultyList
    func FeedbackReport(fromDate:String,toDate:String,facultyID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        var IDString : String = ""
        var fromdate : String = ""
        var todate : String = ""
        
        
        if facultyID.count == 0 {
            IDString = "0"
        }
        else {
            IDString = facultyID
        }
        if fromDate.count == 0{
            fromdate = "01-01-1990"
        }
        else{
            fromdate = fromDate
        }
        if toDate.count == 0{
            todate = "01-01-1990"
        }
        else{
            todate = toDate
        }
        
        let requestURL = facultlyBaseURL + "FeedbackReport/" + fromdate + "/" + todate + "/" + IDString + "/" + schoolid
        print(requestURL)
        
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    // HomeworkReport
    func HomeworkReport(fromDate:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = facultlyBaseURL + "HomeworkReport/" + fromDate + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : Get Transport Detail
    func GetTransportDetail(studentID:String,completion: @escaping (_ success: TransportResponseRootClass?, _ error: Error? ) -> Void ) {
        let requestURL = baseURL + "GetTransportDetail/" + studentID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                let transportResponse = TransportResponseRootClass(fromJson: responseDict)
                
                //debugPrint(responseDict)
                completion(transportResponse, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetDepartmentList
    func GetDepartment(completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = commonURL + "GetDepartmentList/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // Mark : GetEmployeeList
    func GetEmployeeList(departmentID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
        let requestURL = commonURL + "GetEmployeeList/" + departmentID + "/" + schoolid
        print(requestURL)
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : Get Basic Fee Detail For Student
    func GetBasicFeeDetailForStudent(studentID:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = "http://104.211.88.67:5360/api/SISeUPP"
        print(requestURL)
        
        let params = [
            "SchoolUniqueId":"C720308_07",
            "StudentUniqueId" : "RFIS|S|1920|0001",
            "ServiceCode" : "Svc_SIS_Lite_UPP_D04"
            ] as [String : Any]
        
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    // Mark : GetFeeDetailForUppPaymentt
    func GetFeeDetailForUppPayment(regID:String,fromMonth:String,toMonth:String,paymentID:String,amount:String, completion: @escaping (_ success: JSON?, _ error:Error?) -> Void)  {
        let requestURL = "http://104.211.88.67:5360/api/SISeUPP"
        print(requestURL)
        
        let params = [
            "SchoolUniqueId":"C720308_07",
            "StudentUniqueId" : "RFIS|S|1920|0001",
            "ServiceCode" : "Svc_SIS_Lite_UPP_D07",
            "PaymentInformation":[
            "FromMonthID" : fromMonth,
            "ToMonthID" :toMonth ,
            "TotalPayableAmount" : amount
            ]
            ] as [String : Any]
        
        print(params)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //  debugPrint(responseDict)
                completion(responseDict, nil)
            } else {
                completion(nil, responseData.error)
            }
        }
    }
    
    
    // Mark : GetFeeReceipt
    func GetFeeReceipt(regID:String,completion: @escaping (_ success: JSON?, _ error: Error? ) -> Void ) {
       // let requestURL = baseURL + "GetFeeReceipt/" + regID + "/" + schoolid
        
        let requestURL = "http://104.211.88.67:5359/SIS_Student/" + "GetFeeReceipt/" + "E074B40D-E3CE-E911-A813-000D3AF0563B" + "/" + "C720308_07"
        print(requestURL)
        
        let encodedURL = requestURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedURL!, headers:nil ).responseJSON { (responseData) -> Void in
            if let result = responseData.result.value {
                let responseDict = JSON(result)
                //debugPrint(responseDict)
                completion(responseDict, nil)
            }else{
                completion(nil, responseData.error)
            }
        }
    }
    
}
