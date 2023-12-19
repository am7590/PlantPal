//
//  CameraHostingView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 6/3/23.
//

import SwiftUI
import AVFoundation
import os

// SwiftUI wrapper around CameraController
struct CameraHostingView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: SuccuelentFormViewModel
    public var appendedNewImage: (() -> Void)?
    
    func makeUIViewController(context: Context) -> CameraController {
        let cameraController = CameraController()
        cameraController.delegate = context.coordinator
        return cameraController
    }
    
    func updateUIViewController(_ uiViewController: CameraController, context: Context) {

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
            Logger.plantPal.debug("\(#function) selected image \(image)")
            parent.viewModel.uiImage.append(image)
            self.parent.appendedNewImage?()
        }
    }
}
