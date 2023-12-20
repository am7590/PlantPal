//
//  SucculentListViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI
import CoreData
import _PhotosUI_SwiftUI
import BRYXBanner

class SucculentListViewModel: ObservableObject {
    @Published var formState: SucculentFormState?
    @Published var imageExists = false
    @Published var searchText = ""
    @Published var isList = false   // TODO: Hook up to UserDefaults
    @Published var wiggle = false   // Depreciated (for now)
    
    @Environment(\.managedObjectContext) var viewContext
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150))]
    
    func handleImageChange(_ newImage: [UIImage]?, viewModel: GRPCViewModel) {
        if let newImage {
            formState = .new(newImage, viewModel)
        }
    }
}
