//
//  MockPlantIdentificationService.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/16/24.
//

import SwiftUI
import PlantPalCore

// TODO: Write tests with this mock data

class MockPlantIdentificationService: PlantIdentificationServiceProtocol {
    func identifyPlant(images: [String], plantName: String, completion: @escaping (Result<IdentificationResponse, Error>) -> Void) {
        let suggestions = [
            IdentificationSuggestion(id: "1", name: "Aloe Vera", probability: 0.98, similarImages: []),
            IdentificationSuggestion(id: "2", name: "Snake Plant", probability: 0.95, similarImages: []),
            IdentificationSuggestion(id: "3", name: "ZZ Plant", probability: 0.90, similarImages: [])
        ]
        let response = IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: suggestions)))
        completion(.success(response))
    }
}


struct IdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        let grpcViewModel = GRPCViewModel()
        let plantFormViewModel = SuccuelentFormViewModel([])
        let mockService = MockPlantIdentificationService()

        let viewModel = IdentificationViewModel(grpcViewModel: grpcViewModel,
                                                plantFormViewModel: plantFormViewModel,
                                                identificationService: mockService,
                                                onDismiss: { print("Dismissed") })

        let identificationListView = IdentificationListView(identificationData: IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: [
            IdentificationSuggestion(id: "1", name: "Aloe Vera", probability: 0.98, similarImages: []),
            IdentificationSuggestion(id: "2", name: "Snake Plant", probability: 0.95, similarImages: []),
            IdentificationSuggestion(id: "3", name: "ZZ Plant", probability: 0.90, similarImages: [])
        ]))), viewModel: viewModel)

        let identificationView = IdentificationView(viewModel: viewModel)
        
        return identificationView
    }
}
