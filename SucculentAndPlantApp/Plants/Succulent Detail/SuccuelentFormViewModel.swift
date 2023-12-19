//
//  NewSucculentViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import UIKit
import SwiftUI

// TODO: Refactor code from SucculentFormView

class SuccuelentFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var uiImage: [UIImage] = [] {
        didSet {
            // dismiss SuccuelentFormView
            print("Count: \(uiImage.count)")
        }
    }
    @Published var date = Date.now.stripTime()
    
    // Alerts
    @Published var waterAlertIsDispayed = false
    @Published var snoozeAlertIsDispayed = false
    
    @Published private var isImagePickerDisplay = false
    @Published var amount = 0
    
    @Published var imagePageSliderIndex = 0

    
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
}


extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}