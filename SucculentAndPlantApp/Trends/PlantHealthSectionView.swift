//
//  PlantHealthSectionView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/16/24.
//

import SwiftUI

struct PlantHealthSectionView: View {
    @ObservedObject var plantHealthViewModel: PlantHealthViewModel
    
    
    
    init(plantId: String, grpcViewModel: GRPCViewModel, plantName: String) {
        plantHealthViewModel = PlantHealthViewModel(grpcViewModel: grpcViewModel, plantId: plantId, plantName: plantName)
    }
    
    var body: some View {
        Section {
            VStack {
                    GraphView(viewModel: GraphViewModel(dataItems: plantHealthViewModel.healthData?.historicalProbabilities.probabilities.map{ TrendsGraphDataItem(date: Date(timeIntervalSince1970: TimeInterval($0.date)), value: ($0.probability)) } ?? []))
                        .padding(.top, 6)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            if let name = plantHealthViewModel.plantInformation?.name, let speciesName = plantHealthViewModel.plantInformation?.identifiedSpeciesName {
                                Text(name).font(.title3).bold()
                                Text(speciesName).italic()
                            } else {
                                Text("No data")
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            CircularProgressView(progress: plantHealthViewModel.probability ?? 0, color: plantHealthViewModel.probability ?? 0 < 50 ? Color(uiColor: .systemGreen) : .red, size: .small, showProgress: true)
                                .frame(width: 50, height: 50)
                        }
                        .padding()
                    }
            }
        }
    }
}

struct PlantHealthSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PlantHealthSectionView(plantId: "", grpcViewModel: GRPCViewModel(), plantName: "Plant")
    }
}
