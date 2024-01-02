//
//  HealthAssessmentResponse.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

struct HealthAssessmentResponse: Codable {
    let result: HealthResult

    var color: Color {
        result.isHealthy.binary ? .green : .red
    }
}

struct HealthResult: Codable {
    let isPlant: HealthPrediction
    let isHealthy: HealthPrediction
    let disease: DiseaseSuggestion

    enum CodingKeys: String, CodingKey {
        case isPlant = "is_plant"
        case isHealthy = "is_healthy"
        case disease
    }
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

    enum CodingKeys: String, CodingKey {
        case id, name, probability
        case similarImages = "similar_images"
    }
}

struct SimilarImage: Codable {
    let id: String
    let url: String
    let similarity: Double
    let urlSmall: String

    enum CodingKeys: String, CodingKey {
        case id, url, similarity
        case urlSmall = "url_small"
    }
}
