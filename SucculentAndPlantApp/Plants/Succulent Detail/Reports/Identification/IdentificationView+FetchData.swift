//
//  IdentificationView+FetchData.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

// TODO: Cache this on the gRPC server
extension IdentificationView {
    func fetchData(images: [UIImage]) {
        
        var base64Images = [String]()
        
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//                print("Failed to convert image to data")
                
                self.loadState = .failed
                return
            }
            
            let base64Image = imageData.base64EncodedString()
            base64Images.append(base64Image)
        }
        
        let apiUrl = URL(string: "https://plant.id/api/v3/identification")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("7UXCHJb3p6QJrgOWgEtPlxqgydX94vfZbFZdQHTFWlH6PqnDKZ", forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // TODO: Fetch user location
        let requestBody: [String: Any] = [
            "images": base64Images,
            "latitude": 43.1318877,
            "longitude": -77.6374956,
            "similar_images": true
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
//            print("Failed to serialize JSON:", error)
            self.loadState = .failed
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
//                print("Error:", error)
                self.loadState = .failed
                return
            }
            
            guard let data = data else {
//                print("No data received")
                self.loadState = .failed
                return
            }
                    
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(IdentificationResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // Access the identification results
                    self.identificationData = response
                    
                    // Print the identification results
                    if let suggestions = response.result?.classification?.suggestions {
                        for suggestion in suggestions {
//                            print("Plant Name:", suggestion.name)
                            similarImages[suggestion.name] = []
                            if let similarImages = suggestion.similarImages {
                                for similarImage in similarImages {
//                                    print("Similar Image URL:", similarImage.url)
                                    setImageFromStringrURL(stringUrl: similarImage.url, imageKey: suggestion.name)
                                }
                            }
                        }
                    } else {
//                        print("Plant Not Identified")
                    }
                                        
                    self.loadState = .loaded
                }
                
            } catch {
//                print("Error decoding JSON:", error)
                self.loadState = .failed
            }
        }.resume()
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

