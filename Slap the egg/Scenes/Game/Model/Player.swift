//
//  Player.swift
//  Slap the egg
//
//  Created by Pablo Penas on 28/01/22.
//

import Foundation
import SpriteKit

class Player {
    
    private var node: SKSpriteNode
    private var startPosition: CGPoint
    
    // Slap physical constants
    private let velocityModule = CGFloat(500)
    private let angularK = CGFloat(10)
    
    init(node: SKSpriteNode) {
        self.node = node
        startPosition = node.position
        physicsSetup()
    }
    
    func physicsSetup() {
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 1
        node.physicsBody?.collisionBitMask = 2
        node.physicsBody?.contactTestBitMask = 2
    }
    
    func start() {
        node.physicsBody?.isDynamic = true
    }
    
    func die() {
        node.removeFromParent()
    }
    
    func reset(parent: SKNode) {
        node.position = startPosition
        node.zRotation = 0
        node.physicsBody?.isDynamic = false
        parent.addChild(node)
    }
    
    func changeTexture(selectedEgg: Eggs) {
        let target = CosmeticsBank.shared.eggsAvailable.filter { $0.cosmeticsType == selectedEgg }.first!
        let image = target.image
        let scale: CGFloat
        node.texture = SKTexture(image: UIImage(named: image)!)
        switch target.size {
        case .small:
            scale = 0.8
        case .medium:
            scale = 1.4
        case .big:
            scale = 2.2
        }
        node.xScale = scale
        node.yScale = scale
    }
    
    func collide(withPan: Bool) {
        node.physicsBody?.velocity.dx *= -1
        node.physicsBody?.velocity.dy *= -1
//        if abs((node.physicsBody?.velocity.dy)!) <= 100 {
//            node.physicsBody?.velocity.dy *= 5
//        }
//        let treshold: CGFloat = 300
//        if (node.physicsBody?.velocity.dy)! <= treshold && (node.physicsBody?.velocity.dy)! >= treshold {
//            node.physicsBody?.velocity.dy = -velocityModule
//            print("limite")
//        }
        if withPan {
            node.physicsBody?.velocity.dy = velocityModule * 2
        }
    }
    
    func slap(at position: CGPoint, parent: SKNode, difficulty: Difficulty) {
        switch difficulty {
        case .easy:
//            SoundsManager.instance.playSound(sound: .faceSlap)
            let deltaX = node.position.x - position.x
            var width: CGFloat
            if deltaX > 0 {
                width = parent.scene!.size.width / 2 + node.position.x
            } else {
                width = parent.scene!.size.width / 2 - node.position.x
            }
//            let width = parent.scene!.size.width
            let vx = deltaX / width * velocityModule
            node.physicsBody?.velocity.dx = vx
            node.physicsBody?.velocity.dy = sqrt(pow(velocityModule,2) - pow(vx, 2))
            node.physicsBody?.angularVelocity = -angularK * deltaX / width
        case .hard:
            if node.contains(position) {
                SoundsManager.instance.playSound(sound: .faceSlap)
                let deltaX = node.position.x - position.x
                let normalizedWidth = node.size.width + (node.size.height - node.size.width) * abs(cos(node.zRotation))
                let vx = deltaX / normalizedWidth * velocityModule
                node.physicsBody?.velocity.dx = vx
                node.physicsBody?.velocity.dy = sqrt(pow(velocityModule,2) - pow(vx, 2))
                node.physicsBody?.angularVelocity = -angularK * deltaX / normalizedWidth
            } else {
                let missNode = SKLabelNode()
                let fadeOut = SKAction.fadeOut(withDuration: 1)
                missNode.text = NSLocalizedString("missed", comment: "")
                missNode.fontName = "Bangers-Regular"
                missNode.fontSize = 40
                missNode.fontColor = .red
                missNode.position = position
                missNode.zPosition = -1
                parent.addChild(missNode)
                missNode.run(fadeOut)
            }
        }
        // Tap em qualquer lugar da tela
//        let deltaX = node.position.x - position.x
//        let width = parent.scene!.size.width
//        let vx = deltaX / width * velocityModule
//        node.physicsBody?.velocity.dx = vx
//        node.physicsBody?.velocity.dy = sqrt(pow(velocityModule,2) - pow(vx, 2))
//        node.physicsBody?.angularVelocity = -angularK * deltaX / width
        
        
        
        // Tap dentro do ovo:
//        if node.contains(position) {
//            let deltaX = node.position.x - position.x
//            let normalizedWidth = node.size.width + (node.size.height - node.size.width) * abs(cos(node.zRotation))
//            let vx = deltaX / normalizedWidth * velocityModule
//            node.physicsBody?.velocity.dx = vx
//            node.physicsBody?.velocity.dy = sqrt(pow(velocityModule,2) - pow(vx, 2))
//            node.physicsBody?.angularVelocity = -angularK * deltaX / normalizedWidth
//        } else {
//            let missNode = SKLabelNode()
//            let fadeOut = SKAction.fadeOut(withDuration: 1)
//            missNode.text = "Errou"
//            missNode.fontName = "Bangers-Regular"
//            missNode.fontSize = 40
//            missNode.fontColor = .red
//            missNode.position = position
//            missNode.zPosition = -1
//            parent.addChild(missNode)
//            missNode.run(fadeOut)
//        }
    }
    
//    func checkTouch(at point: CGPoint) -> Bool {
//        return node.contains(point)
//    }
//    
    func getZRotation() -> CGFloat {
        return node.zRotation
    }
}






















    
//    // Flick Mode
//    func startFlick(position: CGPoint, currentTime: TimeInterval) {
//        flickStartPoint = position
//        impulseDuration = currentTime
//        playerFlickPosition = node.position
//    }
//
//    func flickRelease(position: CGPoint, currentTime: TimeInterval) {
//        flickEndPoint = position
//        impulseDuration = currentTime - impulseDuration
//        thrust()
//    }
//
//
//    func thrust() {
//        let m = (flickEndPoint.y - flickStartPoint.y) / (flickEndPoint.x - flickStartPoint.x)
//        let a = -m
//        let b = CGFloat(1)
//        let c = m * flickStartPoint.x - flickStartPoint.y
//        let distance = abs(a * playerFlickPosition.x + b * playerFlickPosition.y + c) / pow((pow(a, 2) + pow(b, 2)), 0.5)
////        let distance = abs(a * node.position.x + b * node.position.y + c) / pow((pow(a, 2) + pow(b, 2)), 0.5)
//
//
//        let delta_x = flickEndPoint.x - flickStartPoint.x
//        let delta_y = flickEndPoint.y - flickStartPoint.y
//
//        let intensityS = pow(pow(delta_x,2) + pow(delta_y,2),0.5)
//        let player_delta_x = flickStartPoint.x - node.position.x
//        let player_delta_y = flickStartPoint.y - node.position.y
//
//        let player_distance = pow(pow(player_delta_x, 2) + pow(player_delta_y, 2),0.5)
//
//        let beta = acos((delta_x * player_delta_x + delta_y * player_delta_y)/(player_distance * intensityS))
//
//        var angularAceleration = player_distance * intensityS * sin(beta)
//
//        if player_delta_x * delta_y - player_delta_y * delta_x < 0 {
//            angularAceleration = -angularAceleration
//        }
//
//        if distance <= 20 && distance >= -20 {
//            node.physicsBody?.applyImpulse(CGVector(
//                dx: CGFloat(linearK) * (delta_x / intensityS) / impulseDuration,
//                dy: CGFloat(linearK) * (delta_y / intensityS) / impulseDuration))
//        } else {
//            node.physicsBody?.applyImpulse(CGVector(
//                dx: CGFloat(linearK) * (delta_x / intensityS) / (impulseDuration * (distance/intensityS)),
//                dy: CGFloat(linearK) * (delta_y / intensityS) / (impulseDuration * (distance/intensityS))))
//            node.physicsBody?.angularVelocity = CGFloat(angularK) * angularAceleration / impulseDuration
//        }
//
//    }

