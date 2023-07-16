//
//  HealthAssessmentResponse.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

struct HealthAssessmentResponse: Codable {
    let result: HealthResult
}

struct HealthResult: Codable {
    let isHealthy: HealthPrediction
    let disease: DiseaseSuggestion
}

struct HealthPrediction: Codable {
    let probability: Double
    let binary: Bool
    let threshold: Double
}

struct DiseaseSuggestion: Codable {
    let suggestions: [Disease]
}

struct Disease: Codable {
    let id: String
    let name: String
    let probability: Double
    let similarImages: [SimilarImage]
}

struct SimilarImage: Codable {
    let id: String
    let url: String
    let similarity: Double
    let urlSmall: String
}
