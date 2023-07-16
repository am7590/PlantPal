import SwiftUI

struct HealthReportView: View {
    let image: UIImage
    @State var loadState: ReportLoadState = .loading
    @State var healthData: HealthAssessmentResponse?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                switch loadState {
                case .loading:
                    ProgressView("Loading Health Report...")
                        .onAppear {
                            fetchData(image: image)
                        }
                case .loaded:
                    if let healthData = healthData {
                        List {
                            Section {
                                Text("This plant is ")
                                    .font(.headline)
                                + Text("\(healthData.result.isHealthy.binary ? "HEALTHY" : "NOT HEALTHY")")
                                    .font(.headline)
                                    .foregroundColor(healthData.result.isHealthy.binary ? .green : .red)
                            }
                            
                            Section("Potential diseases") {
                                ForEach(healthData.result.disease.suggestions, id: \.id) { suggestion in
                                    NavigationLink(destination: DiseaseDetailView(suggestion: suggestion)) {
                                        VStack(alignment: .leading) {
                                            Text(suggestion.name.capitalized)
                                                .font(.headline)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    } else {
                        Text("Failed to load health data")
                    }
                case .failed:
                    Text("Failed to load. Please try again.")
                }
            }
            .navigationTitle("Health Report")
        }
    }
}

struct HealthReportView_Previews: PreviewProvider {
    static var previews: some View {
        let data = HealthAssessmentResponse(result: HealthResult(isHealthy: HealthPrediction(probability: 0.5421, binary: false, threshold: 0.5), disease: DiseaseSuggestion(suggestions: [Disease(id: "0", name: "Disease #1", probability: 0.243231, similarImages: [])])))
        HealthReportView(image: UIImage(systemName: "trash")!, loadState: .loaded, healthData: data)
    }
}

struct DiseaseDetailView: View {
    let suggestion: Disease
    
    var body: some View {
        List {
            Section(suggestion.name.capitalized) {
                
                Text("\(String(suggestion.probability*100))% Chance")
                    .font(.headline)
                
                VStack {
                    Text("Similar Images:")
                        .font(.headline)
                    
                    ForEach(suggestion.similarImages, id: \.id) { image in
                        RemoteImage(urlString: image.url)
                            .frame(width: 150, height: 150)
                            .cornerRadius(16)
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        
    }
}

