//
//  UIScrollView+ClipToBounds.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/9/23.
//

import SwiftUI

// Overrides clipsToBounds so item shadow is not clipped by the ScrollView
// Reference: https://www.bam.tech/en/article/swiftui-why-are-my-shadows-clipped
private extension UIScrollView {
    override open var clipsToBounds: Bool {
        get { false }
        set {}
    }
}
