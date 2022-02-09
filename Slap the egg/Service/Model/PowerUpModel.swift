//
//  PowerUp.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import Foundation

struct PowerUp: Hashable {
    let name: String
    let description: String
    let powerUpType: PowerUpType
    let value: Int
    let eggShellCost: Int
    let shopAvailable: Bool
    
    init(name: String, description: String, type: PowerUpType, value: Int, eggShellCost: Int = 0, shopAvailable: Bool = false) {
        self.name = name
        self.description = description
        self.powerUpType = type
        self.value = value
        self.eggShellCost = eggShellCost
        self.shopAvailable = shopAvailable
    }
}

enum PowerUpType {
    case multiplicate
    case revive
}
