//
//  ReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI
import CoreData

struct ReminderView: View {
    let reminder: ReminderViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(reminder.name)
                .font(.body)
            Text(reminder.dateString)
                .font(.callout)
                // FIXME: There has to be a better way with Combine.
                .foregroundColor(reminder.date < Date() ? .red : .gray)
            reminder.note.map(Text.init)?
                .font(.callout)
                .foregroundColor(.gray)
            
            
            if reminder.urlString != nil {
                Button(action: {
                    reminder.openURL()
                }, label: {
                    HStack(spacing: 4) {
                        Image(systemName: "safari")
                        Text(reminder.urlString!)
                    }
                    .padding(5)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(8)
                    .font(.callout)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(reminder: ReminderViewModel(
                        reminder: Reminder(
                            name: "Grab a coffee",
                            date: Date(),
                            note: "It wakes you up in the morning.",
                            url: URL(string: "starbucks.com"))))
    }
}
