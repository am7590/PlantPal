//
//  NewSucculentFormState.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI

enum SucculentFormState: Identifiable, View {
    case new([UIImage], GRPCViewModel) // Create a plant
    case edit(Item, GRPCViewModel)     // Edit/Detail view
    
    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit:
            return "edit"
        }
    }
    
    var body: some View {
        switch self {
        case .new(let image, let viewModel):
            return SucculentFormView(item: nil, viewModel: SuccuelentFormViewModel(image), grpcViewModel: viewModel)
            
        case .edit(let item, let viewModel):
            return SucculentFormView(item: item, viewModel: SuccuelentFormViewModel(item), grpcViewModel: viewModel)
        }
    }
}
