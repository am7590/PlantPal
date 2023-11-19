//
//  HealthReportView+FetchData.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

// MARK: This will be refactored out when I implement GRPC

import SwiftUI

extension HealthReportView {
    func fetchData(for plantName: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            self.loadState = .failed
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let apiUrl = URL(string: "https://plant.id/api/v3/health_assessment")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("7UXCHJb3p6QJrgOWgEtPlxqgydX94vfZbFZdQHTFWlH6PqnDKZ", forHTTPHeaderField: "Api-Key")
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
                
                // Cache health score
                if let healthScore = self.healthData?.result.isHealthy.probability {
                    UserDefaults.standard.hasBeenHealthScored(for: "\(plantName)+HealthData", with: healthScore)
                }
                
                // Print the health assessment results
                print("Is Healthy:", response.result.isHealthy.binary)
                
                for suggestion in response.result.disease.suggestions {
                    print("Disease Name:", suggestion.name)
                    similarImages[suggestion.name] = []
                    print("Probability:", suggestion.probability)
                    print("Similar Images:")
                        for image in suggestion.similarImages {
                            print("Similar Image URL:", image.url)
                            setImageFromStringrURL(stringUrl: image.url, imageKey: suggestion.name)
                        }
                    
                }
                
                self.loadState = .loaded
                
            } catch {
                print("Error decoding JSON:", error)
                self.loadState = .failed
            }
        }.resume()
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
