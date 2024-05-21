//
//  SucculentFormView+Helpers.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/18/24.
//

import SwiftUI
import CoreData

extension SucculentFormView {
    
    func refreshUserDefaultsIfNeccesary() {
        if !viewModel.name.isEmpty {
            refreshUserDefaults()
        }
    }
    
    func appendNewImageIfNeccesary(image newImage: UIImage?) {
        if let newImage {
            viewModel.uiImage.append(newImage)
        }
    }
    
    
}


// MARK: Updating toolbar
extension SucculentFormView {
    struct UpdatingToolbar: ToolbarContent {
        @ObservedObject var viewModel: SuccuelentFormViewModel
        var updateItemCallback: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    updateItemCallback()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .systemGreen))
                .disabled(viewModel.incomplete)
            }
        }
    }
}

// MARK: Create plant toolbar
extension SucculentFormView {
    struct CreateToolbar: ToolbarContent {
        var createItemCallback: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        createItemCallback()
                        
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .tint(.primary)
                }
            }
        }
    }
}
