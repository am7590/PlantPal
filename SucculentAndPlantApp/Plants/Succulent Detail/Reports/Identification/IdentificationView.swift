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
    @State var identificationData: IdentificationResponse?
    @State var similarImages = [String: [UIImage]]()
    
    var body: some View {
        VStack {
            switch loadState {
            case .loading:
                ProgressView("Identifying Plant...")
                    .onAppear {
                        fetchData(images: viewModel.uiImage)
                    }
            case .loaded:
                if let identificationData {
                    List {
                        if let suggestions = identificationData.result?.classification?.suggestions {
                            ForEach(suggestions, id: \.id) { suggestion in
                                Section {
                                    VStack(alignment: .leading, spacing: 4) {
                                        
                                        HStack {
                                            
                                            CircularProgressView(progress: suggestion.probability, color: .blue, size: .small, showProgress: true)
                                                .frame(width: 45, height: 45)
                                                .padding()
                                            
                                            Text("\(suggestion.name)")
                                                .font(.title)
                                        }
                                        
                                        ScrollView(.horizontal) {
                                            HStack(spacing: 10) {
                                                if let images = similarImages[suggestion.name] {
                                                    ForEach(images, id: \.self) { image in
                                                        Image(uiImage: image)
                                                            .frame(width: 150, height: 150)
                                                            .cornerRadius(16)
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                }
                                .onTapGesture {
                                    print("Setting \(suggestion.name) identification to \(viewModel.name)")
                                    UserDefaults.standard.hasBeenIdentified(for: viewModel.name, with: suggestion.name)
                                    dismiss()
                                    grpcViewModel.updateExistingPlant(with: viewModel.id!, name: viewModel.name, lastWatered: nil, lastHealthCheck: nil, lastIdentification: Int64(Date().timeIntervalSince1970))
                                
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
                Text("Failed to load. Please try again.")
            }
        }
        .navigationTitle("Tap to Identify")
    }
}

//struct IdentificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        let response = IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: [IdentificationSuggestion(id: "0", name: "Suggestion #1", probability: 0.51, similarImages: []), IdentificationSuggestion(id: "1", name: "Suggestion #2", probability: 0.45, similarImages: []), IdentificationSuggestion(id: "2", name: "Suggestion #3", probability: 0.3, similarImages: [])])))
//        IdentificationView(images: [UIImage(systemName: "leaf")!], plantName: "Womp Womp", loadState: .loaded, identificationData: response)
//    }
//}