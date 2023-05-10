//
//  NewSucculentViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import UIKit

class SuccuelentFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var uiImage: UIImage
    @Published var date = Date.now
        
    var id: String?
    
    var updating: Bool { id != nil }
    
    var dateHidden: Bool {
        date == Date.distantPast
    }
    
    init(_ uiImage: UIImage) {
        self.uiImage = uiImage
    }
    
    var incomplete: Bool {
        name.isEmpty || uiImage == UIImage(systemName: "photo")!
    }
    
    var isItem = false
    
    init(_ myItem: Item) {
        name = myItem.nameText
        id = myItem.imageID
        uiImage = myItem.uiImage
        date = myItem.timeStamp
        isItem = true
    }
}
