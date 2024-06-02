//
//  PlantHealthDataService.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/18/24.
//

import Foundation
import PlantPalCore

protocol HealthDataServiceProtocol {
    func fetchHealthData(requestBody: [String: Any], completion: @escaping (Result<HealthAssessmentResponse, Error>) -> Void)
}

class PlantHealthDataService: HealthDataServiceProtocol {
    static let shared = PlantHealthDataService()

    func fetchHealthData(requestBody: [String: Any], completion: @escaping (Result<HealthAssessmentResponse, Error>) -> Void) {
        let apiUrl = URL(string: "https://plant.id/api/v3/health_assessment")!
        PlantAPINetworkService.shared.fetchData(url: apiUrl, cacheKey: "health", userDeviceToken: GRPCManager.shared.userDeviceToken, requestBody: requestBody, completion: completion)
    }
}
