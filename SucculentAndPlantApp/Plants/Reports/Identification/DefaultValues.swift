//
//  DefaultValues.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/1/24.
//

import Foundation

protocol Defaultable {
    static func defaultValue() -> Self
}

extension HealthAssessmentResponse: Defaultable {
    static func defaultValue() -> HealthAssessmentResponse {
        return HealthAssessmentResponse(result: HealthResult(isPlant: HealthPrediction(probability: 40.0, binary: false, threshold: 1.0), isHealthy: HealthPrediction(probability: 0, binary: false, threshold: 0), disease: DiseaseSuggestion(suggestions: [])))
    }
}

extension IdentificationResponse: Defaultable {
    public static func defaultValue() -> IdentificationResponse {
        return IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: [])))
    }
}
