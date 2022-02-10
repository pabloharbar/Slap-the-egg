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
    let image: String
    
    init(name: String, description: String, type: PowerUpType, value: Int, eggShellCost: Int = 0, shopAvailable: Bool = false, image: String = "") {
        self.name = name
        self.description = description
        self.powerUpType = type
        self.value = value
        self.eggShellCost = eggShellCost
        self.shopAvailable = shopAvailable
        self.image = image
    }
}

enum PowerUpType: Codable {
    case multiplicate2x
    case multiplicate3x
    case multiplicate5x
    case revive1
    case revive2
}
