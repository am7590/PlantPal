import SwiftUI
import os
import Shimmer

struct HealthReportView: View {
    @StateObject var viewModel: SuccuelentFormViewModel
    @StateObject var grpcViewModel: GRPCViewModel
    @StateObject private var healthDataViewModel = HealthDataViewModel()

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                let imageWidth = proxy.size.width - 24

                VStack {
                    switch healthDataViewModel.loadState {
                    case .loading:
                        // Shimmer placeholder view
                        HealthDataListView(healthData: HealthAssessmentResponse(result: HealthResult(isPlant: HealthPrediction(probability: 0.69, binary: true, threshold: 0.1), isHealthy: HealthPrediction(probability: 0.99, binary: true, threshold: 0.2), disease: DiseaseSuggestion(suggestions: [Disease(id: "01", name: "Wompie Dompie", probability: 0.56, similarImages: [SimilarImage(id: "01", url: "https://avatars.githubusercontent.com/u/70722459?v=4", similarity: 0.90, urlSmall: "https://avatars.githubusercontent.com/u/70722459?v=4")] ), Disease(id: "02", name: "Wompie Dompie", probability: 0.56, similarImages: [SimilarImage(id: "01", url: "https://avatars.githubusercontent.com/u/70722459?v=4", similarity: 0.90, urlSmall: "https://avatars.githubusercontent.com/u/70722459?v=4")] )]))), imageWidth: CGFloat(400.2), similarImages: [:])
                            .redacted(reason: .placeholder)
                    case .loaded:
                        if let healthData = healthDataViewModel.healthData {
                            HealthDataListView(healthData: healthData, imageWidth: imageWidth, similarImages: healthDataViewModel.similarImages)
                        } else {
                            ErrorHandlingView(listType: .noData)
                        }
                    case .failed:
                        ErrorHandlingView(listType: .failedToLoad)
                    }
                }
                .navigationTitle("Health Report")
                .onAppear {
                    healthDataViewModel.fetchData(for: viewModel.name, id: viewModel.id, image: viewModel.uiImage.first!)
                }
            }
        }
        .accentColor(Color(uiColor: .systemGreen))
    }
}


struct HealthDataListView: View {
    let healthData: HealthAssessmentResponse
    let imageWidth: CGFloat
    let similarImages: [String: [UIImage]]  // Pass similarImages as a parameter

    var body: some View {
        List {
            HealthSummarySection(healthData: healthData, imageWidth: imageWidth)
                .padding(.top, 20)
                .padding(.bottom, 4)
            DiseaseSuggestionSection(diseases: healthData.result.disease.suggestions, similarImages: similarImages)
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct HealthSummarySection: View {
    var healthData: HealthAssessmentResponse
    var imageWidth: CGFloat

    var body: some View {
        Section {
            HStack {
                Spacer()
                VStack {
                    CircularProgressView(progress: healthData.result.isHealthy.probability, color: healthData.color, size: .large, showProgress: true)
                        .frame(width: imageWidth / 3, height: imageWidth / 3)
                    
                    Text(healthData.result.isHealthy.binary ? "Healthy" : "Not Healthy")
                        .font(.title2.bold())
                        .foregroundColor(healthData.color)
                        .padding(.top)
                }
                Spacer()
            }
        }
    }
}


struct DiseaseDetailView: View {
    var disease: Disease
    var color: Color
    var similarImages: [String: [UIImage]]

    var body: some View {
        List {
            Section {
                HStack {
                    CircularProgressView(progress: disease.probability, color: color, size: .small, showProgress: true)
                        .frame(width: 55, height: 55)
                    
                    Text(disease.name.capitalized)
                        .font(.title)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding()
            }
            
            if let images = similarImages[disease.id] {
                Section {
                    ImageViewer(images: images)
                        .padding()
                }
               
            }
        }
        .padding()
    }
}



struct ImageViewer: View {
    var images: [UIImage]

    var body: some View {
        VStack {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(8)
            }
        }
    }
}

struct DiseaseSuggestionSection: View {
    var diseases: [Disease]
    var similarImages: [String: [UIImage]]  // Add this property

    var body: some View {
        Section(header: Text("Diseases")) {
            ForEach(diseases, id: \.id) { disease in
                NavigationLink(destination: DiseaseDetailView(disease: disease, color: .red, similarImages: similarImages)) {
                    Text(disease.name.capitalized)
                        .font(.headline)
                }
            }
        }
    }
}


class HealthDataViewModel: ObservableObject {
    @Published var healthData: HealthAssessmentResponse?
    @Published var similarImages = [String: [UIImage]]()
    @Published var loadState: ReportLoadState = .loading

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

        let apiUrl = URL(string: "https://plant.id/api/v3/health_assessment")!
        PlantAPINetworkService.shared.fetchData(url: apiUrl, cacheKey: plantName+":health", requestBody: requestBody) { [weak self] (result: Result<HealthAssessmentResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.healthData = response
                    self?.loadState = .loaded
                    self?.cacheSimilarImages(from: response)
                    
                    if let id {
                        GRPCViewModel().saveHealthCheckData(for: id, currentProbability: response.result.isHealthy.probability, historicalProbabilities: [])
                    }
                case .failure(let error):
                    Logger.networking.error("Error fetching data: \(error)")
                    self?.loadState = .failed
                }
            }
        }
    }

    private func cacheSimilarImages(from response: HealthAssessmentResponse) {
        response.result.disease.suggestions.forEach { suggestion in
            suggestion.similarImages.forEach { imageInfo in
                setImageFromStringURL(stringUrl: imageInfo.url, imageKey: suggestion.id) // Use disease id as key
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
