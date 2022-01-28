//
//  Background.swift
//  Slap the egg
//
//  Created by Pablo Penas on 28/01/22.
//

import SpriteKit

class Background {
    private var node: SKSpriteNode
    private var duplicateNode: SKSpriteNode
    
    private var startPosition: CGPoint
    private var reset = true
    
    init(node: SKSpriteNode) {
        self.node = node
        self.duplicateNode = node.copy() as! SKSpriteNode
        duplicateNode.position.y += node.size.height
        duplicateNode.alpha = 0.5
        startPosition = node.position
    }
    
    func update(deltaTime: TimeInterval) {
        // move
        node.position.y -= 500 * deltaTime
        duplicateNode.position.y -= 500 * deltaTime
        
        if node.position.y <= startPosition.y && !reset {
            duplicateNode.position.y = node.position.y + node.size.height
            reset = true
        }
        
        if duplicateNode.position.y <= startPosition.y && reset {
            node.position.y = duplicateNode.position.y + duplicateNode.size.height
            reset = false
        }
    }
}
