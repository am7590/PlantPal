//
//  NewSucculentViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import UIKit
import SwiftUI
import PlantPalCore
import CoreData
import os
import _PhotosUI_SwiftUI

class SuccuelentFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var uiImage: [UIImage] = []
    @Published var date = Date.now.stripTime()
    
    // Alerts for when buttons are tapped
    @Published var waterAlertIsDispayed = false
    @Published var snoozeAlertIsDispayed = false
    
    @Published private var isImagePickerDisplay = false
    @Published var amount = 0
    @Published var imagePageSliderIndex = 0
    
    @Published var showCameraSheet = false
    @Published var showPhotoSelectionSheet = false
    @Published var showHealthCheckSheet = false
    @Published var navLinkValue = ""
    
    @State var newImageSelection: PhotosPickerItem?
    
    var moc: NSManagedObjectContext
    
    let cameraHostingView = EmptyView()
    
    var id: String?
    
    var isItem = false
    
    var count = 0
    
    init(_ uiImage: [UIImage], context: NSManagedObjectContext) {
        self.uiImage = uiImage
        self.moc = context
    }
    
    init(_ myItem: Item, context: NSManagedObjectContext) {
        name = myItem.nameText
        id = myItem.imageID
        uiImage = myItem.uiImage
        self.moc = context
        isItem = true
    }
    
    var dateHidden: Bool {
        date == Date.distantPast
    }
    
    
    var incomplete: Bool {
        name.isEmpty || uiImage.isEmpty
    }
    
    var updating: Bool { id != nil }

    func setName(with name: String) {
        self.name = name
    }
}
    
extension SuccuelentFormViewModel {
    
    func updateItem(myImages: FetchedResults<Item>) -> Item {
        snoozeAlertIsDispayed.toggle()
        
        // Create plant
        let newItem = Item(context: moc)
        newItem.name = name
        newItem.id = UUID().uuidString
        newItem.image = uiImage
        newItem.position = NSNumber(value: myImages.count)
        newItem.timestamp = date
        newItem.interval = (amount) as NSNumber
        try? moc.save()
        
        UserDefaults.standard.hasGeneratedUUID(for: name, with: newItem.id!)
        return newItem
    }
    
    func createItem(myImages: FetchedResults<Item>) {
        if let selectedImage = myImages.first(where: { $0.id == id }) {
            moc.delete(selectedImage)
            try? moc.save()
        }
    }
    
    func handleNewImageSelection(newItem: PhotosPickerItem?) {
        Task {
            do {
                if let data = try await newItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.uiImage.append(uiImage)
//                        updateImage(item: myImages.first(where: {$0.id == id}))
                    }
                }
            } catch {
                Logger.plantPal.error("\(#function) \(error.localizedDescription)")
            }
        }
    }
    
    func updateImage(item: Item?) {
        if let id, let selectedImage = item {
            selectedImage.name = name
            selectedImage.image = uiImage
            if moc.hasChanges {
                try? moc.save()
            }
            withAnimation {
                imagePageSliderIndex = uiImage.count-1
            }
        }
    }
    
    func updateExistingPlant() -> Date? {
        if let id = UserDefaults.standard.getUUID(for: name), !name.isEmpty, date != Date.now.stripTime() {
            let interval = date.timeIntervalSince1970 * 86400
//            grpcViewModel.updateExistingPlant(with: id, name: name, lastWatered: Int64(interval), lastHealthCheck: nil, lastIdentification: nil, identifiedSpeciesName: nil, newHealthProbability: nil)

//            item?.timestamp = date
            try? moc.save()
            return date
        }
        
        return nil
    }
}
