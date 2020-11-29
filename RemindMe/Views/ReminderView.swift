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
    @State private var updateReminderViewIsPresented = false
    @State private var colorOfDateLabel = Color.gray
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .eraseToAnyPublisher()
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: reminderViewModel.isCompleted ? "checkmark.square.fill" : "square")
                .font(.headline)
                .foregroundColor(reminderViewModel.isCompleted ? .blue : .secondary)
                .onTapGesture {
                    reminderListViewModel.toggleIsCompleted(for: reminderViewModel.reminder)
                }
            
            VStack(alignment: .leading) {
                
                Button(action: {
                    updateReminderViewIsPresented.toggle()
                }, label: {
                    Text(reminderViewModel.name)
                        .font(.body)
                })
                .buttonStyle(PlainButtonStyle())
                
                Text(reminderViewModel.dateString)
                    
                    .font(.callout)
                    .foregroundColor(colorOfDateLabel)
                    .onAppear(perform: updateColorOfDateLabel)
                    .onReceive(timer, perform: { _ in updateColorOfDateLabel() })
                
                
                reminderViewModel.note.map(Text.init)?
                    .font(.callout)
                    .foregroundColor(.gray)
                
                
                if reminderViewModel.urlString != nil {
                    Button(action: {
                        reminderViewModel.openURL()
                    }, label: {
                        URLView(url: reminderViewModel.urlString!.lowercased())
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
        }
        .sheet(isPresented: $updateReminderViewIsPresented, onDismiss: {
            reminderListViewModel.fetchReminders()
        }, content: {
            DetailReminderView(viewModel: DetailReminderViewModel(), reminderToUpdate: reminderViewModel.reminder)
        })
        
    }
    
    private func updateColorOfDateLabel() {
        if Date() > reminderViewModel.date {
            colorOfDateLabel = .red
        } else {
            colorOfDateLabel = .gray
        }
    }
}


struct URLView: View {
    let url: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "safari")
            Text(url)
        }
        .padding(5)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(8)
        .font(.callout)
    }
}


struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(
            reminderViewModel: ReminderViewModel(
                reminder: Reminder(
                    id: UUID(),
                    isCompleted: false,
                    name: "Go for a walk",
                    date: Date(),
                    note: "It helps with problem solving.",
                    url: URL(string: "apple.com"))
            ),
            reminderListViewModel: ReminderListViewModel())
    }
}
