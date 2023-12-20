//
//  SucculentListView+Helpers.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/19/23.
//

import SwiftUI
import CoreData
import _PhotosUI_SwiftUI
import BRYXBanner
import os

extension SucculentListView {
    // MARK: SucculentListView Toolbar
    struct CustomToolbar: ToolbarContent {
        @EnvironmentObject var viewModel: SucculentListViewModel
        
        var body: some ToolbarContent {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Create an item
                    viewModel.formState = .new([], GRPCViewModel())
                } label: {
                    Image(systemName: "plus")
                }
                .foregroundColor(.primary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Menu {
                        Button {
                            viewModel.isList = false
                        } label: {
                            Label("Grid", systemImage: "rectangle.grid.2x2")
                        }
                        
                        Button {
                            viewModel.isList = true
                        } label: {
                            Label("List", systemImage: "list.bullet")
                        }
                        
                    } label: {
                        Label("Group by", systemImage: viewModel.isList ? "list.bullet" : "rectangle.grid.2x2")
                    }
                } label: {
                    Label("", systemImage: "ellipsis.circle")
                }
                .foregroundColor(.primary)
            }
        }
    }
}

// MARK: Helpers
extension SucculentListView {
    func updateOrRestoreImage(_ codableImage: CodableImage?, _ items: FetchedResults<Item>) {
        if let codableImage {
            if let item = items.first(where: {$0.id == codableImage.id}) {
                // Update item
                updateInfo(myItem: item)
                viewModel.imageExists.toggle()
            } else {
                // New item
                restoreMyImage()
            }
        }
    }
    
    func updateItemsFromSearchQuery(_ value: String) {
        if value.isEmpty {
            items = Array(fetchedItems)
        } else {
            items = fetchedItems.filter({ $0.name?.contains(value) ?? false })
        }
    }
    
    func handleDeepLinkingToItem(url: String, grpcViewModel: GRPCViewModel) {
        Logger.plantPal.debug("\(#function) Handling url: \(url)")
        print("url: \(url)")
        
        let parsedURL = url
            .replacingOccurrences(of: "navStack\\", with: "", options: NSString.CompareOptions.literal, range: nil)
            .trimmingCharacters(in: .whitespaces)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if let foundItem = fetchedItems.first(where: { $0.nameText.trimmingCharacters(in: .whitespaces) == parsedURL || $0.nameText.trimmingCharacters(in: .whitespaces) == parsedURL.capitalized }) {
                viewModel.formState = .edit(foundItem, grpcViewModel)                
            }
        })
    }
    
    func restoreMyImage() {
        if let codableImage = shareService.codeableImage {
            let imgURL = URL.documentsDirectory.appending(path: "\(codableImage.id).jpg")
            if let data = try? Data(contentsOf: imgURL), let uiImage = UIImage(data: data) {
                let newImage = Item(context: viewModel.viewContext)
                newImage.image = [uiImage] // Store the restored image as a list containing a single image
                newImage.name = codableImage.name
                newImage.id = codableImage.id
                try? viewModel.viewContext.save()
                try? FileManager().removeItem(at: imgURL)
            }
        }
        shareService.codeableImage = nil
    }
    
    func updateInfo(myItem: Item) {
        if let codableImage = shareService.codeableImage {
            let imgURL = URL.documentsDirectory.appending(path: "\(codableImage.id).jpg")
            if let data = try? Data(contentsOf: imgURL), let uiImage = UIImage(data: data) {
                myItem.image = [uiImage] // Update the image as a list containing a single image
            }
            myItem.name = codableImage.name
            myItem.id = codableImage.id
            try? viewModel.viewContext.save()
            try? FileManager().removeItem(at: imgURL)
        }
        shareService.codeableImage = nil
    }
}


