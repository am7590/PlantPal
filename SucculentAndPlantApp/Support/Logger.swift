//
//  Logger.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/19/23.
//

import OSLog

// View logs in Console app
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let plantPal = Logger(subsystem: subsystem, category: "plantPal")
    static let networking = Logger(subsystem: subsystem, category: "networking")
    
    // TODO
//    static let widgets = Logger(subsystem: subsystem, category: "widgets")
}

