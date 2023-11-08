//
//  SucculentAndPlantAppApp.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import BRYXBanner


@main
struct SucculentAndPlantAppApp: App {    
    // Splash screen
    @StateObject private var splashScreenState = SplashScreenManager()
    
    // App Delegate (APNS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // gRPC
    @StateObject var grpcViewModel = GRPCViewModel()
    
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
                                appDelegate.payloadURL = nil  // Trigger deep link
                            }
                        }
                } else {
                    SucculentListView()
                        .environmentObject(grpcViewModel)
                        .environmentObject(viewModel)
                        .environmentObject(router)
                        .environmentObject(persistImage)
                        .environmentObject(imagePicker)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .onAppear {
                            print("Document Directory", URL.documentsDirectory.path)
                        }
                        .onOpenURL { url in
                            print("%%%$%% \(url)")
                            
                            let banner = Banner(title: "open url", subtitle: "\(url)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
                            banner.dismissesOnTap = true
                            banner.show(duration: 5.0)
                            
                            persistImage.restore(url: url)
                        }
                }
            }
            .environmentObject(splashScreenState)
        }
    }
}
