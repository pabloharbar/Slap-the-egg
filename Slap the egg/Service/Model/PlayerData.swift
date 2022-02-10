//
//  PlayerData.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

enum Backgrounds: CaseIterable, Codable {
    case bricks
    case tiles
    case sky
    case space
}
enum Eggs: CaseIterable, Codable {
    case chicken
    case quail
    case crocodile
    case ostrich
    case dinossaur
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
