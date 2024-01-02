//
//  SucculentAndPlantAppApp.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import BRYXBanner
import os

@main
struct SucculentAndPlantAppApp: App {    
    // Splash screen
    @StateObject private var splashScreenState = SplashScreenManager()
    
    // App Delegate (for APNs stuff)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // gRPC
    @StateObject var grpcViewModel = GRPCViewModel()
    
    // Deep linking
    @StateObject var router = Router()
    
    // Persistence
    let persistenceController = PersistenceController.shared
    @StateObject var persistImage = PersistImageService()
    
    // ViewModels
    @StateObject var viewModel = SucculentListViewModel()
    @StateObject private var imagePicker = ImageSelector()
    
    var body: some Scene {
        WindowGroup {
            Group {
                // Show splash screen
                if splashScreenState.launchState != .finished {
                    SplashScreenView()
                        .task {
                            // Wait for CoreData and UserDefaults to be accessible
                            // Displays splash screen until data is avaibale
                            if UIApplication.shared.isProtectedDataAvailable {
                                self.splashScreenState.dismiss()
                                appDelegate.payloadURL = nil  // Trigger deep link (if there is one)
                            }
                        }
                } else {
                    // Show TabView with SucculentListView and TrendsView
                    TabView {
                        SucculentListView()
                            .environmentObject(grpcViewModel)
                            .environmentObject(viewModel)
                            .environmentObject(router)
                            .environmentObject(persistImage)
                            .environmentObject(imagePicker)
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .onOpenURL { url in
                                handleOnOpenURL(with: url)
                            }
                            .tabItem {
                                Label("Plants", systemImage: "leaf.fill")
                            }
                        
                        TrendsView()
                        // TODO: Add badge when trends update?
                            .tabItem {
                                Label("Trends", systemImage: "chart.bar.fill")
                            }
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .environmentObject(grpcViewModel)
                    }
                    .tint(.primary)
                }
            }
            .environmentObject(splashScreenState)
        }
    }
    
    private func handleOnOpenURL(with url: URL) {
        Logger.plantPal.info("\(#function) opening url: \(url)")
        
        persistImage.restore(url: url)
    }
}

