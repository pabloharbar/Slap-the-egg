//
//  GameScene.swift
//  Slap the egg
//
//  Created by Pablo Penas on 27/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Score TODO: separete from scene
    var currentScore = 0
    var scoreLimiter = 0
    
    var player: Player!
    var spawner: Spawner!
    var pan: Pan!
    var background: Background!
    
    // Labels
    var introNode: SKSpriteNode!
    var gameOverNode: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var lastUpdate = TimeInterval(0)
    var status: GameStatus = .intro
    
    override func didMove(to view: SKView) {
        // Physics contact delegate
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy /= 2
        // player setup
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        
        // spawner setup
        let spawnerNode = self.childNode(withName: "spawner")!
        spawner = Spawner(node: spawnerNode, parent: self)
        
        // pan setup
        let panNode = self.childNode(withName: "pan") as! SKSpriteNode
        pan = Pan(node: panNode)
        
        // label setup
        introNode = self.childNode(withName: "intro") as? SKSpriteNode
        gameOverNode = self.childNode(withName: "gameOver") as? SKSpriteNode
        gameOverNode.removeFromParent()
        scoreLabel = self.childNode(withName: "score") as? SKLabelNode
        
        // background setup
        let backgroundNode = self.childNode(withName: "background") as! SKSpriteNode
        background = Background(node: backgroundNode, parent: self)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        // Flick mode
        switch status {
        case .intro:
            player.startFlick(position: pos, currentTime: lastUpdate)
        case .playing:
            player.startFlick(position: pos, currentTime: lastUpdate)
        case .gameOver:
            break
        }

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        // Flick track animation
        let track = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
        
        track.position = pos
        self.addChild(track)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        track.run(fadeOut)

    }
    
    func touchUp(atPoint pos : CGPoint) {
        // Flick mode
        switch status {
        case .intro:
            start()
            player.flickRelease(position: pos, currentTime: lastUpdate)
        case .playing:
            player.flickRelease(position: pos, currentTime: lastUpdate)
        case .gameOver:
            reset()
        }

    }
    
    func start() {
        status = .playing
        player.start()
        introNode.removeFromParent()
    }
    
    func reset() {
        status = .intro
        gameOverNode.removeFromParent()
        self.addChild(introNode)
        player.reset()
        spawner.reset()
        
        currentScore = 0
    }
    
    func gameOver() {
        if status == .gameOver {
            return
        }
        
        player.die()
        self.addChild(gameOverNode)
        status = .gameOver
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let eggTouchedPan = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2) || (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1)
        let eggTouchedEnemy = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4) || (contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 1)
        if eggTouchedPan || eggTouchedEnemy {
            gameOver()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        switch status {
        case .intro:
            break
        case .playing:
            background.update(deltaTime: deltaTime)
            spawner.update(deltaTime: deltaTime)
            
            //Score counting
            scoreLimiter += 1
            if scoreLimiter >= 10 {
                currentScore += 1
                scoreLabel.text = "\(currentScore)"
                scoreLimiter = 0
            }
        case .gameOver:
            break
        }
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}
