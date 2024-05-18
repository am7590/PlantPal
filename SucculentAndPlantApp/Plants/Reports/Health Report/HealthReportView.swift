import SwiftUI
import os
import Shimmer
import PlantPalSharedUI
import PlantPalCore

struct HealthReportView: View {
    @StateObject var viewModel: SuccuelentFormViewModel
    @StateObject var grpcViewModel: GRPCViewModel
    @StateObject private var healthDataViewModel: HealthDataViewModel

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                let imageWidth = proxy.size.width - 24

                VStack {
                    switch healthDataViewModel.loadState {
                    case .loading:
                        HealthDataListPlaceholderView()
                    case .loaded:
                        if let healthData = healthDataViewModel.healthData {
                            HealthDataListView(healthData: healthData, imageWidth: imageWidth, similarImages: healthDataViewModel.similarImages)
                        } else {
                            ErrorHandlingView(listType: .noData)
                        }
                    case .failed:
                        ErrorHandlingView(listType: .failedToLoad)
                    }
                }
                .navigationTitle("Health Report")
                .onAppear {
                    healthDataViewModel.fetchData(for: viewModel.name, id: viewModel.id, image: viewModel.uiImage.first!)
                }
            }
        }
        .accentColor(Color(uiColor: .systemGreen))
    }
}
