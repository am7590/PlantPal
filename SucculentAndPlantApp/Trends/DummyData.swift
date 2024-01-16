//
//  DummyData.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/16/24.
//

import Foundation

var sample_analytics: [TrendsGraphDataItem] = [
    TrendsGraphDataItem(date: Date(), value: 5),
    TrendsGraphDataItem(date: Date().updateDay(value: 7), value: 10),
    TrendsGraphDataItem(date: Date().updateDay(value: 14), value: 7),
    TrendsGraphDataItem(date: Date().updateDay(value: 21), value: 12),
    TrendsGraphDataItem(date: Date().updateDay(value: 28), value: 25),
    TrendsGraphDataItem(date: Date().updateDay(value: 35), value: 34),
    TrendsGraphDataItem(date: Date().updateDay(value: 42), value: 29),
    TrendsGraphDataItem(date: Date().updateDay(value: 49), value: 39),
    TrendsGraphDataItem(date: Date().updateDay(value: 56), value: 54),
    TrendsGraphDataItem(date: Date().updateDay(value: 63), value: 49),
]
