//
//  ReminderListView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI

struct ReminderListView: View {
    @ObservedObject private var viewModel = ReminderListViewModel()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: ReminderManagedObject.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \ReminderManagedObject.isCompleted, ascending: true),
        NSSortDescriptor(keyPath: \ReminderManagedObject.name, ascending: true),
    ], animation: .default) private var reminders: FetchedResults<ReminderManagedObject>
    @State private var newReminderViewIsPresented = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.reminders, id: \.id) { reminder in
                    ReminderView(reminder: reminder)
                }
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
            self.viewModel.fetchReminders()
        }, content: {
            NewReminderView(viewModel: NewReminderViewModel()).environment(\.managedObjectContext, managedObjectContext)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListView()
    }
}
