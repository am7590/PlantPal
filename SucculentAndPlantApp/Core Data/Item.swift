//
//  Item.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import Foundation
import CoreData
import UIKit

// TODO: Rename to something more specific?
@objc(Item)
public class Item: NSManagedObject {
    
}

extension Item: Identifiable {
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var interval: NSNumber?
    @NSManaged public var image: [UIImage]?
    @NSManaged public var position: NSNumber?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }
}

extension Item {
    var nameText: String {
        name ?? ""
    }
    
    var imageID: String {
        id ?? ""
    }
    
    var timeStamp: Date {
        timestamp ?? Date.now
    }
    
    var waterInterval: Int {
        Int(interval ?? 0)
    }
    
    var uiImage: [UIImage] {
        image ?? [UIImage(systemName: "exclamationmark.triangle.fill")!]
    }
    
    var gridPosition: Int {
        Int(truncating: position ?? 0)
    }
}
