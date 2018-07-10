//
//  AvantariRecords+CoreDataProperties.swift
//  AvantariProject
//
//  Created by Mohd Farhan Khan on 5/14/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//
//

import Foundation
import CoreData


extension AvantariRecords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvantariRecords> {
        return NSFetchRequest<AvantariRecords>(entityName: "AvantariRecords")
    }

    @NSManaged public var dataNumber: Int32
    @NSManaged public var dataTime: NSDate?
    @NSManaged public var dataColor: NSObject?

}
