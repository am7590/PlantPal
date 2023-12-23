//
//  GraphView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/23/23.
//

import SwiftUI
import Charts

struct GraphView: View {
    @ObservedObject var viewModel: GraphViewModel
    @State var isLineGraph: Bool = true
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                AnimatedChart(dataItems: viewModel.dataItems)
            } else {
                AnimatedChart(dataItems: viewModel.dataItems)
            }
        }
    }
    
    @ViewBuilder
    func AnimatedChart(dataItems: [TrendsGraphDataItem])-> some View {
        Chart {
            ForEach(dataItems) { item in
                if isLineGraph {
                    LineMark(
                        x: .value("Hour", item.date,unit: .hour),
                        y: .value("Views", item.animate ? item.value : 0)
                    )
                    .foregroundStyle(dataItems.first?.value ?? 0 > dataItems.last?.value ?? 0 ? Color.red.gradient : Color.green.gradient)
                    .interpolationMethod(.catmullRom)
                } else {
                    BarMark(
                        x: .value("Hour", item.date,unit: .hour),
                        y: .value("Views", item.animate ? item.value : 0)
                    )
                    .foregroundStyle(dataItems.first?.value ?? 0 > dataItems.last?.value ?? 0 ? Color.red.gradient : Color.green.gradient)
                }
                
                if isLineGraph {
                    AreaMark(
                        x: .value("Hour", item.date,unit: .hour),
                        y: .value("Views", item.animate ? item.value : 0)
                    )
                    .foregroundStyle(dataItems.first?.value ?? 0 > dataItems.last?.value ?? 0 ? Color.red.opacity(0.1).gradient : Color.green.opacity(0.1).gradient)
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
    
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in viewModel.dataItems.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.01))  {
                withAnimation(fromChange ? .easeInOut(duration: 0.6) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    viewModel.dataItems[index].animate = true
                }
            }
        }
    }
}


struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(viewModel: GraphViewModel(dataItems: []))
    }
}
