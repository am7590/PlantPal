//
//  HealthDataViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/18/24.
//

import UIKit
import os
import PlantPalSharedUI
import PlantPalCore

class HealthDataViewModel: ObservableObject {
    @Published var healthData: HealthAssessmentResponse?
    @Published var similarImages = [String: [UIImage]]()
    @Published var loadState: ReportLoadState = .loading

    private var healthDataService: HealthDataServiceProtocol

    init(service: HealthDataServiceProtocol) {
        self.healthDataService = service
    }
    
    func fetchData(for plantName: String, id: String?, image: UIImage) {
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

        healthDataService.fetchHealthData(requestBody: requestBody) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.processSuccessfulFetch(response: response, plantName: plantName, plantId: id)
                case .failure(let error):
                    Logger.networking.error("Error fetching data: \(error)")
                    self?.loadState = .failed
                }
            }
        }
    }

    private func processSuccessfulFetch(response: HealthAssessmentResponse, plantName: String, plantId: String?) {
        self.healthData = response
        self.loadState = .loaded
        self.cacheSimilarImages(from: response)
        
        if let id = plantId {
            GRPCViewModel().saveHealthCheckData(for: id, plantName: plantName, currentProbability: response.result.isHealthy.probability, historicalProbabilities: [])
        }
    }

    private func cacheSimilarImages(from response: HealthAssessmentResponse) {
        response.result.disease.suggestions.forEach { suggestion in
            suggestion.similarImages.forEach { imageInfo in
                setImageFromStringURL(stringUrl: imageInfo.url, imageKey: suggestion.id)
            }
        }
    }

    private func setImageFromStringURL(stringUrl: String, imageKey: String) {
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                Logger.networking.error("Error fetching image: \(error)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.similarImages[imageKey, default: []].append(image)
                }
            }
        }.resume()
    }
}
