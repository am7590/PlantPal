//
//  EmptyGridView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI

// Generic error views
// Add to the enum to make more error responses

enum ErrorHandlingType {
    case noData, failedToLoad, noDataTrends
    
    var icon: String {
        switch self {
        case .noData:
            return "leaf.fill"
        case .failedToLoad:
            return "exclamationmark.square"
        case .noDataTrends:
            return "chart.bar.fill"
        }
    }
    
    var title: String {
        switch self {
        case .noData:
            return "No Plants"
        case .failedToLoad:
            return "Failed To Load"
        case .noDataTrends:
            return "No Trends"
        }
    }
    
    var subtitle: String {
        switch self {
        case .noData:
            return "Tap + to add a plant"
        case .failedToLoad:
            return "Womp Womp :("
        case .noDataTrends:
            return "Create a plant to track its health"
        }
    }
}

struct ErrorHandlingView: View {
    var listType: ErrorHandlingType
    
    var body: some View {
        
        List {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 8) {
                        Image(systemName: listType.icon)
                            .font(.largeTitle.bold())
                        
                        Text(listType.title)
                            .font(.title2.bold())
                        
                        Text(listType.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .frame(height: 500)
        }
    }
}

struct EmptyGridView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorHandlingView(listType: .noData)
    }
}
