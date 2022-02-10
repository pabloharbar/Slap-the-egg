//
//  Egg.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import SwiftUI

enum EggSizes {
    case small
    case medium
    case big
}

struct Egg {
    let animal: String
    let image: String
    let powerUp: [PowerUp]
    let cosmeticsType: Eggs
    let eggShellCost: Int
    let size: EggSizes
    
    init(animal: String, image: String, powerUp: [PowerUp], cosmeticsType: Eggs, eggShellCost: Int, size: EggSizes) {
        self.animal = animal
        self.image = image
        self.powerUp = powerUp
        self.cosmeticsType = cosmeticsType
        self.eggShellCost = eggShellCost
        self.size = size
    }
}
