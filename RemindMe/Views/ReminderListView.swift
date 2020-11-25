//
//  ReminderListView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI

struct ReminderListView: View {
    @ObservedObject private var viewModel = ReminderListViewModel()
    

    @State private var newReminderViewIsPresented = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.reminders, id: \.id) { reminder in
                    ReminderView(reminderViewModel: reminder, reminderListViewModel: viewModel)
                }
                .onDelete(perform: { indices in
                    viewModel.deleteReminders(at: indices)
                    viewModel.fetchReminders()
                })
            }
            
            .navigationTitle("RemindMe")
            .navigationBarItems(leading: Button(action: {
                    newReminderViewIsPresented.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Reminder")
                    }
                }), trailing: Button(action: {}, label: {
                    Text("Edit")
                        .fontWeight(.regular)
                })
            )
        }
        .sheet(isPresented: $newReminderViewIsPresented, onDismiss: {
            viewModel.fetchReminders()
        }, content: {
            NewReminderView(viewModel: NewReminderViewModel())
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListView()
    }
}
