//
//  LaunchScreenManager.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 8/27/23.
//

import Foundation
import os

class SplashScreenManager: ObservableObject {
    
    @MainActor
    @Published
    private(set) var launchState: SplashScreenState = .start


    @MainActor
    func dismiss() {
        Task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.90) {
                self.launchState = .finished
                Logger.plantPal.debug("Splash screen is being dismissed")
            }
        }
    }
}
