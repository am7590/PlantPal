//
//  IdentificationViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/13/24.
//

import SwiftUI
import PlantPalCore

class IdentificationViewModel: ObservableObject {
    @Published var loadState: ReportLoadState = .loading
    @Published var identificationData: IdentificationResponse?
    @Published var similarImages = [String: [UIImage]]()

    var grpcViewModel: GRPCViewModel
    var plantFormViewModel: SuccuelentFormViewModel
    var identificationService: PlantIdentificationServiceProtocol

    init(grpcViewModel: GRPCViewModel, plantFormViewModel: SuccuelentFormViewModel, identificationService: PlantIdentificationServiceProtocol) {
        self.grpcViewModel = grpcViewModel
        self.plantFormViewModel = plantFormViewModel
        self.identificationService = identificationService
    }

    func fetchData() {
        identificationService.identifyPlant(images: plantFormViewModel.uiImage, plantName: plantFormViewModel.name) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.identificationData = response
                    self.loadState = .loaded
                    self.cacheSimilarImages(response)
                case .failure(let error):
                    print("Error fetching data from plant id API: %{PUBLIC}@", String(describing: error))
                    self.loadState = .failed
                }
            }
        }
    }

    private func cacheSimilarImages(_ response: IdentificationResponse) {
        response.result?.classification?.suggestions?.forEach { suggestion in
            suggestion.similarImages?.forEach { similarImage in
                self.fetchAndCacheImage(from: similarImage.url, imageKey: suggestion.name)
            }
        }
    }

    private func fetchAndCacheImage(from urlString: String, imageKey: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching and caching image url: %{PUBLIC}@, %{PUBLIC}@ : %{PUBLIC}@", urlString, imageKey, String(describing: error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                ImageCacheManager.shared.setImage(image, forKey: imageKey)
            }
        }.resume()
    }
}

