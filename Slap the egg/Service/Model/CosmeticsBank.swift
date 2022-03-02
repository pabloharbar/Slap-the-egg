//
//  CosmeticsBank.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import Foundation

struct PowerUpsAvailable {
    static let powerUps: [PowerUp] = [
        PowerUp(name: NSLocalizedString("Double Points", comment: ""), description: NSLocalizedString("For one try, your egg shell earnings are doubled", comment: ""), type: .multiplicate2x, value: 2, eggShellCost: 50, shopAvailable: true, image: "doubleIcon"),
        PowerUp(name: NSLocalizedString("Triple Points", comment: ""), description: NSLocalizedString("For one try, your egg shell earnings are triplicated", comment: ""), type: .multiplicate3x, value: 3),
        PowerUp(name: NSLocalizedString("Quintuple Points", comment: ""), description: NSLocalizedString("For one try, you egg shell earnings are quintuplicated", comment: ""), type: .multiplicate5x, value: 5),
        PowerUp(name: NSLocalizedString("One More Life", comment: ""), description: NSLocalizedString("In the next session, if the egg gets cracked it ignores one time", comment: ""), type: .revive1, value: 1, eggShellCost: 25, shopAvailable: true, image: "shieldIcon"),
        PowerUp(name: NSLocalizedString("Two More Lives", comment: ""), description: NSLocalizedString("In the next session, if the egg gets cracked it ignores two times", comment: ""), type: .revive2, value: 2),
        PowerUp(name: NSLocalizedString("Eggshells spawn", comment: ""), description: NSLocalizedString("While using this egg, coins can spawn", comment: ""), type: .coinsSpawn, value: 1),
        PowerUp(name: NSLocalizedString("Different Enemy", comment: ""), description: NSLocalizedString("While using this egg, a new type of enemy spawn.", comment: ""), type: .shovelEnemy, value: 1),
    ]
}

class CosmeticsBank {
    static var shared = CosmeticsBank()
    
    let powerUpsAvailable: [PowerUp] = PowerUpsAvailable.powerUps.filter { $0.shopAvailable == true }
    
    #if DEBUG
    let eggsAvailable: [Egg] = [
        Egg(animal: NSLocalizedString("Chicken", comment: ""),
            image: "chickenEgg",
            powerUp: [],
            cosmeticsType: .chicken,
            eggShellCost: 0,
            size: .medium),
        Egg(animal: NSLocalizedString("Quail", comment: ""),
            image: "quailEgg",
            powerUp: [],
            cosmeticsType: .quail,
            eggShellCost: 0,
            size: .small),
        Egg(animal: NSLocalizedString("Crocodile", comment: ""),
            image: "crocodileEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[0],
                PowerUpsAvailable.powerUps[3],
            ],
            cosmeticsType: .crocodile,
            eggShellCost: 0,
            size: .medium),
        Egg(animal: NSLocalizedString("Ostrich", comment: ""),
            image: "ostrichEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[1],
                PowerUpsAvailable.powerUps[3],
            ],
            cosmeticsType: .ostrich,
            eggShellCost: 0,
            size: .big),
        Egg(animal: NSLocalizedString("T-Rex", comment: ""),
            image: "dinoEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[2],
                PowerUpsAvailable.powerUps[4],
            ],
            cosmeticsType: .dinossaur,
            eggShellCost: 0,
            size: .big),
        Egg(animal: NSLocalizedString("Mummy", comment: ""),
            image: "mummyEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[5],
                PowerUpsAvailable.powerUps[6]
            ],
            cosmeticsType: .mummy,
            eggShellCost: 0,
            size: .medium),
        Egg(animal: NSLocalizedString("Zombie", comment: ""),
            image: "zombieEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[6]
            ],
            cosmeticsType: .zombie,
            eggShellCost: 0,
            size: .medium),
    ]
    
    let backgroundsAvailable: [BackgroundModel] = [
        BackgroundModel(name: NSLocalizedString("Bricks", comment: ""), image: "bricksBackground", type: .bricks),
        BackgroundModel(name: NSLocalizedString("Tiles", comment: ""), image: "tilesBackground", eggShellCost: 0, type: .tiles),
        BackgroundModel(name: NSLocalizedString("Sky", comment: ""), image: "skyBackground", eggShellCost: 0, type: .sky),
        BackgroundModel(name: NSLocalizedString("Space", comment: ""), image: "spaceBackground", eggShellCost: 0, type: .space),
        BackgroundModel(name: NSLocalizedString("Pumpkins", comment: ""), image: "pumpkinBackground", eggShellCost: 0, type: .pumpkin),
        BackgroundModel(name: NSLocalizedString("Eyes", comment: ""), image: "eyesBackground", eggShellCost: 0, type: .eyes),
        BackgroundModel(name: NSLocalizedString("Ghosts", comment: ""), image: "ghostBackground", eggShellCost: 0, type: .ghosts),
    ]
    #else
    let eggsAvailable: [Egg] = [
        Egg(animal: NSLocalizedString("Chicken", comment: ""),
            image: "chickenEgg",
            powerUp: [],
            cosmeticsType: .chicken,
            eggShellCost: 0,
            size: .medium),
        Egg(animal: NSLocalizedString("Quail", comment: ""),
            image: "quailEgg",
            powerUp: [],
            cosmeticsType: .quail,
            eggShellCost: 100,
            size: .small),
        Egg(animal: NSLocalizedString("Crocodile", comment: ""),
            image: "crocodileEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[0],
                PowerUpsAvailable.powerUps[3],
            ],
            cosmeticsType: .crocodile,
            eggShellCost: 250,
            size: .medium),
        Egg(animal: NSLocalizedString("Ostrich", comment: ""),
            image: "ostrichEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[1],
                PowerUpsAvailable.powerUps[3],
            ],
            cosmeticsType: .ostrich,
            eggShellCost: 500,
            size: .big),
        Egg(animal: NSLocalizedString("T-Rex", comment: ""),
            image: "dinoEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[2],
                PowerUpsAvailable.powerUps[4],
            ],
            cosmeticsType: .dinossaur,
            eggShellCost: 1000,
            size: .big),
        Egg(animal: NSLocalizedString("Mummy", comment: ""),
            image: "mummyEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[5],
                PowerUpsAvailable.powerUps[6]
            ],
            cosmeticsType: .mummy,
            eggShellCost: 800,
            size: .medium),
        Egg(animal: NSLocalizedString("Zombie", comment: ""),
            image: "zombieEgg",
            powerUp: [
                PowerUpsAvailable.powerUps[6]
            ],
            cosmeticsType: .zombie,
            eggShellCost: 400,
            size: .medium),
    ]
    
    let backgroundsAvailable: [BackgroundModel] = [
        BackgroundModel(name: NSLocalizedString("Bricks", comment: ""), image: "bricksBackground", type: .bricks),
        BackgroundModel(name: NSLocalizedString("Tiles", comment: ""), image: "tilesBackground", eggShellCost: 40, type: .tiles),
        BackgroundModel(name: NSLocalizedString("Sky", comment: ""), image: "skyBackground", eggShellCost: 150, type: .sky),
        BackgroundModel(name: NSLocalizedString("Space", comment: ""), image: "spaceBackground", eggShellCost: 500, type: .space),
        BackgroundModel(name: NSLocalizedString("Pumpkins", comment: ""), image: "pumpkinBackground", eggShellCost: 450, type: .pumpkin),
        BackgroundModel(name: NSLocalizedString("Eyes", comment: ""), image: "eyesBackground", eggShellCost: 250, type: .eyes),
        BackgroundModel(name: NSLocalizedString("Ghosts", comment: ""), image: "ghostBackground", eggShellCost: 200, type: .ghosts),
    ]
    
    #endif
}
