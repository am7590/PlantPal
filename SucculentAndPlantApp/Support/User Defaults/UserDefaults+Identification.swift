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

    func getIdentification(for plant: String) -> String {
        return string(forKey: UserDefaultsKey.identification(for: plant)) ?? "Identify"
    }
    
    func getHealthScore(for plant: String) -> Double {
        return double(forKey: UserDefaultsKey.identification(for: plant)) 
    }
}
