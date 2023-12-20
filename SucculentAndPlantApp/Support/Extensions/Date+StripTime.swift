//
//  Date+StripTime.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/19/23.
//

import Foundation

extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}
