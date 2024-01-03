//
//  PlantAPINetworkService.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/1/24.
//

import Foundation
import os

// Makes and caches requests to a third-party API which performs plant id and health checks
class PlantAPINetworkService {
    static let shared = PlantAPINetworkService()
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    private let cacheKeyPrefix = "apiResponseCache_"

    func fetchData<T: Codable>(url: URL, cacheKey: String, requestBody: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        let fullCacheKey = cacheKeyPrefix + "\(cacheKey):\(GRPCManager.shared.userDeviceToken)"

        if let cachedData = UserDefaults.standard.data(forKey: fullCacheKey) {
            do {
                let cachedResponse = try jsonDecoder.decode(T.self, from: cachedData)
                // Check if cachedResponse is valid, if not, continue to fetch from network
                if isValidResponse(cachedResponse) {
                    DispatchQueue.main.async {
                        completion(.success(cachedResponse))
                    }
                    return
                } else {
                    UserDefaults.standard.removeObject(forKey: fullCacheKey)
                }
            } catch {
                UserDefaults.standard.removeObject(forKey: fullCacheKey)
            }
        }

        performNetworkRequest(url: url, requestBody: requestBody, cacheKey: fullCacheKey, completion: completion)
    }

    private func performNetworkRequest<T: Codable>(url: URL, requestBody: [String: Any], cacheKey: String, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("S6VUgIM03MvELLMGtMQBEpVuBvtaG0b0UOGoma3iT2oO2OuMYH", forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }

            do {
                let decodedObject = try self.jsonDecoder.decode(T.self, from: data)
                UserDefaults.standard.set(data, forKey: cacheKey) // Cache the new data
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func isValidResponse<T: Codable>(_ response: T) -> Bool {
        // Check if the response is of type IdentificationResponse
        if let identificationResponse = response as? IdentificationResponse {
            // A valid IdentificationResponse should have a non-nil classification
            return identificationResponse.result?.classification != nil
        }

        // TODO: Do this for health check responses too
        // Return true for other types where specific validation logic is not implemented
        return true
    }
}
