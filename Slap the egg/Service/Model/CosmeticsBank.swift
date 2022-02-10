//
//  CosmeticsBank.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import Foundation

struct PowerUpsAvailable {
    static let powerUps: [PowerUp] = [
        PowerUp(name: "Double Points", description: "For one try, your egg shell earnings are doubled", type: .multiplicate2x, value: 2, eggShellCost: 50, shopAvailable: true, image: "doubleIcon"),
        PowerUp(name: "Triple Points", description: "For one try, your egg shell earnings are triplicated", type: .multiplicate3x, value: 3),
        PowerUp(name: "Quintuple Points", description: "For one try, you egg shell earnings are quintuplicated", type: .multiplicate5x, value: 5),
        PowerUp(name: "One more Life", description: "In the next session, if the egg gets cracked it ignores one time", type: .revive1, value: 1, eggShellCost: 25, shopAvailable: true, image: "shieldIcon"),
        PowerUp(name: "Two more Life", description: "In the next session, if the egg gets cracked it ignores two times", type: .revive2, value: 2)
    ]
}

class CosmeticsBank {
    static var shared = CosmeticsBank()
    
    let powerUpsAvailable: [PowerUp] = PowerUpsAvailable.powerUps.filter { $0.shopAvailable == true }
    
    let eggsAvailable: [Egg] = [
        Egg(animal: "Chicken",
            image: "chickenEgg",
            powerUp: [],
            cosmeticsType: .chicken,
            eggShellCost: 0,
            size: .medium),
        Egg(animal: "Quail",
            image: "quailEgg",
            powerUp: [],
            cosmeticsType: .quail,
            eggShellCost: 100,
            size: .small),
        Egg(animal: "Crocodile",
            image: "crocodileEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[0],
                PowerUpsAvailable.powerUps[3],
            ],
            cosmeticsType: .crocodile,
            eggShellCost: 250,
            size: .medium),
        Egg(animal: "Ostrich",
            image: "ostrichEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[1],
                PowerUpsAvailable.powerUps[3],
            ],
            cosmeticsType: .ostrich,
            eggShellCost: 500,
            size: .big),
        Egg(animal: "T-Rex",
            image: "dinoEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[2],
                PowerUpsAvailable.powerUps[4],
            ],
            cosmeticsType: .dinossaur,
            eggShellCost: 1000,
            size: .big),
    ]
    
    let backgroundsAvailable: [BackgroundModel] = [
        BackgroundModel(name: "Bricks", image: "bricksBackground", type: .bricks),
        BackgroundModel(name: "Tiles", image: "tilesBackground", eggShellCost: 25, type: .tiles),
        BackgroundModel(name: "Sky", image: "skyBackground", eggShellCost: 40, type: .sky),
        BackgroundModel(name: "Space", image: "spaceBackground", eggShellCost: 100, type: .space),
    ]
}
