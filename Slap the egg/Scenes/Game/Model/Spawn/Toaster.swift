//
//  Toaster.swift
//  Slap the egg
//
//  Created by Pablo Penas on 10/02/22.
//

import SpriteKit

class Toaster {
    private var node: SKNode!
    private var mirrorNode: SKNode
    private let parent: SKNode
    
    private let interval = TimeInterval(4.5)
    private var currentTime = TimeInterval(0)
    
    init(node: SKNode, parent: SKNode) {
        self.node = node
        self.parent = parent
        
        // Mirror node setup
        self.mirrorNode = parent.childNode(withName: "toasterModel")!.copy() as! SKNode
        mirrorNode.position = node.position
        mirrorNode.position.x *= -1
        parent.addChild(mirrorNode)
    }
 
    func spawn() {
        let chance = Int.random(in: 1...10)
        
        if chance > 7  {
            // Duplicate shooters
            let rightToaster = node.copy() as! SKNode
            let leftToaster = mirrorNode.copy() as! SKNode
            parent.addChild(rightToaster)
            parent.addChild(leftToaster)
            shoot(toaster: rightToaster)
            shoot(toaster: leftToaster)
        } else {
            let sideDice = Bool.random()
            if sideDice {
                // Direita
                let rightToaster = node.copy() as! SKNode
                parent.addChild(rightToaster)
                shoot(toaster: rightToaster)
            } else {
                // Esquerda
                let leftToaster = mirrorNode.copy() as! SKNode
                parent.addChild(leftToaster)
                shoot(toaster: leftToaster)
            }
        }
    }
    
    func shoot(toaster: SKNode) {
        let orientationDice = Bool.random()
        if orientationDice {
            // v
            toaster.zRotation = .pi
            toaster.position.y = 1760
            let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -180), duration: 1)
            let returnUp = SKAction.move(by: CGVector(dx: 0, dy: -180), duration: 1)
            toaster.run(moveDown) {
                let recoil = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.5)
                let shootAction = SKAction.move(by: CGVector(dx: 0, dy: 1700), duration: 2)
                toaster.childNode(withName: "toast")!.run(SKAction.sequence([recoil,shootAction])) {
                    toaster.childNode(withName: "toaster")!.run(returnUp) {
//                        toaster.childNode(withName: "toast")!.position.y = toaster.position.y - 80
                        toaster.removeFromParent()
                    }
                }
            }
        } else {
            // ˆ
            toaster.zRotation = 0
            toaster.position.y = -225
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 460), duration: 1)
            let returnDown = SKAction.move(by: CGVector(dx: 0, dy: -460), duration: 1)
            toaster.run(moveUp) {
                let recoil = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.5)
                let shootAction = SKAction.move(by: CGVector(dx: 0, dy: 1700), duration: 2)
                toaster.childNode(withName: "toast")!.run(SKAction.sequence([recoil,shootAction])) {
                    toaster.childNode(withName: "toaster")!.run(returnDown) {
//                        toaster.childNode(withName: "toast")!.position.y = 80
                        toaster.removeFromParent()
                    }
                }
            }
        }
    }
    
    func update(deltaTime: TimeInterval) {
        // interval
        currentTime += deltaTime
        if currentTime >= interval {
            spawn()
            currentTime -= interval
        }
    }
}
