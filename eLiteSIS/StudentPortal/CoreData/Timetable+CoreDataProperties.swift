//
//  Timetable+CoreDataProperties.swift
//  eLiteSIS
//
//  Created by apar on 24/09/19.
//  Copyright © 2019 apar. All rights reserved.
//
//

import Foundation
import CoreData


extension Timetable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timetable> {
        return NSFetchRequest<Timetable>(entityName: "Timetable")
    }

    @NSManaged public var newClasssessionValue: String?
    @NSManaged public var newClasstaken: String?
    @NSManaged public var newClasstakenValue: String?
    @NSManaged public var newEndtime: String?
    @NSManaged public var newStartdate: String?
    @NSManaged public var notify: Bool
    @NSManaged public var sisName: String?
    @NSManaged public var sisValue: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var month: String?

}
