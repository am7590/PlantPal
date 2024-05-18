//
//  FileManager+JSON.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import UIKit
import os

extension FileManager {

    func saveJSON(_ json: String, fileName: String) {
        let url = URL.documentsDirectory.appending(path: fileName)
        do {
            try json.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            Logger.plantPal.error("Could not save json to url: \(url) with error \(error)")
        }
    }
    
    func decodeJSON(from url: URL) -> CodableImage? {
        do {
            let data = try Data(contentsOf: url)
            do {
                return try JSONDecoder().decode(CodableImage.self, from: data)
            } catch {
                Logger.plantPal.error("\(#function) \(error.localizedDescription)")
                return nil
            }
        } catch {
            Logger.plantPal.error("\(#function) \(error.localizedDescription)")
            return nil
        }
    }
    
    func moveFile(oldURL: URL, newURL: URL) {
        if fileExists(atPath: newURL.path) {
            try? removeItem(at: newURL)
        }
        do {
            try moveItem(at: oldURL, to: newURL)
        } catch {
            Logger.plantPal.error("\(#function) \(error.localizedDescription)")
        }
    }
}


