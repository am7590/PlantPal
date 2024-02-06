//
//  PlantHealthSectionView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/16/24.
//

import SwiftUI

struct PlantHealthSectionView: View {
    @ObservedObject var plantHealthViewModel: PlantHealthViewModel
    
    init(plantId: String, grpcViewModel: GRPCViewModel) {
        plantHealthViewModel = PlantHealthViewModel(grpcViewModel: grpcViewModel, plantId: plantId)
    }
    
    var body: some View {
        Section {
            VStack {
//                if !plantHealthViewModel.loadedPlantInformation {
////                    if plantHealthViewModel.isLoading {
////                        PlaceholderShimmerView()
////                    } else {
//                        HStack {
//                            Spacer()
//                            Text("Perform a health check for \(plantHealthViewModel.plantInformation?.name ?? " your plant")")
//                                .bold()
//                            Spacer()
//                        }
////                    }
//                } else {
                    GraphView(viewModel: GraphViewModel(dataItems: plantHealthViewModel.healthData?.historicalProbabilities.probabilities.map{ TrendsGraphDataItem(date: Date(timeIntervalSince1970: TimeInterval($0.date)), value: ($0.probability*100)) } ?? []))
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
                            CircularProgressView(progress: plantHealthViewModel.healthData?.probability ?? 0, color: plantHealthViewModel.healthData?.probability ?? 0 < 50 ? Color(uiColor: .systemGreen) : .red, size: .small, showProgress: true)
                                .frame(width: 50, height: 50)
                            //                            Text(plantHealthViewModel.healthData?.historicalProbabilities.probabilities.first?.name ?? "")
                            //                                .font(.caption.bold())
                        }
                        .padding()
                    }
//                }
                
            }
        }
    }
}

//struct PlantHealthSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantHealthSectionView()
//    }
//}
