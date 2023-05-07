//
//  SucculentAndPlantAppApp.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI

@main
struct SucculentAndPlantAppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var persistImage = PersistImageService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistImage)
                .onAppear {
                    print("Document Directory", URL.documentsDirectory.path)
                }
                .onOpenURL { url in
                    persistImage.restore(url: url)
                }
        }
    }
}
