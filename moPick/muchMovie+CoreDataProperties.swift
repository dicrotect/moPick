//
//  muchMovie+CoreDataProperties.swift
//  
//
//  Created by dicrotect on 2016/02/21.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension muchMovie {

    @NSManaged var flag: NSNumber?
    @NSManaged var movie: String?
    @NSManaged var user: String?

}
