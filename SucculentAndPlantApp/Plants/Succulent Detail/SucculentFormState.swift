//
//  NewSucculentFormState.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import CoreData

enum SucculentFormState: Identifiable, View {
    case new([UIImage], GRPCViewModel, NSManagedObjectContext) // Create a plant
    case edit(Item, GRPCViewModel, NSManagedObjectContext)     // Edit/Detail view
    
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
        case .new(let image, let viewModel, let context):
            return SucculentFormView(item: nil, viewModel: SuccuelentFormViewModel(image, context: context), grpcViewModel: viewModel)
            
        case .edit(let item, let viewModel, let context):
            return SucculentFormView(item: item, viewModel: SuccuelentFormViewModel(item, context: context), grpcViewModel: viewModel)
        }
    }
}
