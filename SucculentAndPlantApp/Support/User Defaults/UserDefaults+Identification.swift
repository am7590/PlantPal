//
//  UserDefaults+Identification.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/20/23.
//

import Foundation

extension UserDefaults {

    public enum UserDefaultsKey {
        static func identification(for plant: String) -> String {
            return "has_seen_app_introduction:\(plant)"
        }
        
        static func wateringIdentification(for plant: String) -> String {
            return "has_watered:\(plant)"
        }
        
        static func uniqueIdentification(for plant: String) -> String {
            return "uuid:\(plant)"
        }
        
        static func dateIdentification(for plant: String) -> String {
            return "date:\(plant)"
        }
    }

    var identification: String {
        set {
            set(newValue, forKey: UserDefaultsKey.identification(for: "Plant1"))
        }
        get {
            return string(forKey: UserDefaultsKey.identification(for: "Plant1")) ?? "Identify"
        }
    }

    func hasBeenIdentified(for plant: String, with additionalInfo: String) {
        let key = UserDefaultsKey.identification(for: plant)
        let newValue = additionalInfo
        set(newValue, forKey: key)
    }
    
    func hasBeenHealthScored(for plant: String, with additionalInfo: Double) {
        let key = UserDefaultsKey.identification(for: plant)
        let newValue = additionalInfo
        set(newValue, forKey: key)
    }
    
    func hasBeenWatered(for plant: String, with additionalInfo: Date) {
        let key = UserDefaultsKey.dateIdentification(for: plant)
        let newValue = additionalInfo
        set(newValue, forKey: key)
    }
    
    func hasChangedInterval(for plant: String, with additionalInfo: Int) {
        let key = UserDefaultsKey.wateringIdentification(for: plant)
        let newValue = additionalInfo
        set(newValue, forKey: key+"i")
    }
    
    func hasGeneratedUUID(for plant: String, with additionalInfo: String) {
        let key = UserDefaultsKey.uniqueIdentification(for: plant)
        let newValue = additionalInfo
        set(newValue, forKey: key)
    }

    func getIdentification(for plant: String) -> String {
        return string(forKey: UserDefaultsKey.identification(for: plant)) ?? "Identify"
    }
    
    func getHealthScore(for plant: String) -> Double {
        return double(forKey: UserDefaultsKey.identification(for: plant)) 
    }
    
    func getLastWatered(for plant: String) -> Date? {
        return value(forKey: UserDefaultsKey.dateIdentification(for: plant)) as? Date
    }
    
    func getWateringInterval(for plant: String) -> Int {
        return integer(forKey: UserDefaultsKey.wateringIdentification(for: plant)+"i")
    }
    
    func getUUID(for plant: String) -> String? {
        return string(forKey: UserDefaultsKey.uniqueIdentification(for: plant))
    }
}
