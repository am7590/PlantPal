//
//  IdentificationView+FetchData.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

import SwiftUI
import os

extension IdentificationView {
    func fetchData(forPlant plant: String, images: [UIImage]) {
        let base64Images = images.compactMap { image -> String? in
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                Logger.networking.error("Failed to convert image to data")
                return nil
            }
            return imageData.base64EncodedString()
        }
        
        let apiUrl = URL(string: "https://plant.id/api/v3/identification")!
        let requestBody: [String: Any] = [
            "images": base64Images,
            "latitude": 43.1318877,
            "longitude": -77.6374956,
            "similar_images": true
        ]

        PlantAPINetworkService.shared.fetchData(url: apiUrl, cacheKey: plant+":id", requestBody: requestBody) { (result: Result<IdentificationResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.identificationData = response
                    self.loadState = .loaded
                    self.cacheSimilarImages(response)
                    
                    
                case .failure(let error):
                    Logger.networking.error("Error fetching data from plant id API: \(error)")
                    self.loadState = .failed
                }
            }
        }
    }

    private func cacheSimilarImages(_ response: IdentificationResponse) {
        response.result?.classification?.suggestions?.forEach { suggestion in
            suggestion.similarImages?.forEach { similarImage in
                fetchAndCacheImage(from: similarImage.url, imageKey: suggestion.name)
            }
        }
    }

    private func fetchAndCacheImage(from urlString: String, imageKey: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                Logger.networking.error("Error fetching and caching image url: \(urlString), \(imageKey) : \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                ImageCacheManager.shared.setImage(image, forKey: imageKey)
            }
        }.resume()
    }
}
