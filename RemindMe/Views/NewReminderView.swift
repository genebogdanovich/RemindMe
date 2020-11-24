//
//  NewReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI
import CoreData

struct NewReminderView: View {
    @ObservedObject var viewModel: NewReminderViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var name = "New Reminder"
    @State private var note = ""
    @State private var url = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $name)
                    TextField("Notes", text: $note)
                    TextField("URL", text: $url)
                }
                
                Section {
                    DatePicker(selection: $date, in: Date()..., label: {
                        Text("Time")
                    })
                }
            }
            
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .fontWeight(.regular)
            }), trailing: Button(action: {
                viewModel.addNewReminder(date: date, name: name, note: note, url: URL(string: url))
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .fontWeight(.bold)
            })
            .disabled(name.isEmpty))
        }
    }
}

//struct NewReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewReminderView()
//    }
//}
