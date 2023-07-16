//
//  HealthReportView+FetchData.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

// MARK: This will be refactored out when I implement GRPC

import SwiftUI

extension HealthReportView {
    func fetchData(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            self.loadState = .failed
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let apiUrl = URL(string: "https://plant.id/api/v3/health_assessment")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("S6VUgIM03MvELLMGtMQBEpVuBvtaG0b0UOGoma3iT2oO2OuMYH", forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "images": [base64Image],
            "latitude": 43.1318877,
            "longitude": -77.6374956,
            "similar_images": true
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to serialize JSON:", error)
            self.loadState = .failed
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                self.loadState = .failed
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.loadState = .failed
                return
            }
            
            print("Data: \(String(data: data, encoding: .utf8))")
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(HealthAssessmentResponse.self, from: data)
                
                // Access the health assessment results
                self.healthData = response
                
                // Print the health assessment results
                print("Is Healthy:", response.result.isHealthy.binary)
                
                for suggestion in response.result.disease.suggestions {
                    print("Disease Name:", suggestion.name)
                    print("Probability:", suggestion.probability)
                    print("Similar Images:")
                    for similarImage in suggestion.similarImages {
                        print("Image URL:", similarImage.url)
                    }
                }
                
                self.loadState = .loaded
                
            } catch {
                print("Error decoding JSON:", error)
                self.loadState = .failed
            }
        }.resume()
    }
}
