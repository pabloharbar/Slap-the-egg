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
    private var panAnimation: SKAction!
    private var deadAnimation: SKAction!
    
    init(node: SKSpriteNode) {
        self.node = node
        animationSetup()
    }
    
    func animationSetup() {
        var textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "pan0"))
        textures.append(SKTexture(imageNamed: "pan1"))
        textures.append(SKTexture(imageNamed: "pan2"))
        textures.append(SKTexture(imageNamed: "pan3"))
        textures.append(SKTexture(imageNamed: "pan4"))
        textures.append(SKTexture(imageNamed: "pan5"))
        textures.append(SKTexture(imageNamed: "pan6"))
        textures.append(SKTexture(imageNamed: "pan7"))
        textures.append(SKTexture(imageNamed: "pan8"))
        textures.append(SKTexture(imageNamed: "pan9"))
        var frames = SKAction.animate(with: textures, timePerFrame: 0.2)
        panAnimation = SKAction.repeatForever(frames)
        
        textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "dead0"))
        textures.append(SKTexture(imageNamed: "dead1"))
        textures.append(SKTexture(imageNamed: "dead2"))
        textures.append(SKTexture(imageNamed: "dead3"))
        textures.append(SKTexture(imageNamed: "dead4"))
        textures.append(SKTexture(imageNamed: "dead5"))
        frames = SKAction.animate(with: textures, timePerFrame: 0.2)
        deadAnimation = frames
        
        node.run(panAnimation)
    }
    
    func zoomIn() {
        let zoomIn = SKAction.scale(to: 3, duration: 1)
        let move = SKAction.moveBy(x: -50, y: -350, duration: 1)
        node.run(zoomIn)
        node.run(move)
    }
    
    func zoomOut() {
        let zoomOut = SKAction.scale(to: 1.8, duration: 1)
        let move = SKAction.moveBy(x: 50, y: 350, duration: 1)
        node.run(zoomOut)
        node.run(move)
    }
    
    func gameOver() {
//        let frame0 =
//        let egg = SKSpriteNode(texture: <#T##SKTexture?#>)
        node.removeAllActions()
        node.run(deadAnimation)
//        let texture = SKTexture(imageNamed: "panGameOver")
//        node.run(SKAction.setTexture(texture))
    }
    
    func reset() {
//        let texture = SKTexture(imageNamed: "panela")
//        node.run(SKAction.setTexture(texture))
        node.run(panAnimation)
    }
}
