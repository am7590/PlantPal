//
//  TrendsViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/16/24.
//

import SwiftUI
import os

class TrendsViewModel: ObservableObject {
    @Published var data: [[Item]]
    @Published var isLoading: Bool = true
    
    init(data: [[Item]]) {
        self.data = data
        
        // Temporary
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false
        }
    }
    
    public func addData(data: [Item]) {
        self.data.append(data)
    }
}
