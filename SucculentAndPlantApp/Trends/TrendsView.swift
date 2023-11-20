//
//  TrendsView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 11/19/23.
//

import SwiftUI
import Charts

struct TrendsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack {
                        GraphView(sampleAnalytics: sample_analytics)
                            .padding(.top, 6)

                        HStack {

                            VStack(alignment: .leading) {
                                Text("Button").font(.title3).bold()
                                Text("Crassulaceae").italic()
                            }
                            
                            Spacer()

                            VStack {
                                CircularProgressView(progress: 0.49, color: .green, size: .small, showProgress: true)
                                    .frame(width: 42, height: 42)
                                Text("Health")
                                    .font(.caption.bold())
                            }
                            .padding()

                            Spacer()
                            
                            VStack {
                                CircularProgressView(progress: 0.04, color: .red, size: .small, showProgress: true)
                                    .frame(width: 42, height: 42)
                                Text("Down")
                                    .font(.caption.bold())
                            }
                            .padding()

                            
                            Spacer()
                        }
                    }
                }
                .redacted(reason: .placeholder)
                
                Section {
                    VStack {
                        GraphView(sampleAnalytics: sample_analytics_red)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Spikey Guy").font(.title3).bold()
                                Text("Bergeranthus concavus").italic()
                            }
                        
                            Spacer()

                            VStack {
                                CircularProgressView(progress: 0.04, color: .red, size: .small, showProgress: true)
                                    .frame(width: 42, height: 42)
                                Text("Health")
                                    .font(.caption.bold())
                            }
                            .padding()

                            Spacer()
                            
                            VStack {
                                CircularProgressView(progress: 0.03, color: .red, size: .small, showProgress: true)
                                    .frame(width: 42, height: 42)
                                Text("Down")
                                    .font(.caption.bold())
                            }
                            .padding()

                            
                            Spacer()
                        }
                    }
                }
                .redacted(reason: .placeholder)
            }
            .navigationTitle("Coming soon...")  //Health Trends
            .toolbar {
                TrendsToolbar()
            }
        }
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}

extension TrendsView {
    struct TrendsToolbar: ToolbarContent {
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        
                    } label: {
                        Image(systemName: ".")
                    }
                } label: {
                    Label("", systemImage: "")  // ellipsis.circle

                }
                .foregroundColor(.primary)

            }
        }
    }
}


struct GraphView: View {
    // Environment Scheme
    @Environment(\.colorScheme) var scheme
    // MARK: State Chart Data For Animation Changes
    @State var sampleAnalytics: [DataItem] = []

    // MARK: Gesture Properties
    @State var currentActiveItem: DataItem?
    @State var plotWidth: CGFloat = 0
    
    @State var isLineGraph: Bool = true
    var body: some View {
        NavigationStack{
            VStack{
                VStack(alignment: .leading, spacing: 12){
                    AnimatedChart()
                }
            }
            .onAppear {
                animateGraph(fromChange: true)
            }
        }
    }
    
    @ViewBuilder
    func AnimatedChart()-> some View{
        Chart {
            ForEach(sampleAnalytics) { item in
                if isLineGraph{
                    LineMark(
                        x: .value("Hour", item.date,unit: .hour),
                        y: .value("Views", item.animate ? item.value : 0)
                    )
                    .foregroundStyle(sampleAnalytics.first?.value ?? 0 > sampleAnalytics.last?.value ?? 0 ? Color.red.gradient : Color.green.gradient)
                    .interpolationMethod(.catmullRom)
                } else {
                    BarMark(
                        x: .value("Hour", item.date,unit: .hour),
                        y: .value("Views", item.animate ? item.value : 0)
                    )
                    .foregroundStyle(sampleAnalytics.first?.value ?? 0 > sampleAnalytics.last?.value ?? 0 ? Color.red.gradient : Color.green.gradient)
                }
                
                if isLineGraph {
                    AreaMark(
                        x: .value("Hour", item.date,unit: .hour),
                        y: .value("Views", item.animate ? item.value : 0)
                    )
                    .foregroundStyle(sampleAnalytics.first?.value ?? 0 > sampleAnalytics.last?.value ?? 0 ? Color.red.opacity(0.1).gradient : Color.green.opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }
            }
        }
        .frame(height: 200)
        .chartYScale(domain: 0...(105))
        .onAppear {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false){
        for (index, _) in sampleAnalytics.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05))  {
                withAnimation(fromChange ? .easeInOut(duration: 0.6) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
}



struct DataItem: Identifiable {
    var id = UUID().uuidString
    var date: Date
    var value: Double
    var animate: Bool = false
}

extension Date {
    func updateDay(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: value, to: self) ?? self
    }
}

var sample_analytics: [DataItem] = [
    DataItem(date: Date().updateDay(value: 0), value: 5),
    DataItem(date: Date().updateDay(value: 1), value: 10),
    DataItem(date: Date().updateDay(value: 2), value: 7),
    DataItem(date: Date().updateDay(value: 3), value: 12),
    DataItem(date: Date().updateDay(value: 4), value: 25),
    DataItem(date: Date().updateDay(value: 5), value: 34),
    DataItem(date: Date().updateDay(value: 6), value: 29),
    DataItem(date: Date().updateDay(value: 7), value: 39),
    DataItem(date: Date().updateDay(value: 8), value: 54),
    DataItem(date: Date().updateDay(value: 9), value: 49),
]

var sample_analytics_red: [DataItem] = [
    DataItem(date: Date().updateDay(value: 0), value: 54),
    DataItem(date: Date().updateDay(value: 1), value: 49),
    DataItem(date: Date().updateDay(value: 2), value: 39),
    DataItem(date: Date().updateDay(value: 3), value: 29),
    DataItem(date: Date().updateDay(value: 4), value: 34),
    DataItem(date: Date().updateDay(value: 5), value: 25),
    DataItem(date: Date().updateDay(value: 6), value: 12),
    DataItem(date: Date().updateDay(value: 7), value: 7),
    DataItem(date: Date().updateDay(value: 8), value: 10),
    DataItem(date: Date().updateDay(value: 9), value: 5),
]
