//
//  ReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI
import CoreData

struct ReminderView: View {
    let reminder: Reminder
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(reminder.name)
                .font(.body)
            
            Text("Some date here")
                .font(.callout)
                .foregroundColor(reminder.date < Date() ? .red : .secondary)
            reminder.note.map(Text.init)
                .font(.callout)
                .foregroundColor(.secondary)
            // URL
            
        }
    }
}

//struct ReminderView_Previews: PreviewProvider {
//    static let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//    static var previews: some View {
//        
//        let reminder: ReminderManagedObject = {
//            let item = ReminderManagedObject(context: managedObjectContext)
//            item.id = UUID()
//            item.name = "Learn Swift"
//            item.date = Date()
//            item.note = "Use books and courses."
//            item.url = "apple.com"
//            item.isCompleted = false
//            return item
//        }()
//        
//        return NavigationView {
//            ReminderView(reminder: reminder)
//        }
//    }
//}
