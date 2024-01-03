//
//  HealthReportView+FetchData.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI
import os

extension HealthReportView {
    func fetchData(for plantName: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            Logger.networking.debug("Failed to compress jpeg")
            self.loadState = .failed
            return
        }
        
        let base64Image = imageData.base64EncodedString()

        let requestBody: [String: Any] = [
            "images": [base64Image],
            "latitude": 43.1318877,
            "longitude": -77.6374956,
            "similar_images": true
        ]

        let apiUrl = URL(string: "https://plant.id/api/v3/health_assessment")!
        PlantAPINetworkService.shared.fetchData(url: apiUrl, cacheKey: plantName+":health", requestBody: requestBody) { (result: Result<HealthAssessmentResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                   self.healthData = response
                   self.loadState = .loaded

                   // Prepare historical probabilities data
                   let historicalProbabilities: [[String: Any]] = response.result.disease.suggestions.map { disease in
                       return [
                           "id": disease.id,
                           "name": disease.name,
                           "probability": disease.probability,
                           // Add other relevant fields here
                       ]
                   }

                   // Convert health report to JSON string and save it using SaveHealthCheckData
                   if let healthReportJson = try? JSONEncoder().encode(response),
                      let healthReportJsonString = String(data: healthReportJson, encoding: .utf8) {
                       self.grpcViewModel.saveHealthCheckData(for: viewModel.id!, currentProbability: response.result.isHealthy.probability, historicalProbabilities: historicalProbabilities)
                   } else {
                       Logger.networking.debug("Failed to encode health report to JSON")
                   }
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
