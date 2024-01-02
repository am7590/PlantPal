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
    case noData, failedToLoad
    
    var icon: String {
        switch self {
        case .noData:
            return "leaf.fill"
        case .failedToLoad:
            return "exclamationmark.square"
        }
    }
    
    var title: String {
        switch self {
        case .noData:
            return "No Plants"
        case .failedToLoad:
            return "Failed To Load"
        }
    }
    
    var subtitle: String {
        switch self {
        case .noData:
            return "Tap + to add a plant and start tracking its health"
        case .failedToLoad:
            return "Reach out to Alek if this persists"
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
