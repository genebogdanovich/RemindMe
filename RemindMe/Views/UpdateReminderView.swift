//
//  UpdateReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 27.11.20.
//

import SwiftUI

struct UpdateReminderView: View {
    @Environment(\.presentationMode) private var presentationMode
    var viewModel: NewReminderViewModel
    let reminderToUpdate: Reminder
    @State private var name = ""
    @State private var note: String = ""
    @State private var urlInputString: String = ""
    @State private var date = Date()
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $name)
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
            
            .navigationTitle("Edit Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .fontWeight(.regular)
            }), trailing: Button(action: {
                
                viewModel.addNew(
                    Reminder(
                        id: reminderToUpdate.id,
                        isCompleted: false,
                        name: name,
                        date: date,
                        note: note,
                        url: urlInputString.makeUrl())
                )
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .fontWeight(.bold)
            })
            .disabled(name.isEmpty))
        }
        // FIXME: There must be a better way.
        .onAppear() {
            name = reminderToUpdate.name
            note = reminderToUpdate.note ?? ""
            urlInputString = reminderToUpdate.url?.host ?? ""
            date = reminderToUpdate.date
        }
    }
    
    init(reminderToUpdate: Reminder) {
        self.reminderToUpdate = reminderToUpdate
        viewModel = NewReminderViewModel()
    }
}

struct UpdateReminderView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateReminderView(reminderToUpdate: Reminder(id: UUID(), isCompleted: false, name: "Just do it", date: Date(), note: "Right now", url: URL(string: "apple.com")))
    }
}
