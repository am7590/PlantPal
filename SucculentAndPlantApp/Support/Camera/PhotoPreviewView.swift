//
//  PhotoPreviewView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 6/3/23.
//

import UIKit
import Photos

class PhotoPreviewView: UIView {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(photoImageView)
        addSubview(cancelButton)
        addSubview(savePhotoButton)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        savePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        savePhotoButton.topAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        savePhotoButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -5).isActive = true
        savePhotoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        savePhotoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func handleCancel() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    @objc private func handleSavePhoto() {
        
        guard let previewImage = self.photoImageView.image else { return }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                        print("photo has saved in library...")
                        self.handleCancel()
                    }
                } catch let error {
                    print("failed to save photo in library: ", error)
                }
            } else {
                print("Something went wrong with permission...")
            }
        }
    }
}
