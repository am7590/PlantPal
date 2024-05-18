//
//  FIleManager+Image.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import UIKit
import os

@available(iOS 16.0, *)
extension FileManager {
    func retrieveImage(with id: String) -> UIImage? {
        let url = URL.documentsDirectory.appendingPathComponent("\(id).jpg")
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            Logger.plantPal.error("Could not retrieve image from url: \(url) with error: \(error)")
            return nil
        }
    }
    
    func saveImage(with id: String, image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.6) {
            do {
                let url = URL.documentsDirectory.appendingPathComponent("\(id).jpg")
                try data.write(to: url)
            } catch {
                Logger.plantPal.error("\(#function) \(error.localizedDescription)")
            }
        } else {
            Logger.plantPal.error("Could not save image: \(id)")
        }
    }
    
    func deleteImage(with id: String) {
        let url = URL.documentsDirectory.appendingPathComponent("\(id).jpg")
        if fileExists(atPath: url.path) {
            do {
                try removeItem(at: url)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            Logger.plantPal.error("\(#function) Could not delete image: \(id)")
        }
    }
}
