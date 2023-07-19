//
//  IdentificationView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

struct IdentificationView: View {
    let image: UIImage
    @State var loadState: ReportLoadState = .loading
    @State var identificationData: IdentificationResponse?
    
    var body: some View {
        VStack {
            switch loadState {
            case .loading:
                ProgressView("Identifying Plant...")
                    .onAppear {
                        fetchData(image: image)
                    }
            case .loaded:
                if let identificationData = identificationData {
                    List {
                        Section {
                            if let suggestions = identificationData.result?.classification?.suggestions {
                                ForEach(suggestions, id: \.id) { suggestion in
                                    VStack(alignment: .leading, spacing: 4) {
                                        
                                        HStack {
                                            
                                            CircularProgressView(progress: suggestion.probability, color: .blue, size: .small, showProgress: true)
                                                .frame(width: 45, height: 45)
                                                .padding()
                                            
                                            Text("\(suggestion.name)")
                                                .font(.title)
                                        }
                                        
                                        
                                        
                                        
                                        if let similarImages = suggestion.similarImages {
                                            ScrollView(.horizontal) {
                                                HStack(spacing: 10) {
                                                    ForEach(similarImages, id: \.id) { image in
                                                        RemoteImage(urlString: image.url)
                                                            .frame(width: 150, height: 150)
                                                            .cornerRadius(16)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("Plant Not Identified")
                                    .font(.headline)
                            }
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
        .navigationTitle("Plant Identification")
    }
}

struct IdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        let response = IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: [IdentificationSuggestion(id: "0", name: "Suggestion #1", probability: 0.24, similarImages: [])])))
        IdentificationView(image: UIImage(systemName: "leaf")!, loadState: .loaded, identificationData: response)
    }
}
