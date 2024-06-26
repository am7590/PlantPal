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

// MARK: SucculentListView Toolbar
extension SucculentListView {
    struct CustomToolbar: ToolbarContent {
        @EnvironmentObject var viewModel: SucculentListViewModel
        
        var body: some ToolbarContent {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Create an item
                    viewModel.formState = .new([], GRPCViewModel(), PersistenceController.shared.container.viewContext)
                } label: {
                    Image(systemName: "plus.app")
                        .bold()
                }
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
    
    // Triggers refresh from CoreData
    func refreshFetchedItems() {
        items = Array(fetchedItems)
    }
    
    func updateItemsFromSearchQuery(_ value: String) {
        if value.isEmpty {
            items = Array(fetchedItems)
        } else {
            items = fetchedItems.filter({ $0.name?.contains(value) ?? false })
        }
    }
    
    func handleDeepLinkingToItem(url: String, grpcViewModel: GRPCViewModel, context: NSManagedObjectContext) {
        Logger.plantPal.debug("\(#function) Handling url: \(url)")
        print("url: \(url)")
        
        let parsedURL = url
            .replacingOccurrences(of: "navStack\\", with: "", options: NSString.CompareOptions.literal, range: nil)
            .trimmingCharacters(in: .whitespaces)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if let foundItem = fetchedItems.first(where: { $0.nameText.trimmingCharacters(in: .whitespaces) == parsedURL || $0.nameText.trimmingCharacters(in: .whitespaces) == parsedURL.capitalized }) {
                viewModel.formState = .edit(foundItem, grpcViewModel, context)
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
    
    func saveiCloudUUID(notification: NotificationCenter.Publisher.Output) {
        print("User's iCloud UUID", notification)
        
        if let uuid = notification.object as? String {
            Task {
                let parsedUuid = uuid.replacingOccurrences(of: String("_"), with: "")
                GRPCManager.shared.userDeviceToken = parsedUuid  // TODO: This should be depreciated
                GRPCManager.shared.useriCloudToken = parsedUuid
                try await grpcViewModel.registerOrGetUser(uuid: parsedUuid)
            }
        }
    }
}

// MARK: Form Toolbar

struct SucculentListViewToolbar: ToolbarContent {
    @ObservedObject var viewModel: SuccuelentFormViewModel
    var grpcViewModel: GRPCViewModel
    var myImages: FetchedResults<Item>
    var dismiss: () -> Void
    
    @ToolbarContentBuilder
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(Color(uiColor: .systemOrange))
        }
        
        if viewModel.updating {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        viewModel.createItem(myImages: myImages)
                        grpcViewModel.removePlantEntry(with: viewModel.id ?? "0")
                        dismiss()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .tint(.primary)
                }
            }
        } else {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    viewModel.snoozeAlertIsDispayed.toggle()
                    let newItem = viewModel.updateItem(myImages: myImages)
                    dismiss()
                    grpcViewModel.createNewPlant(identifier: newItem.id ?? "69420", name: viewModel.name)
                    UserDefaults.standard.hasGeneratedUUID(for: viewModel.name, with: newItem.id!)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .systemGreen))
                .disabled(viewModel.incomplete)
            }
        }
    }
}
