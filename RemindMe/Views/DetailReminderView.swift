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
    
    // FIXME: How about moving this to ViewModel?
    @State private var showingActionSheet = false
    @State private var name = ""
    @State private var note = ""
    @State private var date = Date()
    @State private var urlInputString = ""
    @State private var inputImage: UIImage?
    @State private var isFlagged: Bool = false
    
    
    @ObservedObject private var sheetNavigator = DetailReminderViewSheetNavigator()
    
    
    
    @ObservedObject var viewModel: DetailReminderViewModel
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
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                        DatePicker(selection: $date, in: Date()..., label: {
                            Text("Time")
                        })
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "flag.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                        Toggle(isOn: $isFlagged, label: {
                            Text("Flag")
                        })
                    }
                    
                    Picker(selection: $viewModel.priorityType, label: Text("Priority")) {
                        ForEach(0..<DetailReminderViewModel.priorityTypes.count, id: \.self) {
                            Text(DetailReminderViewModel.priorityTypes[$0])
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        showingActionSheet = true
                    }, label: {
                        Text("Add Photo")
                    })
                    
                    if inputImage != nil {
                        HStack() {
                            Button(action: {
                                withAnimation {
                                    inputImage = nil
                                }
                                
                            }, label: {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            })
                            .buttonStyle(PlainButtonStyle())
                            inputImage.map(Image.init)?
                                .modifier(ImageIconViewModifier())
                            Text("Image")
                        }
                    }
                }
            }
            .navigationTitle(reminderToUpdate == nil ? "New Reminder" : "Edit Reminder")
            .navigationBarTitleDisplayMode(.inline)
            
            .actionSheet(isPresented: $showingActionSheet, content: {
                ActionSheet(title: Text("Select Photo"), message: nil, buttons: [
                    .default(Text("Photo Library")) {
                        sheetNavigator.sheetDestination = .photoLibrary(image: $inputImage)
                        sheetNavigator.showingSheet = true
                    },
                    .default(Text("Take Photo")) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            sheetNavigator.sheetDestination = .camera(image: $inputImage)
                            sheetNavigator.showingSheet = true
                        }
                    },
                    .cancel()
                ])
            })
            
            .sheet(isPresented: $sheetNavigator.showingSheet, content: {
                sheetNavigator.sheetView()
            })
            
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .fontWeight(.regular)
            }), trailing: Button(action: {
                
                print(viewModel.priorityType)
                
                if let reminderToUpdate = reminderToUpdate {
                    viewModel.add(
                        Reminder(
                            id: reminderToUpdate.id,
                            isCompleted: reminderToUpdate.isCompleted,
                            name: name,
                            date: date,
                            note: note,
                            url: urlInputString.makeURL(),
                            image: inputImage,
                            isFlagged: isFlagged,
                            priority: Int16(viewModel.priorityType)
                            )
                    )
                } else {
                    viewModel.add(
                        Reminder(
                            id: UUID(),
                            isCompleted: false,
                            name: name,
                            date: date,
                            note: note,
                            url: urlInputString.makeURL(),
                            image: inputImage,
                            isFlagged: isFlagged,
                            priority: Int16(viewModel.priorityType)
                            )
                    )
                }
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .fontWeight(.bold)
            })
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
                inputImage = reminderToUpdate.image
                isFlagged = reminderToUpdate.isFlagged
                viewModel.priorityType = Int(reminderToUpdate.priority)
            } else {
                name = "New Reminder"
            }
        }
    }
    
    init(viewModel: DetailReminderViewModel = DetailReminderViewModel(), reminderToUpdate: Reminder?) {
        self.viewModel = viewModel
        self.reminderToUpdate = reminderToUpdate
    }

}

// MARK: - DetailReminderViewSheetNavigator

class DetailReminderViewSheetNavigator: SheetNavigator {
    @Published var showingSheet = false
    var sheetDestination: SheetDestination = .none
    
    enum SheetDestination {
        case none
        case camera(image: Binding<UIImage?>)
        case photoLibrary(image: Binding<UIImage?>)
    }
    
    func sheetView() -> AnyView {
        switch sheetDestination {
        case .none:
            return Text("None").eraseToAnyView()
        case .camera(let image):
            
            return UIImagePickerControllerWrapper(image: image, sourceType: .camera).eraseToAnyView()
        case .photoLibrary(let image):
            
            return UIImagePickerControllerWrapper(image: image, sourceType: .photoLibrary).eraseToAnyView()
        }
    }
}

// MARK: Previews

struct DetailReminderView_Previews: PreviewProvider {
    
    static var previews: some View {
        return DetailReminderView(reminderToUpdate: Reminder(id: UUID(), isCompleted: false, name: "Do something", date: Date(), note: "Some kind of note", url: URL(string: "https://www.apple.com")!, image: UIImage(), isFlagged: true, priority: 0))
    }
}
