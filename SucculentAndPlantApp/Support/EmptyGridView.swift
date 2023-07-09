//
//  EmptyGridView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI

enum EmptyListType {
    case allSucculents
}

struct EmptyGridView: View {
    var listType: EmptyListType
    
    var body: some View {
        switch listType {
        case .allSucculents:
            VStack(alignment: .center, spacing: 8) {
                Spacer()
              
                Image(systemName: "leaf.fill")
                    .font(.largeTitle.bold())
               
                Text("No Plants")
                    .font(.title2.bold())
                
                Text("Tap the + button to create a new plant or succulent")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
               
                Spacer()
                Spacer()
            }
        }
    }
}

struct EmptyGridView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyGridView(listType: .allSucculents)
    }
}
