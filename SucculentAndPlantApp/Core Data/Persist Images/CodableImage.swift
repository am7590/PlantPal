//
//  CodableImage.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/19/23.
//

import Foundation

// Image saved to CoreData
struct CodableImage: Codable, Equatable {
    let dateTaken: Date
    let id: String
    let name: String
}
