//
//  GraphViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/23/23.
//

import SwiftUI

class GraphViewModel: ObservableObject {
    @Published var dataItems: [TrendsGraphDataItem] {
        didSet {
            
            print("dataItems \(oldValue.difference(from: dataItems))")
        }
    }
    @Published var isLoading: Bool = true {
        didSet {
            print("\n\nisLoading: \(isLoading)\n\n")
        }
    }
    
    init(dataItems: [TrendsGraphDataItem]) {
        self.dataItems = dataItems
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false
        }
    }
}
