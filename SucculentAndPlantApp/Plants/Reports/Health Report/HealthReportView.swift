import SwiftUI

struct HealthReportView: View {
    @StateObject var viewModel: SuccuelentFormViewModel
    @StateObject var grpcViewModel: GRPCViewModel
    @State var loadState: ReportLoadState = .loading
    @State var healthData: HealthAssessmentResponse?
    @State var diseases = [Disease]()
    @State var similarImages = [String: [UIImage]]()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                let imageWidth = proxy.size.width - 24
                
                VStack {
                    switch loadState {
                    case .loading:
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView("Loading Health Report...")
                                    .onAppear {
                                        fetchData(for: viewModel.name, image: viewModel.uiImage.first!)
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                    case .loaded:
                        if let healthData {
                            List {
                                Section {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            CircularProgressView(progress: healthData.result.isHealthy.probability, color: healthData.color, size: .large, showProgress: true)
                                                .frame(width: imageWidth/3, height: imageWidth/3)
                                                .padding()

                                            Text("\(healthData.result.isHealthy.binary ? "HEALTHY" : "NOT HEALTHY")")
                                                .font(.title2.bold())
                                                .foregroundColor(healthData.result.isHealthy.binary ? .green : .red)
                                        }
                                        Spacer()
                                    }

                                    Section() {
                                        ForEach(healthData.result.disease.suggestions, id: \.id) { suggestion in
                                            NavigationLink(destination: DiseaseDetailView(suggestion: suggestion, color: healthData.color, similarImages: $similarImages)) {
                                                VStack(alignment: .leading) {
                                                    Text(suggestion.name.capitalized)
                                                        .font(.headline)
                                                }
                                            }
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(InsetGroupedListStyle())
                            .onAppear {
                                grpcViewModel.updateExistingPlant(with: viewModel.id!, name: viewModel.name, lastWatered: nil, lastHealthCheck: Int64(Date().timeIntervalSince1970), lastIdentification: nil, identifiedSpeciesName: nil)
                            }

                        } else {
                            ErrorHandlingView(listType: .failedToLoad)
                        }
                    case .failed:
                        ErrorHandlingView(listType: .failedToLoad)
                    }
                }
                .navigationTitle("Health Report")
            }
        }
    }
}

struct HealthReportView_Previews: PreviewProvider {
    static var previews: some View {
        let data = HealthAssessmentResponse(result: HealthResult(isPlant: HealthPrediction(probability: 40.0, binary: false, threshold: 1.0), isHealthy: HealthPrediction(probability: 0.5421, binary: false, threshold: 0.5), disease: DiseaseSuggestion(suggestions: [Disease(id: "0", name: "Disease #1", probability: 0.243231, similarImages: []), Disease(id: "1", name: "Disease #2", probability: 0.243231, similarImages: []), Disease(id: "2", name: "Disease #3", probability: 0.243231, similarImages: [])])))
        HealthReportView(viewModel: SuccuelentFormViewModel([]), grpcViewModel: GRPCViewModel(), loadState: .failed, healthData: data)
    }
}

struct DiseaseDetailView: View {
    let suggestion: Disease
    let color: Color
    @Binding var similarImages: [String: [UIImage]]
    
    var body: some View {
        GeometryReader { proxy in
            let imageWidth = proxy.size.width - 128
            List {
                Section {
                    
                    HStack {
                        CircularProgressView(progress: suggestion.probability, color: color, size: .small, showProgress: true)
                            .frame(width: 45, height: 45)
                            .padding()
                        
                        Text(suggestion.name.capitalized)
                            .font(.title3)
                    }
                }
                Section("Similar images") {
                    VStack(alignment: .center) {
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
            .padding(.horizontal)
        }
    }
}
