//
//  LaunchStateManager.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 2/3/24.
//

import Foundation

enum LaunchState {
    case firstLaunchEver
    case newBuildLaunch
    case normalLaunch
}

class LaunchStateManager {
    static let shared = LaunchStateManager()

    private let lastLaunchedBuildKey = "lastLaunchedBuild"

    func checkLaunchState() -> (() -> LaunchState) {
        guard let currentBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { fatalError("Unable to retrieve current build version") }

        let defaults = UserDefaults.standard
        let lastLaunchedBuild = defaults.string(forKey: lastLaunchedBuildKey)

        let launchState: LaunchState
        if lastLaunchedBuild == nil {
            launchState = .firstLaunchEver
        } else if lastLaunchedBuild != currentBuild {
            launchState = .newBuildLaunch
        } else {
            launchState = .normalLaunch
        }

        defaults.set(currentBuild, forKey: lastLaunchedBuildKey)

        return { launchState }
    }
}
