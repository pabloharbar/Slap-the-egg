//
//  Pan.swift
//  Slap the egg
//
//  Created by Pablo Penas on 28/01/22.
//

import Foundation
import SpriteKit

class Pan {
    private var node: SKSpriteNode
    
    init(node: SKSpriteNode) {
        self.node = node
    }
    
    func zoomIn() {
        let zoomIn = SKAction.scale(to: 3, duration: 1)
        let move = SKAction.moveBy(x: -50, y: -200, duration: 1)
        node.run(zoomIn)
        node.run(move)
    }
    
    func zoomOut() {
        let zoomOut = SKAction.scale(to: 1.8, duration: 1)
        let move = SKAction.moveBy(x: 50, y: 200, duration: 1)
        node.run(zoomOut)
        node.run(move)
    }
    
    func gameOver() {
        let texture = SKTexture(imageNamed: "panGameOver")
        node.run(SKAction.setTexture(texture))
    }
    
    func reset() {
        let texture = SKTexture(imageNamed: "panela")
        node.run(SKAction.setTexture(texture))
    }
}
