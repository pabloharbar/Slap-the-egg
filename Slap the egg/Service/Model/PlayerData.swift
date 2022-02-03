//
//  PlayerData.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import Foundation

class PlayerData: Codable {
    var highscore: Int
    var money: Int
    
    init(highscore: Int, money: Int) {
        self.highscore = highscore
        self.money = money
    }
}
