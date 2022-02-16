//
//  GameScene.swift
//  Slap the egg
//
//  Created by Pablo Penas on 27/01/22.
//

import SpriteKit
import Foundation
import Combine
import SwiftUI

enum GameStatus {
    case menu
    case wait
    case intro
    case playing
    case gameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var difficulty: Difficulty = .easy
    var vibrationEnabled: Bool = true
    var soundEnabled: Bool = true
    
    // Power Ups
    @Published var revive = 0 {
        didSet {
            revivePublisher.send(self.revive)
        }
    }
    private var PUmultiplicator = 1
    private var immunity = false
    
    // Score publisher setup
    public let scorePublisher = CurrentValueSubject<Int, Never>(0)
    public let statusPublisher = CurrentValueSubject<GameStatus, Never>(.menu)
    public let revivePublisher = CurrentValueSubject<Int, Never>(0)
//    private var cancellableSet = Set<AnyCancellable>()
    
//    @Published var target = 0 // Talvez nao precise do target
    @Published var currentScore = 0 {
        didSet {
            scorePublisher.send(self.currentScore)
        }
    }
    var scoreLimiter = 0 // auxiliar
    var speedMultiplier: CGFloat = 1
    // Sprites
    var player: Player!
    var spawner: Spawner!
    var pan: Pan!
    var background: Background!
    var toaster: Toaster!
    
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
        let titleImage = title.childNode(withName: "intro") as! SKSpriteNode
        titleImage.texture = SKTexture(imageNamed: NSLocalizedString("introImage", comment: ""))
        titleLabel = self.childNode(withName: "menuLabel") as? SKLabelNode
        titleLabel.fontName = "Bangers-Regular"
        titleLabel.text = NSLocalizedString("Tap to play", comment: "")
        
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
        
        // toaster setup
        let toasterNode = self.childNode(withName: "toasterModel")!
        toaster = Toaster(node: toasterNode, parent: self)
        
        // Load from user defaults
        let data = UserDefaultsWrapper.fetchRecord() ?? PlayerData(highscore: 0, money: 0)
        loadPlayerData(data: data)

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
            start()
            player.slap(at: pos, parent: self, difficulty: difficulty, vibrationEnabled: vibrationEnabled)
//            touchAnimation(pos: pos)
        case .playing:
            player.slap(at: pos, parent: self, difficulty: difficulty, vibrationEnabled: vibrationEnabled)
//            touchAnimation(pos: pos)
            
        case .gameOver:
            reset()
        case .wait:
            break
        }

    }
    
    func touchAnimation(pos: CGPoint) {
        let duration: TimeInterval = 0.5
//        let scaleAnimation = SKAction.scale(to: 2, duration: duration)
        let lineAnimation = SKAction.customAction(withDuration: duration, actionBlock: { node, timePassed in
            let circleNode = node as! SKShapeNode
            circleNode.lineWidth = 10 - 2 * timePassed * 10
            circleNode.setScale(1 + 4 * timePassed)
            let passo = Double(timePassed/duration)
            let r = 230/255 + passo * (176-230)/255
            let g = 78/255  + passo * (195-78)/255
            let b = 100/255 + passo * (49-100)/255
            circleNode.strokeColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        })
        let touchNode = SKShapeNode(circleOfRadius: 10)
        touchNode.fillColor = .clear
        touchNode.lineWidth = 4
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        touchNode.position = pos
        touchNode.zPosition = 10
        self.addChild(touchNode)
//        touchNode.run(scaleAnimation)
        touchNode.run(lineAnimation, completion: {
            touchNode.run(fadeOut, completion: {
                touchNode.removeFromParent()
            })
        })
        
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
    
    func reviveScene() {
        status = .intro
        pan.reset()
        player.reset(parent: self)
        spawner.reset()
        if deadEgg.parent == self {
            deadEgg.removeFromParent()
        }
//        deadEgg.removeFromParent()
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
        speedMultiplier = 1
    }
    
    func resetToIntro() {
        status = .intro
        player.reset(parent: self)
        spawner.reset()
        pan.reset()
        if deadEgg.parent == self {
            deadEgg.removeFromParent()
        }
//        deadEgg.removeFromParent()
        currentScore = 0
        speedMultiplier = 1
    }
    
    func gameOver(killedByPan: Bool, deathPosition: CGPoint) {
        if status == .gameOver {
            return
        }
        if killedByPan {
            pan.gameOver()
            SoundsManager.instance.playSound(sound: .frying, soundEnabled: soundEnabled)
        } else {
            SoundsManager.instance.playSound(sound: .eggCrush, soundEnabled: soundEnabled)
            deadEgg.position = deathPosition
            deadEgg.zPosition = -2
            deadEgg.zRotation = player.getZRotation()
            self.addChild(deadEgg)
        }
        revive = 0
        PUmultiplicator = 1
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
    
    func loadPlayerData(data: PlayerData) {
        // Player update, scale and texture
        player.changeTexture(selectedEgg: data.selectedEgg)
        // Background update, texture
        background.changeTexture(data: data)
        // Apply power ups
        for powerUp in data.activePowerUps {
            applyPowerUp(item: powerUp)
        }
    }
    
    func applyPowerUp(item: PowerUpType) {
//        for powerUp in items {
        switch item {
        case .multiplicate2x:
            PUmultiplicator = 2
        case .multiplicate3x:
            PUmultiplicator = 3
        case .multiplicate5x:
            PUmultiplicator = 5
        case .revive1:
            revive += 1
        case .revive2:
            revive += 2
        }
//        }
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
        
        let eggTouchedKnife = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4) || (contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 1)
        let eggTouchedSpoon = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 8) || (contact.bodyA.categoryBitMask == 8 && contact.bodyB.categoryBitMask == 1)
        let eggTouchedSpatula = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 16) || (contact.bodyA.categoryBitMask == 16 && contact.bodyB.categoryBitMask == 1)
        let eggTouchedToast = (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 32) || (contact.bodyA.categoryBitMask == 32 && contact.bodyB.categoryBitMask == 1)
        
        // Analytics
        if eggTouchedPan {
            AnalyticsManager.logEvent(eventName: AnalyticsEvents.deadToPan.rawValue)
        }
        if eggTouchedToast {
            AnalyticsManager.logEvent(eventName: AnalyticsEvents.deadToToaster.rawValue)
        }
        if eggTouchedKnife {
            AnalyticsManager.logEvent(eventName: AnalyticsEvents.deadToKnife.rawValue)
        }
        if eggTouchedSpoon {
            AnalyticsManager.logEvent(eventName: AnalyticsEvents.deadToSpoon.rawValue)
        }
        if eggTouchedSpatula {
            AnalyticsManager.logEvent(eventName: AnalyticsEvents.deadToSpatula.rawValue)
        }
        
        
        let eggTouchedEnemy = eggTouchedKnife || eggTouchedSpoon || eggTouchedSpatula || eggTouchedToast
        
        if eggTouchedPan || eggTouchedEnemy {
            if revive <= 0 {
                if status == .playing {
                    HapticsManager.instance.notification(type: .error, vibrationEnabled: vibrationEnabled)
                    gameOver(killedByPan: eggTouchedPan, deathPosition: contact.contactPoint)
                }
            } else {
                if !immunity {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.revive -= 1
                        print(self.revive)
                        self.immunity = false
                    }
                    player.collide(withPan: eggTouchedPan)
                }
                immunity = true
            }
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
            background.update(deltaTime: deltaTime, multiplier: speedMultiplier)
            spawner.update(deltaTime: deltaTime, multiplier: speedMultiplier)
            toaster.update(deltaTime: deltaTime)
            //Score counting
            speedMultiplier = 1 + CGFloat(currentScore)/500
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
