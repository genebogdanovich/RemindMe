//
//  ReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI
import CoreData

struct ReminderView: View {
    let reminderViewModel: ReminderViewModel
    let reminderListViewModel: ReminderListViewModel
    
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: reminderViewModel.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.headline)
                .onTapGesture {
                    reminderListViewModel.toggleIsCompleted(for: reminderViewModel.reminder)
                }
            
            VStack(alignment: .leading) {
                Text(reminderViewModel.name)
                    .font(.body)
                Text(reminderViewModel.dateString)
                    .font(.callout)
                    // FIXME: There has to be a better way with Combine.
                    .foregroundColor(reminderViewModel.date < Date() ? .red : .gray)
                reminderViewModel.note.map(Text.init)?
                    .font(.callout)
                    .foregroundColor(.gray)
                
                
                if reminderViewModel.urlString != nil {
                    Button(action: {
                        reminderViewModel.openURL()
                    }, label: {
                        HStack(spacing: 4) {
                            Image(systemName: "safari")
                            Text(reminderViewModel.urlString!)
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
}

//struct ReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReminderView(reminderViewModel: ReminderViewModel(
//                        reminder: Reminder(
//                            name: "Grab a coffee",
//                            date: Date(),
//                            note: "It wakes you up in the morning.",
//                            url: URL(string: "starbucks.com"))))
//    }
//}
