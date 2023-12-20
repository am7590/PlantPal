//
//  CameraController.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 6/3/23.
//

import UIKit
import AVFoundation
import os

protocol CameraControllerDelegate: AnyObject {
    func cameraControllerDidCaptureImage(_ image: UIImage)
}

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Variables
    lazy private var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.tintColor = .systemGreen
        return button
    }()
    
    lazy private var takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        return button
    }()
    
    private let photoOutput = AVCapturePhotoOutput()
    
    weak var delegate: CameraControllerDelegate?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        openCamera()
    }
    
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(takePhotoButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takePhotoButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        takePhotoButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        takePhotoButton.backgroundColor = .systemGreen
        takePhotoButton.layer.cornerRadius = 24

        let outlineView = UIView()
        outlineView.translatesAutoresizingMaskIntoConstraints = false
        outlineView.layer.cornerRadius = 16
        outlineView.layer.borderWidth = 4
        outlineView.layer.borderColor = UIColor.systemGreen.cgColor
        outlineView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(outlineView)
        
        NSLayoutConstraint.activate([
            outlineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 225),
            outlineView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -175),
            outlineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            outlineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])

    }
    
    private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    Logger.plantPal.debug("Opening camera")
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                } else {
                    Logger.plantPal.error("User did not grant permission to use the camera. Dismissing...")
                    self.handleDismiss()
                }
            }
            
        case .denied:
            Logger.plantPal.error("The user has denied previously to access the camera. Dismissing...")
            self.handleDismiss()
            
        case .restricted:
            Logger.plantPal.error("The user can't give camera access due to some restriction. Dismissing...")
            self.handleDismiss()
            
        default:
            Logger.plantPal.error("Cannot access camera. Dismissing...")
            self.handleDismiss()
        }
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                Logger.plantPal.error("AVCaptureSession failed to set input device with error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(cameraLayer)
            
            captureSession.startRunning()
            self.setupUI()
        }
    }
    
    @objc func handleDismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
        handleDismiss()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        Logger.plantPal.debug("Finished proccing photo: \(previewImage.debugDescription)")
        delegate?.cameraControllerDidCaptureImage(previewImage!)
        
        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
        photoPreviewContainer.photoImageView.image = previewImage
        self.view.addSubviews(photoPreviewContainer)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach{ addSubview($0) }
    }
}
