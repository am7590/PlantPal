import SwiftUI

struct HealthReportView: View {
    let image: UIImage
    let plantName: String
    @State var loadState: ReportLoadState = .loading
    @State var healthData: HealthAssessmentResponse?
    @State var diseases = [Disease]()
    @State var similarImages = [String: [UIImage]]()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                switch loadState {
                case .loading:
                    ProgressView("Loading Health Report...")
                        .onAppear {
                            fetchData(for: plantName ,image: image)
                        }
                case .loaded:
                    if let healthData = healthData {
                        List {
                            GeometryReader { proxy in
                                let imageWidth = proxy.size.width-24
                            Section {
                                HStack {
                                    Spacer()
                                    VStack {
                                        CircularProgressView(progress: healthData.result.isHealthy.probability, color: healthData.color, size: .large, showProgress: true)
                                            .frame(width: imageWidth, height: imageWidth)
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
                                    NavigationLink(destination: DiseaseDetailView(suggestion: suggestion, color: healthData.color, similarImages: $similarImages)) {
                                        VStack(alignment: .leading) {
                                            Text(suggestion.name.capitalized)
                                                .font(.headline)
                                        }
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
        HealthReportView(image: UIImage(systemName: "trash")!, plantName: "Plant", loadState: .loaded, healthData: data)
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
