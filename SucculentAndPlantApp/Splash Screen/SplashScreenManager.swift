//
//  LaunchScreenManager.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 8/27/23.
//

import Foundation

class SplashScreenManager: ObservableObject {
    
    @MainActor
    @Published
    private(set) var launchState: SplashScreenState = .start
    
    @MainActor
    func dismiss() {
        Task {
            launchState = .dismiss
            try? await Task.sleep(for: Duration.seconds(1))
            self.launchState = .finished
        }
    }
}
