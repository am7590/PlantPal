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
                                HStack {
                                    Spacer()
                                    VStack {
                                        CircularProgressView(progress: healthData.result.isHealthy.probability, color: healthData.color, size: .large, showProgress: true)
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        
                                        Text("\(healthData.result.isHealthy.binary ? "HEALTHY" : "NOT HEALTHY")")
                                            .font(.title2.bold())
                                            .foregroundColor(healthData.result.isHealthy.binary ? .green : .red)
                                    }
                                    Spacer()
                                }
                            }
                            
                            Section("Potential diseases") {
                                ForEach(healthData.result.disease.suggestions, id: \.id) { suggestion in
                                    NavigationLink(destination: DiseaseDetailView(suggestion: suggestion, color: healthData.color)) {
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
    let color: Color
    
    var body: some View {
        List {
            Section() {
                
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
                    ForEach(suggestion.similarImages, id: \.id) { image in
                        RemoteImage(urlString: image.url)
                            .frame(width: 250, height: 250)
                            .cornerRadius(16)
                    }
                }
                
            }
        }
        .padding(.horizontal)
        
    }
}
