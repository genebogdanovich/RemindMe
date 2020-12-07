//
//  UIImagePickerControllerWrapper.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 2.12.20.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct UIImagePickerControllerWrapper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    let sourceType: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: UIImagePickerControllerWrapper
        
        init(_ parent: UIImagePickerControllerWrapper) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - UIViewControllerRepresentable
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        // Only allow to select images.
        picker.mediaTypes = [kUTTypeImage as String]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    
}
