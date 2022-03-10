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
    
    init(node: SKSpriteNode, parent: SKNode) {
        self.node = node
        self.duplicateNode = node.copy() as! SKSpriteNode
        duplicateNode.position.y += node.size.height
        startPosition = node.position
        parent.addChild(duplicateNode)
    }
    
    func update(deltaTime: TimeInterval, multiplier: CGFloat) {
        // move
        node.position.y -= 500 * deltaTime * multiplier
        duplicateNode.position.y -= 500 * deltaTime * multiplier
        
        if node.position.y <= startPosition.y && !reset {
            duplicateNode.position.y = node.position.y + node.size.height
            reset = true
        }
        
        if duplicateNode.position.y <= startPosition.y && reset {
            node.position.y = duplicateNode.position.y + duplicateNode.size.height
            reset = false
        }
    }
    
    func changeTexture(data: PlayerData) {
        let target = CosmeticsBank.shared.backgroundsAvailable.filter { $0.cosmeticsType == data.selectedBackground }.first!
        let image = target.image
        let texture = SKTexture(image: UIImage(named: image)!)
        node.texture = texture
        duplicateNode.texture = texture
    }
}
