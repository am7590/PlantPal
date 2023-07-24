//
//  EmptyGridView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI

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
            return "Tap the + button to create a new plant or succulent"
        case .failedToLoad:
            return "Womp Womp :("
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
