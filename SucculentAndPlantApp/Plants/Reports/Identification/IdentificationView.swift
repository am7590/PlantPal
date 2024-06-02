//
//  IdentificationView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI
import PlantPalSharedUI
import PlantPalCore

struct IdentificationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: IdentificationViewModel
    
    init(viewModel: IdentificationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
//            Text("Current state: \(viewModel.loadState.hashValue)") // Debug: Show current state
            
            switch viewModel.loadState {
                
            // loadState not updating view
            case .loading:
                IdentificationSuggestionLoadingView()
            case .loaded:
                if let data = viewModel.identificationData {
                    IdentificationListView(identificationData: data, viewModel: viewModel)
                } else {
                    Text("Failed to identify plant")
                }
            case .failed:
                ErrorHandlingView(listType: .failedToLoad)
            case .done:
                EmptyView() // unused
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
//        .navigationBarHidden(true)
        .onChange(of: viewModel.loadState) { newState in
            if newState == .done {
                dismiss()
            }
        }
    }
}


struct IdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        let grpcViewModel = GRPCViewModel()
        let plantFormViewModel = SuccuelentFormViewModel([], context: PersistenceController.shared.container.viewContext)
        let mockService = MockPlantIdentificationService()

        let viewModel = IdentificationViewModel(grpcViewModel: grpcViewModel,
                                                plantFormViewModel: plantFormViewModel,
                                                identificationService: mockService)

        let identificationListView = IdentificationListView(identificationData: IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: [
            IdentificationSuggestion(id: "1", name: "Aloe Vera", probability: 0.98, similarImages: []),
            IdentificationSuggestion(id: "2", name: "Snake Plant", probability: 0.95, similarImages: []),
            IdentificationSuggestion(id: "3", name: "ZZ Plant", probability: 0.90, similarImages: [])
        ]))), viewModel: viewModel)

        let identificationView = IdentificationView(viewModel: viewModel)
        
        return identificationView
    }
}

