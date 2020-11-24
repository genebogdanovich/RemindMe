//
//  ReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI
import CoreData

struct ReminderView: View {
    let reminder: ReminderManagedObject
    
    var body: some View {
        VStack {
            Text(reminder.wrappedName)
            // TODO: Red if due.
            reminder.wrappedDate.map(Text.init)
            reminder.note.map(Text.init)
            // URL
            
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        
        let reminder: ReminderManagedObject = {
            let item = ReminderManagedObject(context: managedObjectContext)
            item.id = UUID()
            item.name = "Learn Swift"
            item.date = Date()
            item.note = "Use books and courses."
            item.url = "apple.com"
            item.isCompleted = false
            return item
        }()
        
        return NavigationView {
            ReminderView(reminder: reminder)
        }
    }
}
