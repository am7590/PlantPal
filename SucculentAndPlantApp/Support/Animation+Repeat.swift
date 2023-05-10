//
//  Animation+Repeat.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
