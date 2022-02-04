//
//  GameScene.swift
//  Slap the egg
//
//  Created by Pablo Penas on 27/01/22.
//

import SpriteKit
import Foundation
import Combine

enum GameStatus {
    case menu
    case wait
    case intro
    case playing
    case gameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var difficulty: Difficulty = .easy
    
    // Score publisher setup
    public let scorePublisher = CurrentValueSubject<Int, Never>(0)
    public let statusPublisher = CurrentValueSubject<GameStatus, Never>(.menu)
//    private var cancellableSet = Set<AnyCancellable>()
    
//    @Published var target = 0 // Talvez nao precise do target
    @Published var currentScore = 0 {
        didSet {
            scorePublisher.send(self.currentScore)
        }
    }
    var scoreLimiter = 0 // auxiliar
    
    // Sprites
    var player: Player!
    var spawner: Spawner!
    var pan: Pan!
    var background: Background!
    
    // Labels
    var title: SKNode!
    var titleLabel: SKLabelNode!
    
    let deadEgg = SKSpriteNode(imageNamed: "deadEgg")
    var touchIndicator: SKSpriteNode!
    
    var lastUpdate = TimeInterval(0)
    var previousStatus: GameStatus = .menu
    @Published var status: GameStatus = .menu {
        didSet {
            statusPublisher.send(self.status)
        }
    }

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
        
        touchIndicator = self.childNode(withName: "touch") as? SKSpriteNode
        touchIndicator.removeFromParent()
        let approximate = SKAction.moveBy(x: -100, y: 50, duration: 0.5)
        let distanciate = SKAction.moveBy(x: 100, y: -50, duration: 0.5)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.3)
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.3)
        let touchAnimation = SKAction.sequence([scaleDown,scaleUp,distanciate,approximate])
        touchIndicator.run(SKAction.repeatForever(touchAnimation))
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let animation = SKAction.sequence([fadeOut,fadeIn])
        titleLabel.run(SKAction.repeatForever(animation))
        
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.status == .intro {
                    self.beginTouchAnimation()
                }
            }
        case .intro:
            if player.checkTouch(at: pos) {
                start()
                player.slap(at: pos, parent: self, difficulty: difficulty)
            }
        case .playing:
            player.slap(at: pos, parent: self, difficulty: difficulty)
//            player.startFlick(position: pos, currentTime: lastUpdate)
        case .gameOver:
            reset()
        case .wait:
            break
        }

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
   
    }
    
    func start() {
        status = .playing
        player.start()
        title.removeFromParent()
        titleLabel.removeFromParent()
        touchIndicator.removeFromParent()
    }
    
    func reset() {
        status = .menu
        self.addChild(title)
        player.reset(parent: self)
        spawner.reset()
        pan.reset()
        pan.zoomOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.status == .menu {
                self.addChild(self.titleLabel)
            }
        }
        currentScore = 0
        deadEgg.removeFromParent()
    }
    
    func gameOver(killedByPan: Bool, deathPosition: CGPoint) {
        if status == .gameOver {
            return
        }
        if killedByPan {
            pan.gameOver()
        } else {
            deadEgg.position = deathPosition
            deadEgg.zPosition = -3
            deadEgg.zRotation = player.getZRotation()
            self.addChild(deadEgg)
        }
        
        player.die()
        status = .gameOver
    }
    
    func holdScene() {
        if status == .menu {
            previousStatus = .menu
            status = .wait
            titleLabel.removeFromParent()
            title.removeFromParent()
        } else if status == .gameOver {
            previousStatus = .gameOver
            status = .wait
        }
    }
    
    func resumeScene() {
        if previousStatus == .menu {
            self.addChild(titleLabel)
            self.addChild(title)
            status = .menu
        } else if previousStatus == .gameOver {
            status = .gameOver
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let eggTouchedPan = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2) || (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1)
        let eggTouchedEnemy = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4) || (contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 1)
        if eggTouchedPan || eggTouchedEnemy {
            gameOver(killedByPan: eggTouchedPan, deathPosition: contact.contactPoint)
        }
    }
    
    func beginTouchAnimation() {
        self.addChild(touchIndicator)
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
                scoreLimiter = 0
            }
        case .gameOver:
            break
        case .wait:
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
