//
//  FileManager+JSON.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import UIKit

extension FileManager {

    func saveJSON(_ json: String, fileName: String) {
        let url = URL.documentsDirectory.appending(path: fileName)
        do {
            try json.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            print("Could not save json")
        }
    }
    
    func decodeJSON(from url: URL) -> CodableImage? {
        do {
            let data = try Data(contentsOf: url)
            do {
                return try JSONDecoder().decode(CodableImage.self, from: data)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } catch {
            print(error.localizedDescription)
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
            print(error.localizedDescription)
        }
    }
}


