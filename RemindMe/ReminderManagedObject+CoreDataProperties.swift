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
    @NSManaged public var url: String?
    
    public var wrappedName: String {
        return name ?? "New Reminder"
    }
    
    public var wrappedDate: String? {
        // TODO: Should format date with words today and tomorrow.
        if let date = date {
            let formatter: DateFormatter = {
                let item = DateFormatter()
                item.dateFormat = Constants.Formatting.fullDateFormat
                return item
            }()
            
            return formatter.string(from: date)
        } else {
            return nil
        }
    }
}

extension ReminderManagedObject : Identifiable {

}
