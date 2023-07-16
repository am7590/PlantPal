//
//  IdentificationView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

struct IdentificationView: View {
    let image: UIImage
    @State var loadState: LoadState = .loading
    @State var identificationData: IdentificationResponse?
    
    var body: some View {
        NavigationView {
            VStack {
                switch loadState {
                case .loading:
                    ProgressView("Identifying Plant...")
                        .onAppear {
                            fetchData(image: image)
                        }
                case .loaded:
                    if let identificationData = identificationData {
                        List {
                            Section {
                                if let suggestions = identificationData.result?.classification?.suggestions {
                                    ForEach(suggestions, id: \.id) { suggestion in
                                        VStack(alignment: .leading) {
                                            Text("Plant Name: \(suggestion.name)")
                                                .font(.headline)
                                            Text("Probability: \(suggestion.probability)")
                                                .font(.subheadline)
                                            
                                            if let similarImages = suggestion.similarImages {
                                                Text("Similar Images:")
                                                    .font(.headline)
                                                ScrollView(.horizontal) {
                                                    HStack(spacing: 10) {
                                                        ForEach(similarImages, id: \.id) { image in
                                                            RemoteImage(urlString: image.url)
                                                                .frame(width: 150, height: 150)
                                                                .cornerRadius(16)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Text("Plant Not Identified")
                                        .font(.headline)
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    } else {
                        Text("Failed to identify plant")
                    }
                case .failed:
                    Text("Failed to load. Please try again.")
                }
            }
            .navigationTitle("Plant Identification")
        }
    }
}

struct IdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        IdentificationView(image: UIImage(systemName: "leaf")!)
    }
}

extension IdentificationView {
    func fetchData(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            self.loadState = .failed
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let apiUrl = URL(string: "https://plant.id/api/v3/identification")!
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
                let response = try decoder.decode(IdentificationResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // Access the identification results
                    self.identificationData = response
                    
                    // Print the identification results
                    if let suggestions = response.result?.classification?.suggestions {
                        for suggestion in suggestions {
                            print("Plant Name:", suggestion.name)
                            if let similarImages = suggestion.similarImages {
                                for similarImage in similarImages {
                                    print("Similar Image URL:", similarImage.url)
                                }
                            }
                        }
                    } else {
                        print("Plant Not Identified")
                    }
                    
                    self.loadState = .loaded
                }
                
            } catch {
                print("Error decoding JSON:", error)
                self.loadState = .failed
            }
        }.resume()
    }
}
