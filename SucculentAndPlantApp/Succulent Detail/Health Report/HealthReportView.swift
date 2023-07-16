import SwiftUI

enum LoadState {
    case loading, loaded, failed
}

struct HealthReportView: View {
    let image: UIImage
    @State var loadState: LoadState = .loading
    @State var healthData: HealthAssessmentResponse?
    
    var body: some View {
        NavigationView {
            VStack {
                switch loadState {
                case .loading:
                    ProgressView("Loading Health Report...")
                        .onAppear {
                            fetchData(image: image)
                        }
                case .loaded:
                    if let healthData = healthData {
                        List {
                            Section {
                                Text("Is Healthy: ")
                                    .font(.headline)
                                + Text("\(healthData.result.isHealthy.binary ? "Yes" : "No")")
                                    .font(.headline)
                                    .foregroundColor(healthData.result.isHealthy.binary ? .green : .red)
                                
                                ForEach(healthData.result.disease.suggestions, id: \.id) { suggestion in
                                    NavigationLink(destination: DiseaseDetailView(suggestion: suggestion)) {
                                        VStack(alignment: .leading) {
                                            Text(suggestion.name.capitalized)
                                                .font(.headline)
                                            Text("Probability: \(suggestion.probability)")
                                                .font(.subheadline)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    } else {
                        Text("Failed to load health data")
                    }
                case .failed:
                    Text("Failed to load. Please try again.")
                }
            }
            .navigationTitle("Health Report")
        }
    }
}

struct HealthReportView_Previews: PreviewProvider {
    static var previews: some View {
        HealthReportView(image: UIImage(systemName: "trash")!)
    }
}

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

struct DiseaseDetailView: View {
    let suggestion: Disease
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Probability: \(suggestion.probability)")
                .font(.headline)
            
            Text("Similar Images:")
                .font(.headline)
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(suggestion.similarImages, id: \.id) { image in
                        RemoteImage(urlString: image.url)
                            .frame(width: 200, height: 200)
                            .cornerRadius(16)
                    }
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(suggestion.name.capitalized), displayMode: .large)
    }
}

struct RemoteImage: View {
    let urlString: String
    
    var body: some View {
        if let url = URL(string: urlString),
           let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
    }
}
