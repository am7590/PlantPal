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
    var identifyPlantHandler: (([String], String, @escaping (Result<IdentificationResponse, Error>) -> Void) -> Void)?

    func identifyPlant(images: [String], plantName: String, completion: @escaping (Result<IdentificationResponse, Error>) -> Void) {
        if let handler = identifyPlantHandler {
            handler(images, plantName, completion)
        } else {
            // Default behavior
            let suggestions = [
                IdentificationSuggestion(id: "1", name: "Aloe Vera", probability: 0.98, similarImages: []),
                IdentificationSuggestion(id: "2", name: "Snake Plant", probability: 0.95, similarImages: []),
                IdentificationSuggestion(id: "3", name: "ZZ Plant", probability: 0.90, similarImages: [])
            ]
            let response = IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: suggestions)))
            completion(.success(response))
        }
    }
}
