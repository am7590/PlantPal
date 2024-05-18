//
//  IdentificationListView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/16/24.
//

import SwiftUI
import PlantPalCore
import PlantPalSharedUI

struct IdentificationListView: View {
    var identificationData: IdentificationResponse
    @ObservedObject var viewModel: IdentificationViewModel

    var body: some View {
        List {
            if let suggestions = identificationData.result?.classification?.suggestions {
                ForEach(suggestions, id: \.id) { suggestion in
                    IdentificationSuggestionView(suggestion: suggestion)
                        .onTapGesture {
                            handleSuggestionTap(suggestion)
                        }
                }
            } else {
                Text("Plant Not Identified")
                    .font(.headline)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    private func handleSuggestionTap(_ suggestion: IdentificationSuggestion) {
        UserDefaults.standard.hasBeenIdentified(for: viewModel.plantFormViewModel.name, with: suggestion.name)
//        viewModel.onDismiss
        viewModel.grpcViewModel.updateExistingPlant(with: viewModel.plantFormViewModel.id!, name: viewModel.plantFormViewModel.name, lastWatered: nil, lastHealthCheck: nil, lastIdentification: Int64(Date().timeIntervalSince1970), identifiedSpeciesName: suggestion.name, newHealthProbability: nil)
    }
}

