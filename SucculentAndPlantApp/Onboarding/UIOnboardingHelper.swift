//
//  UIOnboardingHelper.swift
//  UIOnboarding Demo SPM
//
//  Created by Lukman Aščić on 17.02.22.
//

import UIKit
import UIOnboarding
import SwiftUI

struct UIOnboardingHelper {
    static func setUpIcon() -> UIImage {
        return Bundle.main.appIcon ?? .init(named: "IconImage")!
    }
    
    // First Title Line
    // Welcome Text
    static func setUpFirstTitleLine() -> NSMutableAttributedString {
        .init(string: "Thank you for beta testing", attributes: [.foregroundColor: UIColor.label]) // Welcome to
    }
    
    // Second Title Line
    // App Name
    static func setUpSecondTitleLine() -> NSMutableAttributedString {
        .init(string: Bundle.main.displayName ?? "leaf", attributes: [
            .foregroundColor: Color(uiColor: .systemGreen)
        ])
    }

    static func setUpFeatures() -> Array<UIOnboardingFeature> {
        return .init([
            .init(icon: UIImage(systemName: "exclamationmark.triangle")!,
                  title: "Reporting issues",
                  description: "Take a screenshot and share it with me or email am7590@rit.edu to report bugs"),
            .init(icon: UIImage(systemName: "leaf")!,
                  title: "Keep your plants alive",
                  description: "Plantpal reminds you to water your plants"),
            .init(icon: UIImage(systemName: "chart.line.uptrend.xyaxis")!,
                  title: "Plant health reports",
                  description: "Track how your plants health is improving over time")
        ])
    }
    
    static func setUpNotice() -> UIOnboardingTextViewConfiguration {
        return .init(icon: UIImage(named: ""),
                     text: "",
                     linkTitle: "",
                     link: "",
                     tint: .systemGreen)
    }
    
    static func setUpButton() -> UIOnboardingButtonConfiguration {
        return .init(title: "Continue",
                     backgroundColor: .systemGreen)
    }
}

extension UIOnboardingViewConfiguration {
    static func setUp() -> UIOnboardingViewConfiguration {
        return .init(appIcon: UIOnboardingHelper.setUpIcon(),
                     firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
                     secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
                     features: UIOnboardingHelper.setUpFeatures(),
                     textViewConfiguration: UIOnboardingHelper.setUpNotice(),
                     buttonConfiguration: UIOnboardingHelper.setUpButton())
    }
}
