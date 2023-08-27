//
//  SucculentAndPlantAppApp.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI

@main
struct SucculentAndPlantAppApp: App {
    // Splash screen
    @StateObject private var splashScreenState = SplashScreenManager()
    
    // App Delegate (APNS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Deep linking
    @StateObject var router = Router()
    
    // Persistence
    let persistenceController = PersistenceController.shared
    @StateObject var persistImage = PersistImageService()
    @StateObject var viewModel = SucculentListViewModel()
    @StateObject private var imagePicker = ImageSelector()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if splashScreenState.launchState != .finished {
                    SplashScreenView()
                        .task {
                            // Wait for CoreData and UserDefaults to be accessible
                            if UIApplication.shared.isProtectedDataAvailable {
                                self.splashScreenState.dismiss()
                            }
                        }
                } else {
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
            .environmentObject(splashScreenState)
        }
    }
}
