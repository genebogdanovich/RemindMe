//
//  NewReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI

struct NewReminderView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var title = "New Reminder"
    @State private var note = ""
    @State private var url = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
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
                // TODO: Save to CoreData
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .fontWeight(.bold)
            })
            .disabled(title.isEmpty))
        }
    }
}

struct NewReminderView_Previews: PreviewProvider {
    static var previews: some View {
        NewReminderView()
    }
}
