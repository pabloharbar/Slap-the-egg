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
    @Published var gameStatus: GameStatus = .menu
    
    init() {
        scene = SKScene(fileNamed: "GameScene") as! GameScene
        scene.scaleMode = .fill // TODO: Rever scaleMode e aspecto da scene
    }
    
    func updateStatus() {
//        scene.status = gameStatus
    }
}
