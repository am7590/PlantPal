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

    func fetchData<T: Codable>(url: URL, requestBody: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        let cacheKey = cacheKeyPrefix + "\(url.absoluteString):\(GRPCManager.shared.userDeviceToken)"        
        if let cachedData = UserDefaults.standard.data(forKey: cacheKey) {
            do {
                let cachedResponse = try jsonDecoder.decode(T.self, from: cachedData)
                DispatchQueue.main.async {
                    completion(.success(cachedResponse))
                }
                return
            } catch {
                fatalError("womp womp")
            }
        }

        // Network request
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
            
            Logger.networking.debug("\(String(data: data!, encoding: .utf8)!)")


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
}
