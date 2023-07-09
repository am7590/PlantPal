//
//  SucculentListViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI
import CoreData
import _PhotosUI_SwiftUI

class SucculentListViewModel: ObservableObject {
    @Published var formState: SucculentFormState?
    @Published var imageExists = false
    @Published var searchText = ""
    @Published var isList = false   // TODO: Hook up to UserDefaults
    @Published var wiggle = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150))]
    
    func handleImageChange(_ newImage: [UIImage]?) {
        if let newImage {
            formState = .new(newImage)
        }
    }
}

extension SucculentListView {
    struct CustomToolbar: ToolbarContent {
        @EnvironmentObject var viewModel: SucculentListViewModel
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.wiggle.toggle()
                } label: {
                    Text("Edit")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
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
                    Image(systemName: viewModel.isList ? "list.bullet" : "rectangle.grid.2x2")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.formState = .new(nil)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}


extension SucculentListView {
    func updateOrRestoreImage(_ codableImage: CodableImage?, _ items: FetchedResults<Item>) {
        if let codableImage {
            if let item = items.first(where: {$0.id == codableImage.id}) {
                // Update
                updateInfo(myItem: item)
                viewModel.imageExists.toggle()
            } else {
                // New
                restoreMyImage()
            }
        }
    }
    
    func updateItemsFromSearchQuery(_ value: String) {
        if viewModel.searchText != "" {
            fetchedItems.nsPredicate = NSPredicate(format: "name CONTAINS[c] %@", viewModel.searchText)
        } else {
            fetchedItems.nsPredicate = nil
        }
    }
    
    func handleDeepLinkingToItem(url: URL) {
        guard let scheme = url.scheme, scheme == "navStack" else { return }
        guard let item = url.host else { return }
        if let foundItem = fetchedItems.first(where: { $0.nameText.lowercased() == item }) {
            router.reset()
            viewModel.formState = .edit(foundItem)
        }
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
