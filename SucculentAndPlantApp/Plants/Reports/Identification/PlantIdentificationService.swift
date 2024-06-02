//
//  PlantIdentificationService.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 6/2/24.
//

import PlantPalCore
import os
import UIKit

protocol PlantIdentificationServiceProtocol {
    func identifyPlant(images: [UIImage], plantName: String, completion: @escaping (Result<IdentificationResponse, Error>) -> Void)
}

struct PlantIdentificationService: PlantIdentificationServiceProtocol {
    func identifyPlant(images: [UIImage], plantName: String, completion: @escaping (Result<IdentificationResponse, Error>) -> Void) {
        let base64Images = images.compactMap { image -> String? in
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                Logger.networking.error("Failed to convert image to data")
                return nil
            }
            return imageData.base64EncodedString()
        }
        
        let apiUrl = URL(string: "https://plant.id/api/v3/identification")!
        
        // TODO: Prompt user for their location
        let requestBody: [String: Any] = [
            "images": base64Images,
            "latitude": 43.1318877,
            "longitude": -77.6374956,
            "similar_images": true
        ]
        
        PlantAPINetworkService.shared.fetchData(url: apiUrl, cacheKey: plantName+":id", userDeviceToken: "", requestBody: requestBody, completion: completion)
    }
}
