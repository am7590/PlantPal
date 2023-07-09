//
//  CameraHostingView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 6/3/23.
//

import SwiftUI
import AVFoundation

struct CameraHostingView: UIViewControllerRepresentable {
//    @State var previewImage: UIImage?
    @ObservedObject var viewModel: SuccuelentFormViewModel
    
    func makeUIViewController(context: Context) -> CameraController {
        let cameraController = CameraController()
        cameraController.delegate = context.coordinator
        return cameraController
    }
    
    func updateUIViewController(_ uiViewController: CameraController, context: Context) {
        // Update any properties of the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CameraControllerDelegate {
        let parent: CameraHostingView
        
        init(_ parent: CameraHostingView) {
            self.parent = parent
        }
        
        func cameraControllerDidCaptureImage(_ image: UIImage) {
            print("!!! selected \(image)")
//            parent.previewImage = image
            parent.viewModel.uiImage.append(image)
        }
    }
}
