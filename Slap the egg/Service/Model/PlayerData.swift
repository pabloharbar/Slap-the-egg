//
//  PlayerData.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import Foundation

struct Cosmetics: Codable {
    enum Backgrounds: CaseIterable {
        case tiles
        case sky
        case space
    }
    enum Eggs: CaseIterable {
        case quail
        case crocodile
        case ostrich
        case dinossaur
    }
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
    var cosmetics: [Cosmetics]
    var preferences: Preferences
    
    init(highscore: Int, money: Int) {
        self.highscore = highscore
        self.money = money
        self.cosmetics = []
        self.preferences = Preferences()
    }
}
