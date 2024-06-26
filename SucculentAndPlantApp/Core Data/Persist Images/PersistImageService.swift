//
//  PersistImageService.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import Foundation
import ZIPFoundation
import UIKit
import os

// Manages persistance of CoreData objects
// Handles restoring and the zipping of image files
class PersistImageService: ObservableObject {
    @Published var codeableImage: CodableImage?
    static let ext = "myimg"
    
    func saveMyImage(_ codableImage: CodableImage, uiImage: UIImage) {
        let filename = "\(codableImage.id).json"
        do {
            let data = try JSONEncoder().encode(codableImage)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveJSON(jsonString, fileName: filename)
            FileManager().saveImage(with: codableImage.id, image: uiImage)
            zipFiles(id: codableImage.id)
        } catch {
            Logger.plantPal.error("\(#function) Could not encode data: \(error)")
        }
    }
    
    func restore(url: URL) {
        let fileName = url.lastPathComponent
        let jsonName = fileName.replacingOccurrences(of: PersistImageService.ext, with: "json")
        let zipName = fileName.replacingOccurrences(of: PersistImageService.ext, with: "zip")
        let imgName = fileName.replacingOccurrences(of: PersistImageService.ext, with: "jpg")
        let imgURL = URL.documentsDirectory.appending(path: imgName)
        let zipURL = URL.documentsDirectory.appending(path: zipName)
        let unzippedJSONURL = URL.documentsDirectory.appending(path: jsonName)
        if url.pathExtension == Self.ext {
            try? FileManager().moveItem(at: url, to: zipURL)
            try? FileManager().removeItem(at: imgURL)
            do {
                try FileManager().unzipItem(at: zipURL, to: URL.documentsDirectory)
            } catch {
                Logger.plantPal.error("\(#function) \(error.localizedDescription)")
            }
            if let codeableImage = FileManager().decodeJSON(from: URL.documentsDirectory.appending(path: jsonName)) {
                self.codeableImage = codeableImage
            }
        }
        try? FileManager().removeItem(at: zipURL)
        try? FileManager().removeItem(at: unzippedJSONURL)
    }
    
    func zipFiles(id: String) {
        let archiveURL = URL.documentsDirectory.appending(path: "\(id).\(Self.ext)")
        guard let archive = Archive(url: archiveURL, accessMode: .create) else {
            return
        }
        let imageURL = URL.documentsDirectory.appending(path: "\(id).jpg")
        let jsonURL = URL.documentsDirectory.appending(path: "\(id).json")
        do {
            try archive.addEntry(with: imageURL.lastPathComponent, relativeTo: URL.documentsDirectory)
            try archive.addEntry(with: jsonURL.lastPathComponent, relativeTo: URL.documentsDirectory)
            try FileManager().removeItem(at: jsonURL)
            try FileManager().removeItem(at: imageURL)
        } catch {
            Logger.plantPal.error("\(#function) \(error.localizedDescription)")
        }
    }
}
