//
//  NewSucculentViewModel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import UIKit
import SwiftUI

class SuccuelentFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var uiImage: [UIImage]?
    @Published var date = Date.now
    
    // Alerts
    @Published var waterAlertIsDispayed = false
    @Published var snoozeAlertIsDispayed = false
    
    @Published private var isImagePickerDisplay = false
    @Published var amount = 0
    
    let cameraHostingView = EmptyView()
        
    var id: String?
    
    var updating: Bool { id != nil }
    
    var dateHidden: Bool {
        date == Date.distantPast
    }
    
    init(_ uiImage: [UIImage]?) {
        self.uiImage = uiImage
    }
    
    var incomplete: Bool {
        name.isEmpty || uiImage == nil
    }
    
    var isItem = false
    
    var count = 0
    
    init(_ myItem: Item) {
        name = myItem.nameText
        id = myItem.imageID
        uiImage = myItem.uiImage
        date = myItem.timeStamp
        isItem = true
    }
}


//extension SucculentFormView {
//    struct CustomToolbar: ToolbarContent {
//        var body: some ToolbarContent {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Create") {
//                    let newImage = Item(context: moc)
//                    newImage.name = viewModel.name
//                    newImage.id = UUID().uuidString
//                    newImage.image = viewModel.uiImage
//                    try? moc.save()
//                    dismiss()
//                }
//                .buttonStyle(.bordered)
//            }
//            if viewModel.updating {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    HStack {
//                        Button {
//                            if let selectedImage = myImages.first(where: {$0.id == viewModel.id}) {
//                                moc.delete(selectedImage)
//                                try? moc.save()
//                            }
//                            dismiss()
//                        } label: {
//                            Image(systemName: "trash")
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(.red)
//                    }
//                }
//            }
//        }
//    }
//}
