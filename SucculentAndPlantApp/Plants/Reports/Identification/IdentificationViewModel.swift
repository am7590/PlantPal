//
//  IdentificationViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/13/24.
//

import SwiftUI
import PlantPalCore

protocol PlantIdentificationServiceProtocol {
    func identifyPlant(images: [String], plantName: String, completion: @escaping (Result<IdentificationResponse, Error>) -> Void)
}

class IdentificationViewModel: ObservableObject, PlantIdentificationServiceProtocol {
    @Published var loadState: ReportLoadState = .loading
    @Published var identificationData: IdentificationResponse?
    @Published var similarImages = [String: [UIImage]]()

    var grpcViewModel: GRPCViewModel
    var plantFormViewModel: SuccuelentFormViewModel
    var identificationService: PlantIdentificationServiceProtocol
//    var onDismiss: (() -> Void)?

    init(grpcViewModel: GRPCViewModel, plantFormViewModel: SuccuelentFormViewModel, identificationService: PlantIdentificationServiceProtocol, onDismiss: (() -> Void)? = nil) {
        self.grpcViewModel = grpcViewModel
        self.plantFormViewModel = plantFormViewModel
        self.identificationService = identificationService
//        self.onDismiss = onDismiss
    }
    
    func identifyPlant(images: [String], plantName: String, completion: @escaping (Result<PlantPalCore.IdentificationResponse, Error>) -> Void) {
        identificationService.identifyPlant(images: images, plantName: plantName) { result in
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

    func fetchData() {
        let images = plantFormViewModel.uiImage.map { $0.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? "" }
        
        identificationService.identifyPlant(images: images, plantName: plantFormViewModel.name) { result in
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

