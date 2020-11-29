//
//  DetailReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 29.11.20.
//

import SwiftUI

/// A view that creates and updates reminders.
struct DetailReminderView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var note = ""
    @State private var date = Date()
    @State private var urlInputString = ""
    
    // FIXME: Rename this.
    var viewModel: DetailReminderViewModel
    let reminderToUpdate: Reminder?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $name)
                        .onTapGesture {
                            if reminderToUpdate == nil {
                                name = ""
                            }
                        }
                    TextField("Notes", text: $note)
                    TextField("URL", text: $urlInputString)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                
                Section {
                    DatePicker(selection: $date, in: Date()..., label: {
                        Text("Time")
                    })
                }
            }
            .navigationTitle(reminderToUpdate == nil ? "New Reminder" : "Edit Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .fontWeight(.regular)
            }), trailing: Button(action: {
                if let reminderToUpdate = reminderToUpdate {
                    viewModel.addNew(
                        Reminder(
                            id: reminderToUpdate.id,
                            isCompleted: reminderToUpdate.isCompleted,
                            name: name,
                            date: date,
                            note: note,
                            url: urlInputString.makeUrl())
                    )
                } else {
                    viewModel.addNew(
                        Reminder(
                            id: UUID(),
                            isCompleted: false,
                            name: name,
                            date: date,
                            note: note,
                            url: urlInputString.makeUrl())
                    )
                }
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .fontWeight(.bold)
            })
            // FIXME: Test this.
            .disabled(name.isEmpty)
            )
        }
        // FIXME: Refactor this.
        .onAppear() {
            if let reminderToUpdate = reminderToUpdate {
                name = reminderToUpdate.name
                note = reminderToUpdate.note ?? ""
                urlInputString = reminderToUpdate.url?.host ?? ""
                date = reminderToUpdate.date
            } else {
                name = "New Reminder"
            }
        }
    }
}

struct DetailReminderView_Previews: PreviewProvider {
    static var previews: some View {
        DetailReminderView(viewModel: DetailReminderViewModel(), reminderToUpdate: nil)
    }
}
