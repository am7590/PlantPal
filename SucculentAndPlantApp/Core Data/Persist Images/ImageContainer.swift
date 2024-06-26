//
//  ImageContainer.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import Foundation
import CoreData
import os

class ImagesContainer {
    let persistentCloudKitContainer: NSPersistentCloudKitContainer
    
    init() {
        UIImageTransformer.register()
        persistentCloudKitContainer = NSPersistentCloudKitContainer(name: "SucculentAndPlantApp")
        guard let path = persistentCloudKitContainer
            .persistentStoreDescriptions
            .first?
            .url?
            .path else {
            fatalError("Could not find peresistent container")
        }

        guard let description = persistentCloudKitContainer.persistentStoreDescriptions.first else {
            fatalError("Failed to initialize persistent container")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        persistentCloudKitContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentCloudKitContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentCloudKitContainer.loadPersistentStores { _, error in
            if let error {
                Logger.plantPal.error("\(#function) \(error.localizedDescription)")
            }
        }
    }
}
