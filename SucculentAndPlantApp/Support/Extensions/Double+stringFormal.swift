//
//  Double+stringFormal.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 11/19/23.
//

import Foundation

extension Double {
    var stringFormat: String {
        if self >= 10000 && self < 999999 {
            return String(format: "%.1fK",locale: Locale.current, self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999 {
            return String(format: "%.1fM",locale: Locale.current, self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f",locale: Locale.current, self)
    }
}
