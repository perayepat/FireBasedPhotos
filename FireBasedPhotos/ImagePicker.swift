
import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
    /// Create a object that can recieve UIImagePickerController picker controller events
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator{
        /// Accessed when `context.coordinator` is called
        return Coordinator(parent: self)
    }
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
///  `UINavigationControllerDelegate` - when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack
    
    var parent: ImagePicker
    
    init(parent: ImagePicker) {
        self.parent = parent
    }

    //On user selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        DispatchQueue.main.async {
            self.parent.selectedImage = selectedImage
        }
        
        parent.isPickerShowing = false
        
    }

}
