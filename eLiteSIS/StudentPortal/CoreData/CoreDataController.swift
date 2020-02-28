//
//  CoreDataController.swift
//  eLiteSIS
//
//  Created by apar on 05/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject {
    
    static let sharedInstance = CoreDataController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
   func insertandUpdateLogInData(userID:String,password:String) {
        let context = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: userEntity!, insertInto: context)
        newUser.setValue(userID, forKey: "userID")
        newUser.setValue(password, forKey: "password")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    // Mark : UserProfile
    func insertAndUpdateUserProfile(registrationID:String,jsonObject:[[String:Any]]) {
        
         let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "regID", ascending: true)]
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"regID!= nil")
        
        do{
          fetch.predicate = NSPredicate(format:"regID == %@",registrationID)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0{
                    return
                }
                else {
                    for obj in jsonObject {
                        let profileEntity = NSEntityDescription.entity(forEntityName: "UserProfile", in: managedContext)!
                        let userProfile = UserProfile(entity: profileEntity, insertInto: managedContext)
                        userProfile.admissionDate = obj["sis_dateofadmission"] as? String
                        userProfile.categoryTxt = obj["CategoryText"] as? String
                        userProfile.classNme = obj["_sis_class"] as? String
                        userProfile.dob = obj["sis_dateofbirth"] as? String
                        userProfile.email = obj["emailaddress"] as? String
                        userProfile.entityImage = obj["entityimage"] as? String
                        userProfile.fatherName = obj["sis_fathername"] as? String
                        if (obj["sis_gender"] as? Int) == 1{
                            userProfile.gender = "Male"
                        }
                        else if (obj["sis_gender"] as? Int) == 2 {
                            userProfile.gender = "Female"
                        }
                        userProfile.motherName = obj["sis_mothername"] as? String
                        userProfile.mobileNumber = obj["sis_primarymobilenumber"] as? String
                        userProfile.name = obj["sis_name"] as? String
                        if let programNm = obj["new_program"] as? [String:Any] {
                            userProfile.programName = programNm["sis_name"] as? String
                        }
                        userProfile.regID = registrationID
                        userProfile.registrationNum = obj["_sis_registration"] as? String
                        userProfile.sectionName = obj["_sis_section"] as? String
                        userProfile.sectionValue = obj["_sis_section_value"] as? String
                        userProfile.sessionName = obj["_sis_currentclasssession"] as? String
                        userProfile.sessionValue = obj["_sis_currentclasssession_value"] as? String
                        userProfile.studentID = obj["sis_studentid"] as? String
                        userProfile.studentValue = obj["_sis_studentname_value"] as? String
                        userProfile.classValue = obj["_sis_class_value"] as? String
                        
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                   
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    // Mark : Fetch User Profile Data
    func fetchProfileDataRequest(regID:String,completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [UserProfile]{
        var student:[UserProfile] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserProfile")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateIsStudent = NSPredicate(format: "regID == %@",regID)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsStudent])
        fetchRequest.predicate = andPredicate
        do{
            student = try managedContext.fetch(fetchRequest) as! [UserProfile]
            if student.count > 0 {
              completion(student as? NSObject , nil)
            }
            else{
                completion(nil, Error.self as? Error)
            }
            
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return student
    }
    
    // Mark : Time Table
    
    func insertAndUpdatetimeTable(startDate:String ,notify:Bool,jsonObject:[[String:Any]]) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<Timetable> = Timetable.fetchRequest()
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"startDate!= nil")
        
        do {
            fetch.predicate = NSPredicate(format:"newStartdate == %@",startDate)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                if fetchResults.count != 0 {
                    var managedObject = fetchResults[0]
                    managedObject.setValue(notify, forKey: "notify")
                    try managedContext.save()
                }
                else
                {
                    for obj in jsonObject {
                        
                        let timetableEntity = NSEntityDescription.entity(forEntityName:"Timetable", in: managedContext)!
                        let timetble = Timetable(entity: timetableEntity, insertInto: managedContext)
                        timetble.newClasssessionValue = obj["_new_classsession_value"] as? String
                        timetble.newClasstaken = obj["_new_classtaken"] as? String
                        timetble.newClasstakenValue = obj["_new_classtaken_value"] as? String
                        timetble.newEndtime = obj["new_endtime"] as? String
                        timetble.newStartdate = obj["new_startdate"] as? String
                        let newsubject = obj["new_subject"] as? [String:Any]
                        timetble.sisName =  newsubject!["sis_name"] as? String
                        timetble.sisValue = newsubject!["_sis_subject_value"] as? String
                        timetble.notify = false
                        timetble.month = (Date.getFormattedDate(string:timetble.newStartdate!, formatter:"MMM-yyyy"))
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        if let startdate = dateFormatter.date(from:timetble.newStartdate!) {
                            timetble.startDate = startdate as NSDate
                        }
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                    
                }
            }
            }
         catch {
            print("Fetch Failed: \(error)")
        }
        
        
       
    }
    
    // Mark : fetch time table
    
    func fetchtimetableRequest(subjectString :String,monthString :String,facultyString:String,completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [Timetable] {
      
        var timetable:[Timetable] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Timetable")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        
        let predicateIsSubject = NSPredicate(format: "sisName == %@",subjectString)
        let predicateIsMonth = NSPredicate(format: "month == %@",monthString)
        let  predicateIsFaculty = NSPredicate (format: "newClasstaken == %@",facultyString)
     
        if (subjectString.count > 0) {
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsSubject])
            fetchRequest.predicate = andPredicate
        }
        else if (monthString.count > 0) {
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates:[predicateIsMonth])
            fetchRequest.predicate = andPredicate
        }
        else if (facultyString.count > 0) {
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsFaculty])
            fetchRequest.predicate = andPredicate
        }
        
        do{
            timetable = try managedContext.fetch(fetchRequest) as! [Timetable]
            if timetable.count > 0{
               // print(timetable)
                completion(timetable as [Timetable] as NSObject , nil)
            }
            else{
                completion(nil, Error.self as? Error)
            }
            
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return timetable
    }
    
    
    // Mark : StudentAddress
    func insertAndUpdateStudentAddress(registrationID:String,jsonObject:[String:Any]){
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<StudentAddress> = StudentAddress.fetchRequest()
        fetch.predicate = NSPredicate(format:"regID!= nil")
        fetch.returnsObjectsAsFaults = false
        do{
            fetch.predicate = NSPredicate(format:"regID == %@",registrationID)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0{
                    return
                }
                else{
                    let profileEntity = NSEntityDescription.entity(forEntityName: "StudentAddress", in: managedContext)!
                    let userAddress = StudentAddress(entity: profileEntity, insertInto: managedContext)
                    userAddress.addressObject = jsonObject as NSObject
                    userAddress.regID = registrationID
                    try! managedContext.save()
                }
                
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
        
    }

    // Mark : fetchAddressDataRequest
    func fetchAddressDataRequest(regID:String,completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [StudentAddress]{
        var address:[StudentAddress] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StudentAddress")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "regID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        let predicateIsStudent = NSPredicate(format: "regID == %@",regID)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsStudent])
        fetchRequest.predicate = andPredicate
        do{
            address = try managedContext.fetch(fetchRequest) as! [StudentAddress]
            if address.count > 0{
                for data in address as [NSManagedObject] {
                    if let result = data.value(forKey:"addressObject")
                    {
                        completion(result as? NSObject, nil)
                    }
                }
            }
            else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return address
    }
    
    // Mark : HealthReport
    func insertAndUpdateHealthReport(registrationID:String,jsonObject:[String:Any]){
        let fetch : NSFetchRequest<HealthReport> = HealthReport.fetchRequest()
        fetch.predicate = NSPredicate(format:"regID!= nil")
        let managedContext = appDelegate.persistentContainer.viewContext
        let count = try! managedContext.count(for:fetch)
        if count > 0{
            return
        }
        let profileEntity = NSEntityDescription.entity(forEntityName: "HealthReport", in: managedContext)!
        let health = HealthReport(entity: profileEntity, insertInto: managedContext)
        health.reportObject = jsonObject as NSObject
        health.regID = registrationID
        try! managedContext.save()
        
    }
    // Mark :fetchHealthReportDataRequest
    func fetchHealthReportDataRequest(completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [HealthReport]{
        var report:[HealthReport] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HealthReport")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "regID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            report = try managedContext.fetch(fetchRequest) as! [HealthReport]
            for data in report as [NSManagedObject] {
                if let result = data.value(forKey:"reportObject")
                {
                    completion(result as? NSObject, nil)
                }else{
                    completion(nil, Error.self as? Error)
                }
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return report
    }
   
 //   Mark: HolidayList
    func insertAndUpdateHolidayList(startDate:String,jsonObject:[[String:Any]]) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<HolidayList> = HolidayList.fetchRequest()
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"startdate!= nil")
        do {
            fetch.predicate = NSPredicate(format:"startdate == %@",startDate)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let timetableEntity = NSEntityDescription.entity(forEntityName:"HolidayList", in: managedContext)!
                        let holiday = HolidayList(entity: timetableEntity, insertInto: managedContext)
                        holiday.startdate = obj["new_startdate"] as? String
                        holiday.day = obj["new_dayname"] as? String
                        holiday.holidayName = obj["sis_name"] as? String
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                    
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
   // Mark: fetchHolidatDataRequest
    func fetchHolidatDataRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [HolidayList] {
        var holidayList:[HolidayList] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"HolidayList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startdate", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            holidayList = try managedContext.fetch(fetchRequest) as! [HolidayList]
                if holidayList.count > 0
                {
                    completion(holidayList as? NSObject, nil)
                }else{
                    completion(nil, Error.self as? Error)
                }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return holidayList
    }
    
    
    //   Mark: StudentDashboard
    func insertAndUpdateStudentDashBoard(studentName:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<StudentDashboard> = StudentDashboard.fetchRequest()
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"studentName!= nil")
        do {
            fetch.predicate = NSPredicate(format:"studentName == %@",studentName)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let dashboardEntity = NSEntityDescription.entity(forEntityName:"StudentDashboard", in: managedContext)!
                        let dashbaord = StudentDashboard(entity: dashboardEntity, insertInto: managedContext)
                        dashbaord.newTotalclasses = (obj["new_totalclasses"] as? Int16)!
                        dashbaord.presentDays = (obj["new_presentdays"] as? Int16)!
                        dashbaord.absentsDays = (obj["new_absentdays"] as? Int16)!
                        dashbaord.totalMarks = (obj["new_totalmarks"] as? Int16)!
                        dashbaord.obtainedMarks = (obj["new_obtainedmarks"] as? Int16)!
                        dashbaord.percentage = (obj["new_percentage"] as? Double)!
                        dashbaord.studyProgress = (obj["new_studyprogress"] as? Double)!
                        dashbaord.totalAssignment = (obj["new_totalassignments"] as? Int16)!
                        dashbaord.completedAssignments = (obj["new_completedassignments"] as? Int16)!
                        dashbaord.totalsSubjects = (obj["new_totalsubjects"] as? Int16)!
                        dashbaord.studentName = (obj["sis_name"] as? String)!
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                    
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
  //  Mark : StudentDashboard
    func fetchStudentDashboardDataRequest(student:String,completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [StudentDashboard] {
        var dashBoardList:[StudentDashboard] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"StudentDashboard")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "studentName", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        let predicateIsStudent = NSPredicate(format: "studentName == %@",student)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsStudent])
        fetchRequest.predicate = andPredicate
           
        do{
            dashBoardList = try managedContext.fetch(fetchRequest) as! [StudentDashboard]
            if dashBoardList.count > 0
            {
                completion(dashBoardList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return dashBoardList
    }
    
    //   Mark: MonthlyEvents
    func insertAndUpdateMonthlyEvents(newID:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<MonthlyEvents> = MonthlyEvents.fetchRequest()
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"newID!= nil")
        do {
            fetch.predicate = NSPredicate(format:"newID == %@",newID)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let monthEntity = NSEntityDescription.entity(forEntityName:"MonthlyEvents", in: managedContext)!
                        let monthevents = MonthlyEvents(entity: monthEntity, insertInto: managedContext)
                        monthevents.endDate = obj["new_subeventenddate"] as? String
                        monthevents.eventDetail = obj["new_description"] as? String
                        monthevents.startDate = obj["new_subeventstartdate"] as? String
                        monthevents.eventStatus = (obj["new_eventstatus"] as? Int16)!
                        monthevents.eventName = obj["new_name"] as? String
                        monthevents.eventTypeByNewId = obj["eventtype_x002e_new_id"] as? String
                        monthevents.eventTypeID = obj["new_eventTypeId"] as? String
                        monthevents.newID = obj["new_id"] as? String
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    //  Mark : MonthlyEvents
    func fetchMonthlyEventsDataRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [MonthlyEvents] {
        var eventList:[MonthlyEvents] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"MonthlyEvents")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "newID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            eventList = try managedContext.fetch(fetchRequest) as! [MonthlyEvents]
            if eventList.count > 0
            {
                completion(eventList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return eventList
    }
    //   Mark: GalleryFolder
    func insertAndUpdateGalleryFolder(albumID:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<GalleryFolder> = GalleryFolder.fetchRequest()
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"albumID!= nil")
        do {
            fetch.predicate = NSPredicate(format:"albumID == %@",albumID)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let galleyEntity = NSEntityDescription.entity(forEntityName:"GalleryFolder", in: managedContext)!
                        let galleryFolder = GalleryFolder(entity: galleyEntity, insertInto: managedContext)
                        galleryFolder.albumID = obj["new_albumsid"] as? String
                        galleryFolder.entityImage = obj["entityimage"] as? String
                        galleryFolder.name = obj["new_name"] as? String
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    //  Mark : MonthlyEvents
    func fetchGalleryFolderDataRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [GalleryFolder] {
        var galleryList:[GalleryFolder] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"GalleryFolder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "albumID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            galleryList = try managedContext.fetch(fetchRequest) as! [GalleryFolder]
            if galleryList.count > 0
            {
                completion(galleryList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return galleryList
    }
    
    
    //   Mark: GalleryFolder
    func insertAndUpdateGalleryImages(folderID:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<GalleryImages> = GalleryImages.fetchRequest()
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"folderID!= nil")
        do {
            fetch.predicate = NSPredicate(format:"folderID == %@",folderID)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                for obj in jsonObject {
                        let galleyEntity = NSEntityDescription.entity(forEntityName:"GalleryImages", in: managedContext)!
                        let galleryFolder = GalleryImages(entity: galleyEntity, insertInto: managedContext)
                        galleryFolder.annotationID = obj["annotationid"] as? String
                        galleryFolder.documentBody = obj["documentbody"] as? String
                        galleryFolder.fileName = obj["filename"] as? String
                        galleryFolder.folderID = folderID as? String
                        
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    //  Mark : GalleryImages
    func fetchGalleryImagesDataRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [GalleryImages] {
        var galleryImages:[GalleryImages] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"GalleryImages")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "folderID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            galleryImages = try managedContext.fetch(fetchRequest) as! [GalleryImages]
            if galleryImages.count > 0
            {
                completion(galleryImages as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return galleryImages
    }
   
    
    //   Mark: Pinboard
    func insertAndUpdatePinBoard(Startdate:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<PinBoard> = PinBoard.fetchRequest()
         fetch.predicate = NSPredicate(format:"startdate!= nil")
        fetch.returnsObjectsAsFaults = false
        do {
            fetch.predicate = NSPredicate(format:"startdate == %@",Startdate)
            if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let pinboradEntity = NSEntityDescription.entity(forEntityName:"PinBoard", in: managedContext)!
                        let galleryFolder = PinBoard(entity: pinboradEntity, insertInto: managedContext)
                        galleryFolder.endDate = obj["new_enddate"] as? String
                        galleryFolder.startdate = obj["new_startdate"] as? String
                        galleryFolder.message = obj["new_message"] as? String
                        galleryFolder.heading = obj["new_heading"] as? String
                        galleryFolder.pinBoardID = obj["new_pinboardid"] as? String
                        galleryFolder.name = obj["new_name"] as? String
                        
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    //  Mark : Pinboard
    func fetchPinBoardDataRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [PinBoard] {
        var pinboardList:[PinBoard] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"PinBoard")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            pinboardList = try managedContext.fetch(fetchRequest) as! [PinBoard]
            if pinboardList.count > 0
            {
                completion(pinboardList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return pinboardList
    }
    
    // Mark : Notifications
    func insertAndUpdateNotifications(newDate:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<Notifications> = Notifications.fetchRequest()
        fetch.predicate = NSPredicate(format:"newDate!= nil")
        fetch.returnsObjectsAsFaults = false
        do {
            fetch.predicate = NSPredicate(format:"newDate == %@",newDate)
            if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let notificationEntity = NSEntityDescription.entity(forEntityName:"Notifications", in: managedContext)!
                        let notification = Notifications(entity: notificationEntity, insertInto: managedContext)
                        notification.heading = obj["new_heading"] as? String
                        notification.message = obj["new_description"] as? String
                        notification.title = obj["new_title"] as? String
                        notification.newDate = obj["new_date"] as? String
                        notification.createdOn = obj["createdon"] as? String
                        notification.base64 = obj["Base64"] as? String
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    //  Mark : Notifications
    func fetchNotificationsRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [Notifications] {
        var notificationList:[Notifications] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Notifications")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            notificationList = try managedContext.fetch(fetchRequest) as! [Notifications]
            if notificationList.count > 0
            {
                completion(notificationList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return notificationList
    }
    
    // Mark : TeacherList
    func insertAndUpdateTeacherList(subjectName:String,jsonObject:[[String:Any]]) {
        
        var newFaculty = [String:Any]()
        var subjectValues = [String:Any]()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<TeacherList> = TeacherList.fetchRequest()
        fetch.predicate = NSPredicate(format:"subjectName!= nil")
        fetch.returnsObjectsAsFaults = false
        do {
            fetch.predicate = NSPredicate(format:"subjectName == %@",subjectName)
            if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let teacherEntity = NSEntityDescription.entity(forEntityName:"TeacherList", in: managedContext)!
                        let teacherList = TeacherList(entity:teacherEntity, insertInto: managedContext)
                        newFaculty = (obj["new_faculty"] as? [String:Any])!
                        subjectValues = (obj["new_subject"] as? [String:Any])!
                        teacherList.phoneNo = newFaculty["sis_phoneno"] as? String
                        teacherList.profileIcon = newFaculty["entityimage"] as? String
                        teacherList.teacherID = obj["_new_faculty_value"] as? String
                        teacherList.subjectId = subjectValues["_sis_subject_value"] as? String
                        teacherList.subjectName = subjectValues["sis_name"] as? String
                        teacherList.teacherName = newFaculty["sis_name"] as? String
                        teacherList.regirationID = newFaculty["_sis_registrationid_value"] as? String
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    //  Mark : TeacherList
    func fetchTeacherListRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [TeacherList] {
        
        var teacherList:[TeacherList] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"TeacherList")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            teacherList = try managedContext.fetch(fetchRequest) as! [TeacherList]
            if teacherList.count > 0
            {
                completion(teacherList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return teacherList
    }
    
    
    //Mark : StudentAssignment
    
    func insertAndUpdateStudentAssignment(assignmentID:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<StudentAssignment> = StudentAssignment.fetchRequest()
        fetch.predicate = NSPredicate(format:"assignmentID!= nil")
        fetch.returnsObjectsAsFaults = false
        do {
            fetch.predicate = NSPredicate(format:"assignmentID == %@",assignmentID)
            if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let assignmentEntity = NSEntityDescription.entity(forEntityName:"StudentAssignment", in: managedContext)!
                        let assignmentList = StudentAssignment(entity:assignmentEntity, insertInto: managedContext)
                        assignmentList.assignment = obj["new_taskassignment"] as? String
                        assignmentList.assignmentID = obj["_new_taskassignment_value"] as? String
                        assignmentList.dueDate = obj["new_duedate"] as? String
                        assignmentList.gender = obj["sis_gender"] as? String
                        assignmentList.name = obj["new_name"] as? String
                        assignmentList.notesID = obj["notesId"] as? String
                        assignmentList.taskStatus = (obj["new_taskstatus"] as? Int16)!
                        assignmentList.submitDate = obj["new_submitdate"] as? String
                        assignmentList.tat = obj["new_tat"] as? String
                        assignmentList.entityImage = obj["Entityimage"] as? String
                        assignmentList.taskDesription = obj["new_taskdescription"] as? String
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    //  Mark : StudentAssignment
    func fetchStudentAssignmentRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [StudentAssignment] {
        var teacherList:[StudentAssignment] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"StudentAssignment")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            teacherList = try managedContext.fetch(fetchRequest) as! [StudentAssignment]
            if teacherList.count > 0
            {
                completion(teacherList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return teacherList
    }
    
    
    //Mark :StudentPerformance
    
    func insertAndUpdateStudentPerformance(marksID:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<StudentPerformance> = StudentPerformance.fetchRequest()
        fetch.predicate = NSPredicate(format:"marksID!= nil")
        fetch.returnsObjectsAsFaults = false
        do {
            fetch.predicate = NSPredicate(format:"marksID == %@",marksID)
            if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let performanceEntity = NSEntityDescription.entity(forEntityName:"StudentPerformance", in: managedContext)!
                        let performanceList = StudentPerformance(entity:performanceEntity, insertInto: managedContext)
                        performanceList.examtype = obj["examschedule_x002e_sis_name"] as? String
                        performanceList.grading = obj["grading_x002e_sis_name"] as? String
                        performanceList.marksID = obj["sis_classsessionwisemarksid"] as? String
                        performanceList.obtainedmarks = (obj["new_obtainedmarks"] as? Double)!
                        performanceList.resultInPercentage = (obj["sis_resultsinpercentage"] as? Double)!
                        performanceList.totalmarks = (obj["new_totalmarks"] as? Double)!
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    //  Mark : StudentPerformance
    func fetchStudentPerformanceRequest(completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [StudentPerformance] {
        var performnaceList:[StudentPerformance] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"StudentPerformance")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            performnaceList = try managedContext.fetch(fetchRequest) as! [StudentPerformance]
            if performnaceList.count > 0
            {
                completion(performnaceList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return performnaceList
    }
    
    // Mark : StudentStudyProgress
    func insertAndUpdateStudentStudyProgress(marksID:String,examID:String,jsonObject:[[String:Any]]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<StudentStudyProgress> = StudentStudyProgress.fetchRequest()
        fetch.predicate = NSPredicate(format:"examID!= nil")
        fetch.returnsObjectsAsFaults = false
        do {
            fetch.predicate = NSPredicate(format:"examID == %@",examID)
            if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                    return
                }
                else
                {
                    for obj in jsonObject {
                        let progressEntity = NSEntityDescription.entity(forEntityName:"StudentStudyProgress", in: managedContext)!
                        let progressList = StudentStudyProgress(entity:progressEntity, insertInto: managedContext)
                        progressList.name = obj["sis_name"] as? String
                        progressList.newPerformance = (obj["new_performance"] as? Double)!
                        progressList.obtained = (obj["sis_obtainedmarks"] as? Double)!
                        progressList.totalMarks = (obj["sis_totalmarks"] as? Double)!
                        let exam = obj["sis_Examination"] as? [String:Any]
                        progressList.examID = exam!["sis_examinationid"] as? String
                        progressList.marksID = marksID
                       
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
  
    // Mark : StudentStudyProgress
    func fetchStudentStudyProgressRequest(marksID:String,completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [StudentStudyProgress] {
        var progressList:[StudentStudyProgress] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"StudentStudyProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateIsSubject = NSPredicate(format: "marksID == %@",marksID)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsSubject])
        fetchRequest.predicate = andPredicate
        
        do{
            progressList = try managedContext.fetch(fetchRequest) as! [StudentStudyProgress]
            if progressList.count > 0
            {
                completion(progressList as? NSObject, nil)
            }else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("count not fetch\(error),\(error.userInfo)")
        }
        return progressList
    }
    
    
    //Mark: HomeWork List
    func insertAndUpdateHomeWorkList(userID:String ,subject:String , jsonObject:[[String:Any]]) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<HomeWorkList> = HomeWorkList.fetchRequest()
        fetch.predicate =  NSPredicate(format:"regirationID!= nil")
        fetch.returnsObjectsAsFaults = false
        
        do{
            fetch.predicate = NSPredicate(format:"createdOn == %@",subject)
            
            if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil {
                let count = try! managedContext.count(for:fetch)
                if count > 0 {
                   return
                }
                else {
                    for obj in jsonObject{
                        let homeWorkEntity = NSEntityDescription.entity(forEntityName: "HomeWorkList", in: managedContext)!
                        let homeworkList = HomeWorkList(entity:homeWorkEntity, insertInto : managedContext)
                        homeworkList.startDate = obj["new_startdate"] as? String
                        homeworkList.endDate = obj["new_enddate"] as? String
                        homeworkList.createdOn = obj["createdon"] as? String
                        homeworkList.homedescription = obj["sis_homeworkdescription"] as? String
                        homeworkList.notesID = obj["notesId"] as? String
                        homeworkList.sisName = obj["sis_name"] as? String
                        homeworkList.userID = userID as? String
                        homeworkList.subject = obj["new_subject"] as? String
                    }
                    do {
                        try managedContext.save()
                    }catch{
                        print("problem saving")
                    }
                }
            }
        }
        catch {
            print("fetch Failed: \(error)")
        }
    }
  
    func fetchHomeworkList(userID:String , completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [HomeWorkList] {
     
        var hmeworkList:[HomeWorkList] = []
        let managedcontext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"HomeWorkList")
        fetchRequest.returnsObjectsAsFaults = false
        
//        let predicateIsstudentID = NSPredicate(format: "regirationID == %@",userID)
//         let andpredicate = NSCompoundPredicate(type: .and, subpredicates:[ predicateIsstudentID])
//        fetchRequest.predicate = andpredicate
        
        do{
            hmeworkList = try managedcontext.fetch(fetchRequest) as! [HomeWorkList]
            if hmeworkList.count > 0 {
                completion(hmeworkList as? NSObject , nil)
            }else{
                completion(nil , Error.self as? Error)
            }
        }catch let error as NSError {
            print("count not fetch \(error),\(error.userInfo)")
        }
        return hmeworkList
    }
    
  
   //Mark : AttendancePercentage
    
    func insertAndUpdateAttenadancePercentage(present:Int16,absent:Int16,leave :Int16,dateString:String) {
          let managedContext = appDelegate.persistentContainer.viewContext
          let fetch: NSFetchRequest<AttendancePercentage> = AttendancePercentage.fetchRequest()
          fetch.predicate =  NSPredicate(format:"dateString!= nil")
          fetch.returnsObjectsAsFaults = false
          do{
              fetch.predicate = NSPredicate(format:"dateString == %@",dateString)
              if (try managedContext.fetch(fetch) as? [NSManagedObject]) != nil {
                  let count = try! managedContext.count(for:fetch)
                  if count > 0 {
                      return
                  }
                  else {
                      let percentageEntity = NSEntityDescription.entity(forEntityName: "AttendancePercentage", in: managedContext)!
                      let percentageList = AttendancePercentage(entity:percentageEntity, insertInto : managedContext)
                    percentageList.absent = (absent as? Int16)!
                    percentageList.present = (present as? Int16)!
                    percentageList.leave = (leave as? Int16)!
                    percentageList.dateString = dateString
                      do {
                          try managedContext.save()
                      }catch{
                          print("problem saving")
                      }
                  }
              }
          }
          catch {
              print("fetch Failed: \(error)")
          }
      }
    
    
    func fetchAttendancePercentage(completion:@escaping(_ success : NSObject?, _ error:Error?) -> Void) -> [AttendancePercentage] {
          var monthlypercentage:[AttendancePercentage] = []
          let managedContext = appDelegate.persistentContainer.viewContext
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"AttendancePercentage")
          fetchRequest.returnsObjectsAsFaults = false
          do {
              monthlypercentage = try managedContext.fetch(fetchRequest) as! [AttendancePercentage]
              if monthlypercentage.count > 0 {
                  completion(monthlypercentage as? NSObject , nil)
              }else {
                  completion(nil , Error.self as? Error)
              }
          }
          catch let error as NSError {
              print("could not fetch \(error), \(error.userInfo)")
          }
          return monthlypercentage
      }
    // Mark : StudentAttendance
    
    func insertAndUpdateStudentAttendance(month :String,percentage : Int,year :String,registrationID:String){
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch : NSFetchRequest<Percentage> = Percentage.fetchRequest()
        fetch.predicate = NSPredicate(format:"studentID!= nil")
        fetch.returnsObjectsAsFaults = false
        
        do{
            fetch.predicate = NSPredicate(format:"month == %@",month)
            
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                let count = try! managedContext.count(for:fetch)
                if count > 0{
                    return
                }
                else{
                    let percentageEntity = NSEntityDescription.entity(forEntityName: "Percentage", in: managedContext)!
                    let userAttendance = Percentage(entity: percentageEntity, insertInto: managedContext)
                    userAttendance.studentID = registrationID
                    userAttendance.percentage = Double(percentage)
                    userAttendance.month = month
                    userAttendance.year = year
                    
                    try! managedContext.save()
                }
                
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
        
    }
    
    // Mark : fetchAddressDataRequest
    func fetchPercentageDataRequest(regID:String,completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [Percentage]{
        var attendance:[Percentage] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Percentage")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "studentID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        
//       let predicateIsStudent = NSPredicate(format: "studentID == %@",regID)
//       let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsStudent])
//     fetchRequest.predicate = andPredicate
        
        do{
            attendance = try managedContext.fetch(fetchRequest) as! [Percentage]
            if attendance.count > 0 {
                completion(attendance as? NSObject , nil)
            }
            else{
                completion(nil, Error.self as? Error)
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return attendance
    }
    
}

