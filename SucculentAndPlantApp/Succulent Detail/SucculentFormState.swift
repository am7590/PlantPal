//
//  NewSucculentFormState.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI

enum SucculentFormState: Identifiable, View {
    case new([UIImage], GRPCViewModel)
    case edit(Item, GRPCViewModel)
    
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
            return SucculentFormView(viewModel: SuccuelentFormViewModel(image), grpcViewModel: viewModel)
            
        case .edit(let item, let viewModel):
            return SucculentFormView(viewModel: SuccuelentFormViewModel(item), grpcViewModel: viewModel)
        }
    }
}
