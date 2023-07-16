//
//  IdentificationReponse.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

struct IdentificationResponse: Codable {
    let result: IdentificationResult?
}

struct IdentificationResult: Codable {
    let classification: IdentificationClassification?
}

struct IdentificationClassification: Codable {
    let suggestions: [IdentificationSuggestion]?
}

struct IdentificationSuggestion: Codable {
    let id: String
    let name: String
    let probability: Double
    let similarImages: [IdentificationSimilarImage]?
}

struct IdentificationSimilarImage: Codable {
    let id: String
    let url: String
    let licenseName: String?
    let licenseUrl: String?
    let citation: String?
    let similarity: Double
    let urlSmall: String
}
