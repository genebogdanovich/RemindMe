//
//  ReminderView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import SwiftUI
import CoreData

struct ReminderView: View {
    @ObservedObject var reminderViewModel: ReminderViewModel
    let reminderListViewModel: ReminderListViewModel

    @ObservedObject var sheetNavigator = ReminderViewSheetNavigator()
    
    @State private var colorOfDateLabel = Color.gray
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .eraseToAnyPublisher()
    
    var body: some View {
        HStack(alignment: .top) {
            reminderViewModel.isCompletedIcon
                .font(.headline)
                .foregroundColor(reminderViewModel.isCompleted ? .blue : .secondary)
                .onTapGesture {
                    withAnimation {
                        reminderListViewModel.toggleIsCompleted(for: reminderViewModel.reminder)
                    }
                }
            
            VStack(alignment: .leading) {
                Button(action: {
                    sheetNavigator.sheetDestination = .detailView(reminderToUpdate: reminderViewModel.reminder)
                    sheetNavigator.showingSheet = true
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
                
                Button(action: {
                    sheetNavigator.sheetDestination = .imageView(uiImage: reminderViewModel.uiImage!)
                    sheetNavigator.showingSheet = true
                }, label: {
                    reminderViewModel.image?
                        .modifier(ImageIconViewModifier())
                })
                .buttonStyle(PlainButtonStyle())
                
            }
            
            Spacer()
            
            reminderViewModel.isFlaggedIcon?
                .foregroundColor(.red)
                .font(.title3)
            
            
        }
        .fullScreenCover(isPresented: $sheetNavigator.showingSheet, onDismiss: {
            reminderListViewModel.fetchReminders()
        }, content: {
            
            sheetNavigator.sheetView()
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

// MARK: - ReminderViewSheetNavigator

class ReminderViewSheetNavigator: SheetNavigator {
    
    @Published var showingSheet = false
    var sheetDestination: SheetDestination = .none
    
    enum SheetDestination {
        case none
        case detailView(reminderToUpdate: Reminder)
        case imageView(uiImage: UIImage)
        
    }
    
    func sheetView() -> AnyView {
        switch sheetDestination {
        case .none:
            return Text("None").eraseToAnyView()
        case .detailView(let reminderToUpdate):
            return DetailReminderView(reminderToUpdate: reminderToUpdate).eraseToAnyView()
        case .imageView(let uiImage):
            
            return ReminderImageViewerControllerWrapper(image: uiImage).eraseToAnyView()
        }
    }
    
    @Published var showingReminderDetailView = false
    @Published var showingImageView = false
}

// MARK: - URLView

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

// MARK: - ImageIconViewModifier

struct ImageIconViewModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 32, height: 32)
            .clipped()
            .cornerRadius(8)
    }
}

// MARK: - Previews

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
                    url: URL(string: "apple.com"),
                    image: UIImage(),
                    isFlagged: true,
                    priority: .high
                    )
            ),
            reminderListViewModel: ReminderListViewModel())
    }
}
