//
//  TrendsGraphDataItem.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/23/23.
//

import SwiftUI

struct TrendsGraphDataItem: Identifiable, Hashable {
    var id = UUID().uuidString
    var date: Date
    var value: Double
    var animate: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
