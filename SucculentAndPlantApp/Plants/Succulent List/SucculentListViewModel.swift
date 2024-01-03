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
    @Published var wiggle = false   // Depreciated (for now)
    
    @Environment(\.managedObjectContext) var viewContext
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150))]
    
    private let isListViewKey = "isListView"
    
    var isList: Bool {
        get {
            UserDefaults.standard.bool(forKey: isListViewKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isListViewKey)
        }
    }
    
    func handleImageChange(_ newImage: [UIImage]?, viewModel: GRPCViewModel) {
        if let newImage {
            formState = .new(newImage, viewModel)
        }
    }
}
