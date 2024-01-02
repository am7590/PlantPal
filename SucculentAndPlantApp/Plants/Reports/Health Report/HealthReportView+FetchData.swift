//
//  HealthReportView+FetchData.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

// MARK: This will be refactored out when I implement GRPC

import SwiftUI
import os

// TODO: Cache this on the gRPC server
extension HealthReportView {
    func fetchData(for plantName: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            Logger.networking.debug("Failed to compress jpeg")
            self.loadState = .failed
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        // TODO: Prompt user for their location
        
        let requestBody: [String: Any] = [
            "images": [base64Image],
            "latitude": 43.1318877,  // This is ok for beta testing
            "longitude": -77.6374956,
            "similar_images": true
        ]
        
        let apiUrl = URL(string: "https://plant.id/api/v3/health_assessment")!
        PlantAPINetworkService.shared.fetchData(url: apiUrl, cacheKey: plantName, requestBody: requestBody) { (result: Result<HealthAssessmentResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    // Process response
                    self.healthData = response
                    self.loadState = .loaded
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.loadState = .failed
            }
        }
    }

    
    func setImageFromStringrURL(stringUrl: String, imageKey: String) {
      if let url = URL(string: stringUrl) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          // Error handling...
          guard let imageData = data else { return }

          DispatchQueue.main.async {
              if let image = UIImage(data: imageData) {
                  similarImages[imageKey]?.append(image)
              }
          }
        }.resume()
      }
    }
}
