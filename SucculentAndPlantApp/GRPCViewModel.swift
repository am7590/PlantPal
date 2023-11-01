//
//  GRPCViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 10/31/23.
//

import Foundation

// Do NOT use @MainActor or a thread priority inversion will occur.
class GRPCViewModel: ObservableObject {
    @Published var result = ""  // Only for debugging

    func createNewPlant(identifier: String, name: String) {
        // TODO: create sku
        // NEEDS to be background or main thread will hang
        Task(priority: .background) {
            do {
                let response = try await self.createPlantEntry(identifier: identifier, name: name)
                await self.updateUIResult(with: response)
            } catch {
                await self.updateUIResult(with: error.localizedDescription)
            }
        }
    }
    
    func updateExistingPlant(with identifier: String, name: String, lastWatered: Int64?, lastHealthCheck: Int64?, lastIdentification: Int64?) {
            
        let plantID = Plant_PlantIdentifier.with {
            $0.sku = identifier
            $0.deviceIdentifier = "47c3d1239a3242d1a7768ae81daa9cde5c133d9b13d13e5b30520c7b4b0a9170"
        }
        
        Task(priority: .background) {
            do {
                // Fetch the current information
                var currentPlantInfo = try await self.fetchPlantInfo(using: plantID)
                
                if let lastWatered = lastWatered {
                    currentPlantInfo?.lastWatered = lastWatered
                    print("updated lastWatered")
                }
                if let lastHealthCheck = lastHealthCheck {
                    currentPlantInfo?.lastHealthCheck = lastHealthCheck
                    print("updated lastHealthCheck")
                }
                if let lastIdentification = lastIdentification {
                    currentPlantInfo?.lastIdentification = lastIdentification
                    print("updated lastIdentification")
                }
                currentPlantInfo?.name = name
                
                let response = try await self.updatePlantEntry(with: plantID, updatedInfo: currentPlantInfo!)
                await self.updateUIResult(with: response)
            } catch {
                print(error.localizedDescription)
                await self.updateUIResult(with: error.localizedDescription)
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
        
        let response = try await client.add(.with { req in
            var storeID = Plant_PlantIdentifier()
            storeID.sku = identifier
            storeID.deviceIdentifier = "47c3d1239a3242d1a7768ae81daa9cde5c133d9b13d13e5b30520c7b4b0a9170"
            req.identifier = storeID
            
            var storeInfo = Plant_PlantInformation()
            storeInfo.name = name
            storeInfo.lastWatered = Int64(Date.now.timeIntervalSince1970)
            storeInfo.lastHealthCheck = Int64(Date.now.timeIntervalSince1970)
            storeInfo.lastIdentification = Int64(Date.now.timeIntervalSince1970)
            
            req.information = storeInfo
        })
            .response
            .get()

        // Close channel
        Task {
            _ = try? await channel.close().get()
        }
        
        return "brik works!" // do I need a real response here?
    }
 
    private func fetchPlantInfo(using identifier: Plant_PlantIdentifier) async throws -> Plant_PlantInformation? {
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)
        
        let response = try await client.get(identifier)
        let information = try await response.response.get().information
        // Closing the channel asynchronously
        Task {
            _ = try? await channel.close().get()
        }
        
        return information
    }

    private func updatePlantEntry(with identifier: Plant_PlantIdentifier, updatedInfo: Plant_PlantInformation) async throws -> String {
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)
        
        let response = try await client.updatePlant(.with { req in
            req.identifier = identifier
            req.information = updatedInfo
        })
            .status
            .get()
        
        Task {
            _ = try? await channel.close().get()
        }
        
        return "Works"
    }

}
