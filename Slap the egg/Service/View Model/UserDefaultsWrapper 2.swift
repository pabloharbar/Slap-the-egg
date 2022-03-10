//
//  UserDefaultsWrapper.swift
//  Slap the egg
//
//  Created by Pablo Penas on 02/02/22.
//

import Foundation

class UserDefaultsWrapper {
    static func setRecord(model: PlayerData) {
        let data = try? JSONEncoder().encode(model)
        UserDefaults.standard.set(data, forKey: "playerModel")
    }
    
    static func fetchRecord() -> PlayerData? {
        guard let data = UserDefaults.standard.data(forKey: "playerModel") else {
            return nil
        }
        
        let record = try? JSONDecoder().decode(PlayerData.self, from: data)
        return record
    }
    
    static func clearData(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
