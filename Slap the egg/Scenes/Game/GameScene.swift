//
//  GameScene.swift
//  Slap the egg
//
//  Created by Pablo Penas on 27/01/22.
//

import SpriteKit
import GameplayKit

enum GameStatus {
    case menu
    case intro
    case playing
    case gameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    // Score TODO: separate from scene
    var currentScore = 0
    var scoreLimiter = 0 // auxiliar
    
    var player: Player!
    var spawner: Spawner!
    var pan: Pan!
    var background: Background!
    
    // Labels
    var title: SKNode!
    var titleLabel: SKLabelNode!
    var gameOverNode: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var lastUpdate = TimeInterval(0)
    var status: GameStatus = .menu
    
    override func didMove(to view: SKView) {
        // Physics contact delegate
        physicsWorld.contactDelegate = self
        
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
        title = self.childNode(withName: "title")!
        titleLabel = self.childNode(withName: "menuLabel") as? SKLabelNode
        titleLabel.fontName = "Bangers-Regular"
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
        case .menu:
            status = .intro
            title.removeFromParent()
            titleLabel.removeFromParent()
            // Aproximar frigideira
            pan.zoomIn()
        case .intro:
            start()
            player.slap(at: pos, parent: self)
        case .playing:
            player.slap(at: pos, parent: self)
//            player.startFlick(position: pos, currentTime: lastUpdate)
        case .gameOver:
            reset()
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
   
    }
    
    func start() {
        status = .playing
        player.start()
        title.removeFromParent()
    }
    
    func reset() {
        status = .menu
        gameOverNode.removeFromParent()
        self.addChild(title)
        self.addChild(titleLabel)
        player.reset()
        spawner.reset()
        pan.zoomOut()
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
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        switch status {
        case .menu:
            break
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
}
