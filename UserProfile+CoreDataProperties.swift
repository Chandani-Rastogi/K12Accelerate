//
//  UserProfile+CoreDataProperties.swift
//  eLiteSIS
//
//  Created by apar on 26/12/19.
//  Copyright © 2019 apar. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var admissionDate: String?
    @NSManaged public var categoryTxt: String?
    @NSManaged public var classNme: String?
    @NSManaged public var dob: String?
    @NSManaged public var email: String?
    @NSManaged public var entityImage: String?
    @NSManaged public var fatherName: String?
    @NSManaged public var gender: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var motherName: String?
    @NSManaged public var name: String?
    @NSManaged public var programName: String?
    @NSManaged public var regID: String?
    @NSManaged public var registrationNum: String?
    @NSManaged public var sectionName: String?
    @NSManaged public var sectionValue: String?
    @NSManaged public var sessionName: String?
    @NSManaged public var sessionValue: String?
    @NSManaged public var studentID: String?
    @NSManaged public var studentValue: String?
    @NSManaged public var classValue: String?

}
