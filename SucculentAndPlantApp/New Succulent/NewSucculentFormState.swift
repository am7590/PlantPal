//
//  NewSucculentFormState.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI

enum NewSucculentFormState: Identifiable, View {
    case new(UIImage)
    case edit(Item)
    
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
        case .new(let image):
            return  NewSucculentFormView(viewModel: NewSucculentViewModel(image))
        case .edit(let item):
            return  NewSucculentFormView(viewModel: NewSucculentViewModel(item))
        }
    }
}
