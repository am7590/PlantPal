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
    
    func create() {
        // Use Swift's Task to offload the gRPC operation
        Task(priority: .background) {
            do {
                let response = try await self.createPlantEntry()
                await self.updateUIResult(with: response)
            } catch {
                await self.updateUIResult(with: error.localizedDescription)
            }
        }
    }

    func createPlantEntry() async throws -> String {
        // Directly create a channel for the specific RPC call
        let channel = GRPCManager.shared.createChannel()
        let client = Plant_PlantServiceNIOClient(channel: channel)
        
        let response = try await client.add(.with { req in
            var storeID = Plant_PlantIdentifier()
            storeID.sku = "00001"
            storeID.deviceIdentifier = "47c3d1239a3242d1a7768ae81daa9cde5c133d9b13d13e5b30520c7b4b0a9170"
            req.identifier = storeID
            
            var storeInfo = Plant_PlantInformation()
            storeInfo.name = "Womp"
            storeInfo.lastWatered = Int64(Date.now.timeIntervalSince1970)
            storeInfo.lastHealthCheck = Int64(Date.now.timeIntervalSince1970)
            storeInfo.lastIdentification = Int64(Date.now.timeIntervalSince1970)
            
            req.information = storeInfo
        }).response
        
        // Try to avoid blocking operations
        // Instead of try? channel.close().wait()
        Task {
            _ = try? await channel.close().get()
        }
        
        return "brik works!"
    }

    func updateUIResult(with message: String) async {
        await MainActor.run {
            self.result = message
        }
    }
}
