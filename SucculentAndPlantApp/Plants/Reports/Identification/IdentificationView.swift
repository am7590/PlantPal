//
//  IdentificationView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI
// viewModel.uiImage, plantName: viewModel.name
struct IdentificationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SuccuelentFormViewModel
    @StateObject var grpcViewModel: GRPCViewModel
    @State var loadState: ReportLoadState = .loading
    @State var identificationData: IdentificationResponse? {
        didSet {
            dump(identificationData)
        }
    }
    @State var similarImages = [String: [UIImage]]()
    
    var body: some View {
        VStack {
            switch loadState {
            case .loading:
                ProgressView("Identifying Plant...")
                    .onAppear {
                        fetchData(forPlant: viewModel.name, images: viewModel.uiImage)
                    }
            case .loaded:
                if let identificationData {
                    List {
                        
                        Text("Tap to identify")
                            .font(.largeTitle.bold())
                            .padding(.leading, -8)
                            .listRowBackground(Color.clear)
                        
                        if let suggestions = identificationData.result?.classification?.suggestions {
                            ForEach(suggestions, id: \.id) { suggestion in
                                Section {
                                    VStack(alignment: .leading, spacing: 4) {
                                        
                                        HStack {
                                            
                                            CircularProgressView(progress: suggestion.probability, color: .green, size: .small, showProgress: true)
                                                .frame(width: 45, height: 45)
                                                .padding()
                                            
                                            Text("\(suggestion.name)")
                                                .font(.title)
                                        }
                                        
                                        ScrollView(.horizontal) {
                                                       HStack(spacing: 10) {
                                                           ForEach(suggestion.similarImages ?? [], id: \.id) { imageInfo in
                                                               if let url = URL(string: imageInfo.url) {
                                                                   RemoteImage(url: url)
                                                                       .frame(width: 150, height: 150)
                                                                       .cornerRadius(16)
                                                               }
                                                           }
                                                       }
                                                   }
                                    }
                                    
                                }
                                .onTapGesture {
                                    UserDefaults.standard.hasBeenIdentified(for: viewModel.name, with: suggestion.name)
                                    dismiss()
                                    grpcViewModel.updateExistingPlant(with: viewModel.id!, name: viewModel.name, lastWatered: nil, lastHealthCheck: nil, lastIdentification: Int64(Date().timeIntervalSince1970), identifiedSpeciesName: suggestion.name, newHealthProbability: nil)
                                }
                            }
                        } else {
                            Text("Plant Not Identified")
                                .font(.headline)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    Text("Failed to identify plant")
                }
            case .failed:
                ErrorHandlingView(listType: .failedToLoad)
            }
        }
        .navigationBarHidden(true)
    }
    
}

struct IdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        let response = IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: [IdentificationSuggestion(id: "0", name: "Suggestion #1", probability: 0.51, similarImages: []), IdentificationSuggestion(id: "1", name: "Suggestion #2", probability: 0.45, similarImages: []), IdentificationSuggestion(id: "2", name: "Suggestion #3", probability: 0.3, similarImages: [])])))
//        IdentificationView(images: [UIImage(systemName: "leaf")!], plantName: "Womp Womp", loadState: .loaded, identificationData: response)
        IdentificationView(viewModel: SuccuelentFormViewModel([]), grpcViewModel: GRPCViewModel())
    }
}
