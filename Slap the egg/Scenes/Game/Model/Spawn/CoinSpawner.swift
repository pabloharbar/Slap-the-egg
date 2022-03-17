//
//  CoinSpawner.swift
//  Slap the egg
//
//  Created by Pablo Penas on 25/02/22.
//

import SpriteKit

class CoinSpawner {
    private var node: SKNode
    private var coins = [SKNode]()
    
    private var animation = SKAction()
    private var defaultAnimation: SKAction
    
    private let parent: SKNode
    
    private let interval = TimeInterval(2)
    private var currentTime = TimeInterval(0)
    
    init(node: SKNode, parent: SKNode) {
        self.node = node
        self.parent = parent
        self.defaultAnimation = SKAction()
        self.animationSetup()
    }

    func animationSetup() {
        let frame0 = SKTexture(imageNamed: "coin0")
        let frame1 = SKTexture(imageNamed: "coin1")
        let frame2 = SKTexture(imageNamed: "coin2")
        let frame3 = SKTexture(imageNamed: "coin3")
        let frame4 = SKTexture(imageNamed: "coin4")
        let frame5 = SKTexture(imageNamed: "coin5")
        
        let frames = SKAction.animate(with: [
            frame0, frame1, frame2, frame3, frame4, frame5
        ], timePerFrame: 0.5, resize: false, restore: false)
        
        defaultAnimation = SKAction.repeatForever(frames)
    }
    
    func spawn() {
        let new = node.copy() as! SKNode
        new.position = node.position
        new.position.x = CGFloat.random(in: -300...300)
        coins.append(new)
        parent.addChild(new)
        
        let coin = new.childNode(withName: "coinModel")!
        
        coin.run(defaultAnimation)
    }
    
    func removeCoin(nextTo point: CGPoint) -> Bool {
        for coin in coins {
            if coin.contains(point) {
                coin.removeFromParent()
                let coinIndex = coins.firstIndex(of: coin)!
                coins.remove(at: coinIndex)
                return true
            }
        }
        return false
    }
    
    func update(deltaTime: TimeInterval, multiplier: CGFloat) {
        // interval
        currentTime += deltaTime
        if currentTime >= interval {
            spawn()
            currentTime -= interval
        }

        // move
        for coin in coins {
            coin.position.y -= 500 * deltaTime * multiplier
        }

        if let firstEnemy = coins.first {
            if coins.count > 4 {
                firstEnemy.removeFromParent()
                coins.removeFirst()
            }
        }
        
        // Update move speed
//        moveSpeedMultiplier = (multiplier - 1) * 1.5 + 1
    }
    
    func reset() {
        for coin in coins {
            coin.removeFromParent()
        }
        coins.removeAll()
        currentTime = interval
    }
}
