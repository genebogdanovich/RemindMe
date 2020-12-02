//
//  ReminderManagedObject+CoreDataProperties.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//
//

import Foundation
import CoreData

extension ReminderManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderManagedObject> {
        return NSFetchRequest<ReminderManagedObject>(entityName: "ReminderManagedObject")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var note: String?
    @NSManaged public var url: URL?
    @NSManaged public var imageData: Data?
}

extension ReminderManagedObject: Identifiable {}
