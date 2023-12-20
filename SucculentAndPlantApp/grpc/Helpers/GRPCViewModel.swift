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
    
    func updateExistingPlant(with identifier: String, name: String, lastWatered: Int64?, lastHealthCheck: Int64?, lastIdentification: Int64?) {
        
        let plantID = Plant_PlantIdentifier.with {
            $0.sku = identifier
            $0.deviceIdentifier = GRPCManager.shared.userDeviceToken
        }
        
        Task(priority: .background) {
            do {
                // Fetch the current item's information
                var currentPlantInfo = try await self.fetchPlantInfo(using: plantID)
                
                // Check if lastWatered field was updated
                if let serverLastWatered = currentPlantInfo?.lastWatered, let lastWatered = lastWatered, serverLastWatered != lastWatered {
                    currentPlantInfo?.lastWatered = lastWatered
                }
                
                // Check if last health check date was updated
                if let lastHealthCheck = lastHealthCheck {
                    currentPlantInfo?.lastHealthCheck = lastHealthCheck
                }
                
                // Check if last ID date was updated
                if let lastIdentification = lastIdentification {
                    currentPlantInfo?.lastIdentification = lastIdentification
                }
                
                currentPlantInfo?.name = name
                
                let response = try await self.updatePlantEntry(with: plantID, updatedInfo: currentPlantInfo!)
                await self.updateUIResult(with: response)
            } catch {
                Logger.plantPal.error("\(#function) \(error.localizedDescription)")
                await self.updateUIResult(with: error.localizedDescription)
                
                Task {
                    let banner = await Banner(title: "Could not update", subtitle: "\(error.localizedDescription)", image: UIImage(named: "alert"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
                    await banner.show(duration: 5.0)
                }
            }
        }
    }
    
    func removePlantEntry(with identifier: String) {
        let plantID = Plant_PlantIdentifier.with {
            $0.sku = identifier
            
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
            storeID.deviceIdentifier = GRPCManager.shared.userDeviceToken
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
        
        Logger.networking.debug("\(#function) \(response.debugDescription)")
        
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
    
    private func removePlant(from identifier: Plant_PlantIdentifier) async throws -> Plant_PlantResponse {
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)
        
        let response = try await client.remove(identifier)
            .response
            .get()
        
        // Close channel asynchronously
        Task {
            _ = try? await channel.close().get()
        }
        
        return response
    }
}
