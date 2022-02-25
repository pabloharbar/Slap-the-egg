//
//  PlayerData.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

enum Backgrounds: Int, CaseIterable, Codable {
    case bricks = 0
    case tiles = 1
    case sky = 2
    case space = 3
    case pumpkin = 4
    case eyes = 5
    case ghosts = 6
}
enum Eggs: Int, CaseIterable, Codable {
    case chicken = 0
    case quail = 1
    case crocodile = 2
    case ostrich = 3
    case dinossaur = 4
    case mummy = 5
    case zombie = 6
}

struct Preferences: Codable {
    var soundEnable: Bool
    var vibrationEnable: Bool
    var difficulty: Difficulty
    
    init() {
        self.soundEnable = true
        self.vibrationEnable = true
        self.difficulty = .easy
    }
}

class PlayerData: Codable {
    var highscore: Int
    var money: Int
    var eggsUnlocked: [Eggs]
    var backgroundsUnlocked: [Backgrounds]
    var preferences: Preferences
    var selectedEgg: Eggs
    var selectedBackground: Backgrounds
    var activePowerUps: [PowerUpType]
    
    init(highscore: Int, money: Int) {
        self.highscore = highscore
        self.money = money
        self.eggsUnlocked = [.chicken]
        self.backgroundsUnlocked = [.bricks]
        self.preferences = Preferences()
        self.selectedEgg = .chicken
        self.selectedBackground = .bricks
        self.activePowerUps = []
    }
}
