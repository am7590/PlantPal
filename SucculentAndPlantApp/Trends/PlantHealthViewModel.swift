//
//  PlantHealthViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/16/24.
//

import SwiftUI
import os

class PlantHealthViewModel: ObservableObject {
    @Published var healthData: Plant_HealthCheckInformation?
    @Published var plantInformation: Plant_PlantInformation?
    
    @Published var loadedHealthData = false
    @Published var loadedPlantInformation = false
    
    @Published var probability: Double? = nil
    
    @Published var isLoading = true
    
    let grpcViewModel: GRPCViewModel
    let plantId: String
    
    init(grpcViewModel: GRPCViewModel, plantId: String, plantName: String) {
        self.grpcViewModel = grpcViewModel
        self.plantId = plantId
        
        fetchPlantInfoData(id: plantId, plantName: plantName)
        fetchHealthData(id: plantId, plantName: plantName)
    }
    
    private func fetchHealthData(id: String, plantName: String) {
        Task {
            do {
                let fetchedData = try await grpcViewModel.fetchHealthCheckInfo(withID: id, forPlantName: plantName)
                DispatchQueue.main.async {
                    self.healthData = fetchedData
                    self.loadedHealthData = true
                    self.probability = fetchedData?.historicalProbabilities.probabilities.first?.probability
                }
            } catch {
                self.isLoading = false
                Logger.networking.error("\(#function) \(error)")
            }
        }
    }
    
    private func fetchPlantInfoData(id: String, plantName: String) {
        Task {
            do {
                print("^^^ fetching plant info for \(id) and \(plantName)")
                let fetchedData = try await grpcViewModel.fetchPlantInfo(using: id, plantName: plantName)
                DispatchQueue.main.async {
                    self.plantInformation = fetchedData
                    self.loadedPlantInformation = true
                }
            } catch {
                self.isLoading = false
                Logger.networking.error("\(#function) \(error)")
            }
        }
    }
}

