//
//  GRPCViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 10/31/23.
//

import Foundation
import BRYXBanner
import UIKit
import os

// Do NOT use @MainActor or a thread priority inversion will occur!!!
class GRPCViewModel: ObservableObject {
    @Published var result = ""  // Only for debugging
    
    func createNewPlant(identifier: String, name: String) {
        // NEEDS to be background or main thread will hang
        Task(priority: .background) {
            do {
                let response = try await self.createPlantEntry(identifier: identifier, name: name)
                Logger.networking.debug("Received response: \(response)")
                await self.updateUIResult(with: response)
            } catch {
                await self.updateUIResult(with: error.localizedDescription)

                Task {
                    let banner = await Banner(title: "Could not create a new plant", subtitle: "\(error.localizedDescription)", image: UIImage(named: "alert"), backgroundColor: .red)
                    await banner.show(duration: 5.0)
                }
            }
        }
    }

    func updateExistingPlant(with identifier: String, name: String, lastWatered: Int64?, lastHealthCheck: Int64?, lastIdentification: Int64?, identifiedSpeciesName: String?, newHealthProbability: String?) {
        Task(priority: .background) {
            do {
                // Fetch the current item's information
                var currentPlantInfo = try await self.fetchPlantInfo(using: identifier, plantName: name)

                // Update fields as necessary
                if let lastWatered = lastWatered {
                    currentPlantInfo?.lastWatered = lastWatered
                }
                if let lastHealthCheck = lastHealthCheck {
                    currentPlantInfo?.lastHealthCheck = lastHealthCheck
                }
                if let lastIdentification = lastIdentification {
                    currentPlantInfo?.lastIdentification = lastIdentification
                }
                if let identifiedSpeciesName = identifiedSpeciesName {
                    currentPlantInfo?.identifiedSpeciesName = identifiedSpeciesName
                }

                // Update the plant's name
                currentPlantInfo?.name = name

                // Hardcode the SKU to be the concatenation of the updated plant name and the user's iCloud ID
                let plantID = Plant_PlantIdentifier.with {
                    $0.sku = "\(name)\(GRPCManager.shared.userDeviceToken)"
                    $0.deviceIdentifier = GRPCManager.shared.userDeviceToken
                }
                
                let response = try await self.updatePlantEntry(with: plantID, updatedInfo: currentPlantInfo!)
                await self.updateUIResult(with: response)
            } catch {
                Logger.plantPal.error("\(#function) \(error.localizedDescription)")
                await self.updateUIResult(with: error.localizedDescription)

                Task {
                    let banner = await Banner(title: "Could not update", subtitle: "\(error.localizedDescription)", image: UIImage(named: "alert"), backgroundColor: .red)
                    await banner.show(duration: 5.0)
                }
            }
        }
    }

    func removePlantEntry(with identifier: String) {
        let plantID = Plant_PlantIdentifier.with {
            $0.sku = "\(identifier)\(GRPCManager.shared.userDeviceToken)"
            // Assuming deviceIdentifier is the same for all entries and known ahead of time
            $0.deviceIdentifier = GRPCManager.shared.userDeviceToken
        }

        Task(priority: .background) {
            do {
                let response = try await self.removePlant(from: plantID)
                Logger.plantPal.debug("\(#function) Removed plant with response: \(response.debugDescription)")
                await self.updateUIResult(with: response.status)
            } catch {
                await self.updateUIResult(with: error.localizedDescription)

                Task {
                    let banner = await Banner(title: "Removal Failed", subtitle: "\(error.localizedDescription)", image: UIImage(named: "alert"), backgroundColor: UIColor.red)
                    await banner.show(duration: 3.0)
                }
            }
        }
    }

    func fetchPlantInfo(using identifier: String, plantName: String) async throws -> Plant_PlantInformation? {
        print("\(#function) idntifier: \(identifier)")
        let request = Plant_GetPlantRequest.with {
            $0.uuid = GRPCManager.shared.userDeviceToken
            // Hardcode the SKU to be the concatenation of the plant name and the user's iCloud ID
            $0.sku = "\(plantName)\(identifier)"
        }
        
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)

        let response = client.get(request)
        let information = try await response.response.get().information
        
        // Closing the channel asynchronously
        Task {
            _ = try? await channel.close().get()
        }

        return information
    }



    public func fetchHealthCheckInfo(for identifier: String) async throws -> Plant_HealthCheckInformation? {
        
        let request = Plant_HealthCheckRequestParam.with {
            $0.uuid = GRPCManager.shared.userDeviceToken
            $0.sku = identifier+GRPCManager.shared.userDeviceToken
        }

        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)

        do {
            let response = client.healthCheckRequest(request)
            let healthCheckInfo = try await response.response.get()

            var processedHealthCheckInfo = healthCheckInfo

            return processedHealthCheckInfo
        } catch {
            throw error
        }
    }
    
    func saveHealthCheckData(for identifier: String, currentProbability: Double, historicalProbabilities: [[String: Any]]) {
           let plantID = Plant_PlantIdentifier.with {
               $0.sku = identifier+GRPCManager.shared.userDeviceToken
               $0.deviceIdentifier = GRPCManager.shared.userDeviceToken
           }
           
           // healthCheckInformation JSON
           var healthCheckData = [String: Any]()
           healthCheckData["probability"] = currentProbability
           healthCheckData["historicalProbabilities"] = historicalProbabilities
           
           // Store as a JSON string
           guard let jsonData = try? JSONSerialization.data(withJSONObject: healthCheckData, options: []),
                 let jsonString = String(data: jsonData, encoding: .utf8) else {
   //            self.updateUIResult(with: "Error creating JSON data")
               return
           }
           
           let healthCheckDataRequest = Plant_HealthCheckDataRequest.with {
               $0.identifier = plantID
               $0.healthCheckInformation = jsonString
           }
           
           Task(priority: .background) {
               do {
                   let response = try await self.sendHealthCheckData(healthCheckDataRequest)
//                   Logger.networking.debug("Health Check Data Saved: \(response)")
                   await self.updateUIResult(with: "Health check data saved successfully.")
               } catch {
                   await self.updateUIResult(with: error.localizedDescription)
                   
                   Task {
                       let banner = await Banner(title: "Failed to Save Health Check Data", subtitle: "\(error.localizedDescription)", image: UIImage(named: "alert"), backgroundColor: .red)
                       await banner.show(duration: 5.0)
                   }
               }
           }
       }
}

// MARK: Update UI
// Right now all this does is shows the result of the request
extension GRPCViewModel {
    private func updateUIResult(with message: String) async {
        await MainActor.run {
            self.result = message
        }
    }
}


// MARK: Interact with gRPC server
extension GRPCViewModel {
    private func createPlantEntry(identifier: String, name: String) async throws -> String {
        // Directly create a channel for the specific RPC call
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)
        let token = GRPCManager.shared.userDeviceToken

        print("Creating plant entry for \(name) id:\(identifier)\ndeviceToken:\(token)")
        
        let plant = Plant_Plant.with {
            $0.identifier = Plant_PlantIdentifier.with {
                $0.sku = name+identifier
                $0.deviceIdentifier = identifier
            }
            $0.information = Plant_PlantInformation.with {
                $0.name = name
                $0.lastWatered = Int64(Date().timeIntervalSince1970)
                $0.lastHealthCheck = Int64(Date().timeIntervalSince1970)
                $0.lastIdentification = Int64(Date().timeIntervalSince1970)
            }
        }
        
        print("userId: \(GRPCManager.shared.userDeviceToken)")
        
        let addRequest = Plant_AddPlantRequest.with {
            $0.plant = plant
            $0.userID = identifier
        }
        
        print("AddRequest: \(addRequest.debugDescription)")

        let response = try await client.add(addRequest)
            .response
            .get()
        
        print("response: \(response.debugDescription)")

        Logger.networking.debug("\(#function) \(response.debugDescription)")

        // Close channel
        Task {
            _ = try? await channel.close().get()
        }
        dump(response)

        return response.status
    }


    private func updatePlantEntry(with identifier: Plant_PlantIdentifier, updatedInfo: Plant_PlantInformation) async throws -> String {
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)

        let response = try await client.updatePlant(.with {
            $0.identifier = identifier
            $0.information = updatedInfo
        })
        .status
        .get()

        Task {
            _ = try? await channel.close().get()
        }

        return response.description
    }


    private func removePlant(from identifier: Plant_PlantIdentifier) async throws -> Plant_PlantResponse {
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)
        // Create a Plant_RemovePlantRequest object with the provided identifier
        let removeRequest = Plant_RemovePlantRequest.with {
            $0.sku = identifier.sku
            $0.uuid = GRPCManager.shared.userDeviceToken
        }

        let response = try await client.remove(removeRequest)
            .response
            .get()

        // Close channel asynchronously
        Task {
            _ = try? await channel.close().get()
        }

        return response
    }



    private func sendHealthCheckData(_ request: Plant_HealthCheckDataRequest) async throws -> Plant_HealthCheckDataResponse {
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)

        let response = try await client.saveHealthCheckData(request)
            .response
            .get()

        // Close channel
        Task {
            _ = try? await channel.close().get()
        }

        return response
    }
}

extension GRPCViewModel {
    func registerOrGetUser(uuid: String) async throws -> String {
        let userIdentifier = Plant_UserIdentifier.with {
            $0.uuid = uuid
        }

        let channel = GRPCManager.shared.createChannel()
        print(channel)
        let client = Plant_PlantServiceNIOClient(channel: channel)
        print(client)

        do {
            
            print("client.registerOrGetUser(\(userIdentifier))")
            let response = try await client.registerOrGetUser(userIdentifier)
                .response
                .get()

            print("registerOrGetUser response: ")
            print(response)
            
            Task {
                _ = try? await channel.close().get()
            }

            return response.status
        } catch {
            print("registerOrGetUser error: ")
            print(error)
            throw error
        }
    }
}
