//
//  SucculentAndPlantAppApp.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI

@main
struct SucculentAndPlantAppApp: App {
    // Deep linking
    @StateObject var router = Router()
    
    // Persistence
    let persistenceController = PersistenceController.shared
    @StateObject var persistImage = PersistImageService()
    @StateObject var viewModel = SucculentListViewModel()
    @StateObject private var imagePicker = ImageSelector()
    
    var body: some Scene {
        WindowGroup {
            // ImageSliderContainer(imgArr: [UIImage(named: "succ1")!, UIImage(named: "succ2")!, UIImage(named: "succ3")!])
            SucculentListView()
                .environmentObject(viewModel)
                .environmentObject(router)
                .environmentObject(persistImage)
                .environmentObject(imagePicker)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    print("Document Directory", URL.documentsDirectory.path)
                }
                .onOpenURL { url in
                    persistImage.restore(url: url)
                }
        }
    }
}
