//
//  GameManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 02/02/22.
//

import SwiftUI
import SpriteKit

class GameManager: ObservableObject {
    static var gameSpeed = CGFloat(500)
    
    var scene: GameScene
    
    @Published var score = 0
    @Published var record: Int
    
    @Published var gameStatus: GameStatus = .menu
    
    init() {
        scene = SKScene(fileNamed: "GameScene") as! GameScene
        scene.scaleMode = .fill // TODO: Rever scaleMode e aspecto da scene
        record = UserDefaultsWrapper.fetchRecord() ?? 0
    }
    
    func updateRecord() {
        if score > record {
            UserDefaultsWrapper.setRecord(model: score)
            record = UserDefaultsWrapper.fetchRecord() ?? 0
        }
    }
    
    func displayScoreBoard() -> Double {
        return gameStatus == .playing || gameStatus == .gameOver ? 1 : 0
    }
    
    func displayRecord() -> Double {
        return gameStatus == .menu || gameStatus == .gameOver ? 1 : 0
    }
    
}
