//
//  Date+UpdateDay.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/16/24.
//

import Foundation

extension Date {
    func updateDay(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: value, to: self) ?? self
    }
}
