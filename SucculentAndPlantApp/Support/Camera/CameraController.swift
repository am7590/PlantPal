//
//  CameraController.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 6/3/23.
//

import UIKit
import AVFoundation

protocol CameraControllerDelegate: AnyObject {
    func cameraControllerDidCaptureImage(_ image: UIImage)
}

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Variables
    lazy private var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.tintColor = .systemBlue
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
            
            takePhotoButton.backgroundColor = .systemBlue
            takePhotoButton.layer.cornerRadius = 24
    }
    
    
    private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // the user has already authorized to access the camera.
            self.setupCaptureSession()
            
        case .notDetermined: // the user has not yet asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { // if user has granted to access the camera.
                    print("the user has granted to access the camera")
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                } else {
                    print("the user has not granted to access the camera")
                    self.handleDismiss()
                }
            }
            
        case .denied:
            print("the user has denied previously to access the camera.")
            self.handleDismiss()
            
        case .restricted:
            print("the user can't give camera access due to some restriction.")
            self.handleDismiss()
            
        default:
            print("something has wrong due to we can't access the camera.")
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
                print("Failed to set input device with error: \(error)")
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
        print("imageData: \(previewImage)")
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
