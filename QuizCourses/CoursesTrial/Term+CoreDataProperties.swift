//
//  Term+CoreDataProperties.swift
//  CoursesTrial
//
//  Created by Barry Chew on 4/8/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Term {

    @NSManaged var definition: String?
    @NSManaged var score: NSNumber?
    @NSManaged var name: String?
    @NSManaged var course: Course?

}
