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
import _PhotosUI_SwiftUI
import os

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
    
    @Environment(\.managedObjectContext) var moc
            
    let cameraHostingView = EmptyView()
        
    var id: String?
    
    var updating: Bool { id != nil }
    
    var dateHidden: Bool {
        date == Date.distantPast
    }
    
    init(_ uiImage: [UIImage]) {
        self.uiImage = uiImage
    }

    func setName(with name: String) {
        self.name = name
    }
    
    var incomplete: Bool {
        name.isEmpty || uiImage.isEmpty
    }
    
    var isItem = false
    
    var count = 0
    
    init(_ myItem: Item) {
        name = myItem.nameText
        id = myItem.imageID
        uiImage = myItem.uiImage
        isItem = true
    }
    
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
}
