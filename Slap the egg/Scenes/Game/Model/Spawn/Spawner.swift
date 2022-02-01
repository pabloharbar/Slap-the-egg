//
//  Spawner.swift
//  Slap the egg
//
//  Created by Pablo Penas on 28/01/22.
//

import Foundation
import UIKit
import SpriteKit

enum Enemies {
    case knife
}

class Spawner {
    
    private var path: UIBezierPath
    private var spawnModel: SKNode!
    private var parent: SKNode
    
    private var enemies = [SKNode]()
    
    private let interval = TimeInterval(2)
    private var currentTime = TimeInterval(0)
    
    private var startPosition = CGPoint(x: 0, y: 0)
    
    init(node: SKNode, parent: SKNode) {
        self.spawnModel = node
        startPosition =  spawnModel.childNode(withName: "knife")!.position
        self.parent = parent
        
        // Path setup
        self.path = UIBezierPath()
    }
    
    func spawn() {
        let new = spawnModel.copy() as! SKNode
        new.zPosition = 0
        
        // Path creation
        generatePath(path: path)
        let dashes: [CGFloat] = [20,50]
        let dashedPath = path.cgPath.copy(dashingWithPhase: 10, lengths: dashes)
        
        let pathNode = SKShapeNode(path: dashedPath)
        pathNode.strokeColor = .gray
        pathNode.lineWidth = 10
        pathNode.zPosition = -1
        pathNode.lineCap = .round
        
//        path.setLineDash(dashes, count: dashes.count, phase: 0)
//        path.lineCapStyle = .round
        
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 200)
        let animation = SKAction.repeatForever(move)
        
        parent.addChild(new)
        new.addChild(pathNode)
        new.childNode(withName: "knife")!.run(animation)
        enemies.append(new)
    }
    
    func generatePath(path: UIBezierPath) {
        let incline = Int.random(in: -150...150)
        path.removeAllPoints()
        
        let reversed = Bool.random()
        
        if reversed {
            path.move(to: CGPoint(x: -startPosition.x, y: CGFloat(incline)))
            path.addLine(to: CGPoint(x: startPosition.x, y: -CGFloat(incline)))
        } else {
            path.move(to: CGPoint(x: startPosition.x, y: CGFloat(incline)))
            path.addLine(to: CGPoint(x: -startPosition.x, y: -CGFloat(incline)))
        }

        path.close()
    }
    
    func update(deltaTime: TimeInterval) {
        // interval
        currentTime += deltaTime
        if currentTime >= interval {
            spawn()
            currentTime -= interval
        }
        
        // move
        for enemy in enemies {
            enemy.position.y -= 500 * deltaTime
        }
        
        if let firstEnemy = enemies.first {
            if firstEnemy.position.y <= -1000 {
                firstEnemy.removeFromParent()
                enemies.removeFirst()
            }
        }
    }
    
    func reset() {
        for enemy in enemies {
            enemy.removeFromParent()
        }
        enemies.removeAll()
        currentTime = interval
    }
}
