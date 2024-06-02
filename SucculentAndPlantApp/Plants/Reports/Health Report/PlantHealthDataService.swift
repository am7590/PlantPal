//
//  MockHealthDataService.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/18/24.
//

import Foundation
import PlantPalCore

class MockHealthDataService: HealthDataServiceProtocol {
    var mockResponse: Result<HealthAssessmentResponse, Error>?

    func fetchHealthData(requestBody: [String: Any], completion: @escaping (Result<HealthAssessmentResponse, Error>) -> Void) {
        if let response = mockResponse {
            completion(response)
        } else {
            completion(.failure(NSError(domain: "No mock response set", code: -1, userInfo: nil)))
        }
    }
}
