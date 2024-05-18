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
    @ObservedObject var viewModel: IdentificationViewModel
    
    init(viewModel: IdentificationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            switch viewModel.loadState {
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
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        .navigationBarHidden(true)
    }
}



//struct IdentificationView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        IdentificationView(viewModel: IdentificationViewModel(grpcViewModel: GRPCViewModel(), plantFormViewModel: SuccuelentFormViewModel([]), identificationService: <#PlantIdentificationServiceProtocol#>))
//    }
//}
