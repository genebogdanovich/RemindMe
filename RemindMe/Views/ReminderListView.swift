//
//  ReminderListView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI

struct ReminderListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var newReminderViewIsPresented = false
    
    
    var body: some View {
        NavigationView {
            List {
                Text("RemindMe")
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
        .sheet(isPresented: $newReminderViewIsPresented, content: {
            NewReminderView().environment(\.managedObjectContext, managedObjectContext)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListView()
    }
}
