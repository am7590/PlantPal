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
    
    @Published var isLoading = true
    
    let grpcViewModel: GRPCViewModel
    let plantId: String
    
    init(grpcViewModel: GRPCViewModel, plantId: String) {
        self.grpcViewModel = grpcViewModel
        self.plantId = plantId
        fetchHealthData()
        fetchPlantInfoData()
    }
    
    private func fetchHealthData() {
        Task {
            do {
                let fetchedData = try await grpcViewModel.fetchHealthCheckInfo(for: plantId)
                DispatchQueue.main.async {
                    self.healthData = fetchedData
                    self.loadedHealthData = true
                }
            } catch {
                self.isLoading = false
                Logger.networking.error("\(#function) \(error)")
            }
        }
    }
    
    private func fetchPlantInfoData() {
        Task {
            do {
                let fetchedData = try await grpcViewModel.fetchPlantInfo(using: plantId)
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

