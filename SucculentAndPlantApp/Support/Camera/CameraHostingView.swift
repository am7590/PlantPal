//
//  CameraHostingView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 6/3/23.
//

import SwiftUI
import AVFoundation

struct CameraHostingView: UIViewControllerRepresentable {
    //@Binding var previewImage: UIImage?
    
    func makeUIViewController(context: Context) -> CameraController {
        let cameraController = CameraController()
        //cameraController.delegate = context.coordinator
        return cameraController
    }
    
    func updateUIViewController(_ uiViewController: CameraController, context: Context) {
        // Update any properties of the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraHostingView
        
        init(_ parent: CameraHostingView) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            print("photoOutput")
            
            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else {
                return
            }
            
            print("image: \(image)")
            
           // parent.previewImage = image
            //parent.dismiss()
        }
    }
}
