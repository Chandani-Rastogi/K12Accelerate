//
//  TeacherCoreDatacontroller.swift
//  eLiteSIS
//
//  Created by apar on 25/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import CoreData

class TeacherCoreDatacontroller: NSObject {
    
    static let shared = TeacherCoreDatacontroller()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Mark : insertAndUpdateClassbyId
    func insertAndUpdateClassSections(sectionID:String,sectionName:String){
        
        let fetch : NSFetchRequest<ClassSections> = ClassSections.fetchRequest()
        fetch.predicate = NSPredicate(format:"sectionID!= nil")
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            fetch.predicate = NSPredicate(format:"sectionID == %@",sectionID)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                if fetchResults.count != 0 {
                    
                    print(fetchResults)
                }
                else{
                    print("********************insert and save *****************")
                    //create ClassSections Object
                    let sectionClass = ClassSections(context : managedContext)
                    sectionClass.sectionId = sectionID
                    sectionClass.sectionName = sectionName
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
            
        }
        catch {
            print("Fetch Failed: \(error)")
        }
        
    }
  
    // Mark : fetchAllClassSections
    
    func fetchAllClassSections(completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [ClassSections]{
        var clas:[ClassSections] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ClassSections")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"sectionID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            clas = try managedContext.fetch(fetchRequest) as! [ClassSections]
            if clas.count > 0{
                completion(clas as[ClassSections] as NSObject , nil)
            }else{
                completion(nil,Error.self as? Error)
            }
           
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return clas
    }
    // Mark : insertOrUpdateAllStudentbySectionID
    func insertOrUpdateAllStudents(studentID:String,sectionID:String,regID:String,regNAme:String,isPresent:String,name:String,ContactID:String,ContactNAme:String,SessionID:String,SessionName:String,entityImage:String,gender:Int,className: String,sectionName: String){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        let fetch : NSFetchRequest<AllStudent> = AllStudent.fetchRequest()
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"studentID!= nil")
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            fetch.predicate = NSPredicate(format:"studentID == %@",studentID)
            // fetch.predicate = NSPredicate(format:"attendancedate == %@",result)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                if fetchResults.count != 0 {
                    var managedObject = fetchResults[0]
                    managedObject.setValue(isPresent, forKey:"isPresent")
                 
                    try managedContext.save()
                }
                else {
                    // create ALlstudent Object
                    let student = AllStudent(context : managedContext)
                    student.studentID = studentID
                    student.sectionID = sectionID
                    student.registrationID = regID
                    student.registrationName = regNAme
                    student.isPresent = isPresent
                    student.name = name
                    student.contactID = ContactID
                    student.contactName = ContactNAme
                    student.currentclasssession = SessionName
                    student.currentclasssessionid = SessionID
                    student.entityimage = entityImage
                    student.gender = Int16(gender)
                    student.attendancedate = result
                    student.classname = className
                    student.sectionname = sectionName
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
 
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    // Mark : fetchAllStudent
    func fetchAllStudent(sectionid:String,completion:@escaping (_ succes: NSObject?, _ error:Error? ) -> Void) -> [AllStudent]{
        var student:[AllStudent] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AllStudent")
        fetchRequest.returnsObjectsAsFaults = false
         fetchRequest.predicate = NSPredicate(format:"sectionID == %@",sectionid)
        do{
            student = try managedContext.fetch(fetchRequest) as! [AllStudent]
            if student.count > 0 {
               
                completion(student as[AllStudent] as NSObject , nil)
            }else{
                completion(nil,Error.self as? Error)
            }
        }catch let error as NSError{
         print("Could not fetch \(error),\(error.userInfo)")
        }
        return student
    }
    
    
    // Mark : insertOrUpdateDailySchedule
    func insertOrUpdateDailySchedule(startDate:String,jsonObject:[[String:Any]]){
        let fetch : NSFetchRequest<Schedule> = Schedule.fetchRequest()
        fetch.predicate = NSPredicate(format:"startDatastring!= nil")
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            fetch.predicate = NSPredicate(format:"startDatastring == %@",startDate)
            if let fetchResults = try managedContext.fetch(fetch) as? [NSManagedObject]
            {
                if fetchResults.count != 0 {
                    print(fetchResults)
                }
                else{
                    print("********************insert and save *****************")
                    //create DailySchedule Object
                    let sectionClass = Schedule(context : managedContext)
                    for data in jsonObject {
                        sectionClass.section = data["Section"] as? String
                        sectionClass.subject = data["subject"] as? String
                        sectionClass.endtime = data["end_time"] as? String
                        sectionClass.startDatastring = data["start_date"] as? String
                        sectionClass.starttime = data["start_time"] as? String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        if let startdate = dateFormatter.date(from:(data["start_date"] as? String)!) {
                            sectionClass.startDate = startdate as NSDate as Date
                        }
                    }
                  
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
            
        }
        catch {
            print("Fetch Failed: \(error)")
        }
        
    }
    // Mark : FacultyUserProfile
    func insertAndUpdateFacultyProfile(registrationID:String,jsonObject:[String:Any]){
        let fetch : NSFetchRequest<FacultyProfile> = FacultyProfile.fetchRequest()
        fetch.predicate = NSPredicate(format:"regID!= nil")
        let managedContext = appDelegate.persistentContainer.viewContext
       
        do{
            fetch.predicate = NSPredicate(format: "regID == %@", registrationID)
            
            if let fetchRequest = try managedContext.fetch(fetch) as? [NSManagedObject]{
                if fetchRequest.count != 0{
                    print(fetchRequest)
                }
                else{
                    let userProfile = FacultyProfile(context: managedContext)
                    userProfile.regID = registrationID as? String
                    userProfile.profileData = jsonObject as NSObject
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
   
    // MArk : fetchDailySchedule
    func fetchDailySchedule(completion:@escaping (_ succes: NSObject?, _ error:Error? ) -> Void) -> [Schedule]{
        var student:[Schedule] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Schedule")
        fetchRequest.returnsObjectsAsFaults = false
        // fetchRequest.predicate = NSPredicate(format:"sectionID == %@",sectionid)
        do{
            student = try managedContext.fetch(fetchRequest) as! [Schedule]
            if student.count > 0 {
                completion(student as[Schedule] as NSObject , nil)
            }else{
                completion(nil,Error.self as? Error)
            }
        }catch let error as NSError{
            print("Could not fetch \(error),\(error.userInfo)")
        }
        return student
    }

    

    // Mark : Fetch User Profile Data
    func fetchFacultyDataRequest(regID:String,completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [FacultyProfile]{
        var student:[FacultyProfile] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FacultyProfile")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "regID", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            student = try managedContext.fetch(fetchRequest) as! [FacultyProfile]
            for data in student as [NSManagedObject] {
                if let result = data.value(forKey:"profileData")
                {
                    completion(result as? NSObject, nil)
                }else{
                    completion(nil, Error.self as? Error)
                }
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return student
    }
    
    // Mark : Faculty Dashboard
    
    func insertAndUpdateFacultyDashBoard(lessonPlanId:String,jsonObject:[[String:Any]]){
        
        let fetch : NSFetchRequest<Facultydashboard> = Facultydashboard.fetchRequest()
        
        fetch.predicate = NSPredicate(format:"lessonPlanId!= nil")
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            fetch.predicate = NSPredicate(format: "lessonPlanId == %@", lessonPlanId)
            if let fetchRequest = try managedContext.fetch(fetch) as? [NSManagedObject]{
                
                if fetchRequest.count != 0{
                    print(fetchRequest)
                }
                else{
                    let dashboard = Facultydashboard(context: managedContext)
                    dashboard.lessonPlanId = lessonPlanId as? String
                    
                    for data in jsonObject {
                        dashboard.studyprogress = (data["Studyprogress"] as? Double)!
                        dashboard.checked = (data["Checked"] as? Double)!
                        dashboard.lessonPlanId = data["LessonPlanId"] as? String
                        dashboard.subjectId = data["SubjectId"] as? String
                        dashboard.subjectName = data["SubjectName"] as? String
                        dashboard.sectionId = data["sectionId"] as? String
                        dashboard.sectionName = data["sectionName"] as? String
                    }
                    
                
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    // Mark : Fetch dashboard Data
    
    func fetchFacultyDashBaord(completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [Facultydashboard]{
        var dashboard:[Facultydashboard] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Facultydashboard")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lessonPlanId", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            dashboard = try managedContext.fetch(fetchRequest) as! [Facultydashboard]
            if dashboard.count > 0 {
                completion(dashboard as[Facultydashboard] as NSObject , nil)
            }else{
                completion(nil,Error.self as? Error)
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return dashboard
        
    }
    // Mark : FacultyLessonPlan
    func insertAndUpdateFacultyLessonPlan(lessonPlanId:String,jsonObject:[[String:Any]]){
        
        let fetch : NSFetchRequest<FacultyLessonPlan> = FacultyLessonPlan.fetchRequest()
        fetch.predicate = NSPredicate(format:"lessonPlanId!= nil")
        fetch.returnsObjectsAsFaults = false
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do{
            fetch.predicate = NSPredicate(format: "lessonPlanId == %@", lessonPlanId)
            if let fetchRequest = try managedContext.fetch(fetch) as? [NSManagedObject]{
                
                if fetchRequest.count != 0{
                    print(fetchRequest)
                }
                else{
                    let lessonPlan = FacultyLessonPlan(context: managedContext)
                    lessonPlan.lessonPlanId = lessonPlanId as? String
                    
                    for data in jsonObject {
                        lessonPlan.studyprogress = (data["Studyprogress"] as? Double)!
                        lessonPlan.lessonPlanId = data["LessonPlanId"] as? String
                        lessonPlan.subjectId = data["SubjectId"] as? String
                        lessonPlan.subjectName = data["SubjectName"] as? String
                        lessonPlan.sectionId = data["sectionId"] as? String
                        lessonPlan.sectionName = data["sectionName"] as? String
                    }
                    
                    
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
   // Mark : fetch FacultyLessonPlan
    func fetchFacultyLessonPlan(completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [ FacultyLessonPlan]{
        var dashboard:[ FacultyLessonPlan] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FacultyLessonPlan")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lessonPlanId", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do{
            dashboard = try managedContext.fetch(fetchRequest) as! [FacultyLessonPlan]
            if dashboard.count > 0 {
                completion(dashboard as[FacultyLessonPlan] as NSObject , nil)
            }else{
                completion(nil,Error.self as? Error)
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return dashboard
        
    }
    // Mark : FacultyLessonPlan
    func insertAndUpdatetaskAssignments(lessonPlanId:String,jsonObject:[[String:Any]]){
        
        let fetch : NSFetchRequest<TaskAssignments> = TaskAssignments.fetchRequest()
 
        fetch.predicate = NSPredicate(format:"assignmentID!= nil")
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            fetch.predicate = NSPredicate(format: "assignmentID == %@", lessonPlanId)
            if let fetchRequest = try managedContext.fetch(fetch) as? [NSManagedObject]{
                
                if fetchRequest.count != 0{
                    print(fetchRequest)
                }
                else{
                    let assignment = TaskAssignments(context: managedContext)
                    assignment.assignmentID = lessonPlanId as? String
                    
                    for data in jsonObject {
                        assignment.gender = (data["Gender"] as? Int16)!
                        assignment.assignationDate = data["AssignationDate"] as? String
                        assignment.assignmentID = data["AssignmentID"] as? String
                        assignment.name = data["Name"] as? String
                        assignment.submitDate = data["SubmitDate"] as? String
                        assignment.entityimage = data["Entityimage"] as? String
                        assignment.taskStatus = (data["TaskStatus"] as? Int16)!
                    }
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    // Mark : fetch FacultyLessonPlan
    func fetchtaskAssignments(completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [ TaskAssignments]{
        var assignments:[ TaskAssignments] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TaskAssignments")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "assignmentID", ascending: true)]
       // fetchRequest.predicate = NSPredicate(format:"assignmentID == %@",subjectID)
        fetchRequest.returnsObjectsAsFaults = false
        do{
            assignments = try managedContext.fetch(fetchRequest) as! [TaskAssignments]
            if assignments.count > 0 {
                completion(assignments as[TaskAssignments] as NSObject , nil)
            }else{
                completion(nil,Error.self as? Error)
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return assignments
        
    }
    
    
    // Mark : FacultyLessonPlan
    func insertAndUpdateFacultyStudyProgress(SubjectId:String,jsonObject:[[String:Any]]){
        
        let fetch : NSFetchRequest<FacultyStudy> = FacultyStudy.fetchRequest()
        fetch.predicate = NSPredicate(format:"subjectId!= nil")
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            fetch.predicate = NSPredicate(format: "subjectId == %@", SubjectId)
            if let fetchRequest = try managedContext.fetch(fetch) as? [NSManagedObject]{
                
                if fetchRequest.count != 0{
                    print(fetchRequest)
                }
                else{
                    let progressList = FacultyStudy(context: managedContext)
                    progressList.subjectId = SubjectId as? String
                    for data in jsonObject {
                        progressList.subjectId = data["SubjectId"] as? String
                        progressList.subjectName = data["SubjectName"] as? String
                        progressList.studyprogress = (data["Studyprogress"] as? Double)!
                        progressList.lessonPlanId = data["LessonPlanId"] as? String
                        progressList.faculty = data["Faculty"] as? String
                        progressList.classSessionName = data["classSessionName"] as? String
                        progressList.sectionId = data["sectionId"] as? String
                        progressList.sectionName = data["sectionName"] as? String
                    }
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
            }
        }
        catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    // Mark : fetch FacultyLessonPlan
    func fetchFacultyStudyProgress(subjectID:String,completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [ FacultyStudy]{
        var facultyProgress:[FacultyStudy] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FacultyStudy")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "subjectId", ascending: true)]
        fetchRequest.predicate = NSPredicate(format:"subjectId == %@",subjectID)
        fetchRequest.returnsObjectsAsFaults = false
        do{
            facultyProgress = try managedContext.fetch(fetchRequest) as! [FacultyStudy]
            if facultyProgress.count > 0 {
                
                completion(facultyProgress as[FacultyStudy] as NSObject , nil)
            }else{
                completion(nil,Error.self as? Error)
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return facultyProgress
        
    }
    
    // Mark : FacultyLessonPlan
    func insertAndUpdateGetFacultyFromRegistrationID(regID:String,facultycontactId:String,facultyID:String) {
           let fetch : NSFetchRequest<ContactID> = ContactID.fetchRequest()
           fetch.predicate = NSPredicate(format:"regID!= nil")
           fetch.returnsObjectsAsFaults = false
           let managedContext = appDelegate.persistentContainer.viewContext
           do {
               fetch.predicate = NSPredicate(format: "regID == %@", regID)
               if let fetchRequest = try managedContext.fetch(fetch) as? [NSManagedObject]{
                    
                   if fetchRequest.count != 0{
                   }
                   else {
                    let contactid = ContactID(context: managedContext)
                    contactid.regID = regID as? String
                    contactid.facultyID = facultyID as? String
                    contactid.facultyContactID = facultycontactId as? String
                    do{
                        try managedContext.save()
                    }catch{
                        print("error")
                    }
                }
               }
           }
           catch {
               print("Fetch Failed: \(error)")
           }
       }
    // Mark : fetch ContactID
       func fetchContactID(regId:String,completion :@escaping (_ success: NSObject?, _ error: Error? ) -> Void ) -> [ContactID]{
           var contactiD:[ContactID] = []
           let managedContext = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ContactID")
           fetchRequest.sortDescriptors = [NSSortDescriptor(key: "regID", ascending: true)]
           fetchRequest.predicate = NSPredicate(format:"regID == %@",regId)
           fetchRequest.returnsObjectsAsFaults = false
           do{
               contactiD = try managedContext.fetch(fetchRequest) as! [ContactID]
               if contactiD.count > 0 {
                   
                   completion(contactiD as[ContactID] as NSObject , nil)
               }else{
                   completion(nil,Error.self as? Error)
               }
           }catch let error as NSError{
               print("Could not fetch \(error), \(error.userInfo)")
           }
           return contactiD
       }
    
    
    //Mark: HomeWork List
       func insertAndUpdateHomeWorkList(facultyID:String ,subject:String , jsonObject:[[String:Any]]) {
           
           let managedContext = appDelegate.persistentContainer.viewContext
           let fetch : NSFetchRequest<FacultyHomeWorkList> = FacultyHomeWorkList.fetchRequest()
           fetch.predicate =  NSPredicate(format:"createdOn!= nil")
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
                           let homeWorkEntity = NSEntityDescription.entity(forEntityName: "FacultyHomeWorkList", in: managedContext)!
                           let homeworkList = FacultyHomeWorkList(entity:homeWorkEntity, insertInto : managedContext)
                           homeworkList.startDate = obj["new_startdate"] as? String
                           homeworkList.endDate = obj["new_enddate"] as? String
                           homeworkList.createdOn = obj["createdon"] as? String
                           homeworkList.homedescription = obj["sis_homeworkdescription"] as? String
                           homeworkList.notesID = obj["notesId"] as? String
                           homeworkList.sisName = obj["sis_name"] as? String
                           homeworkList.studentID = facultyID as? String
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
     
       func fetchHomeworkList(facultyID:String , completion:@escaping(_ sucess : NSObject?, _ error:Error?) -> Void) -> [FacultyHomeWorkList] {
           var hmeworkList:[FacultyHomeWorkList] = []
           let managedcontext = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"FacultyHomeWorkList")
           fetchRequest.returnsObjectsAsFaults = false
           
           do{
               hmeworkList = try managedcontext.fetch(fetchRequest) as! [FacultyHomeWorkList]
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
    
    
}
