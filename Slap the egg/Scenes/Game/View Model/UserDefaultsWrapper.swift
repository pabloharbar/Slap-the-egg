//
//  UserDefaultsWrapper.swift
//  Slap the egg
//
//  Created by Pablo Penas on 02/02/22.
//

import Foundation

class UserDefaultsWrapper {
    static func setRecord(model: Int) {
        let data = try? JSONEncoder().encode(model)
        UserDefaults.standard.set(data, forKey: "record")
    }
    
    static func fetchRecord() -> Int? {
        guard let data = UserDefaults.standard.data(forKey: "record") else {
            return nil
        }
        
        let record = try? JSONDecoder().decode(Int.self, from: data)
        return record
    }
    
    static func clearData(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
