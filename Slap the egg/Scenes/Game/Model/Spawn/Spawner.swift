//
//  Spawner.swift
//  Slap the egg
//
//  Created by Pablo Penas on 28/01/22.
//

import Foundation
import UIKit
import SpriteKit

enum Enemies: CaseIterable {
    case knife
    case spoon
    case spatula
    
    static func random() -> Enemies {
        let sorted = Int.random(in: 0..<Enemies.allCases.count)
        switch sorted {
        case 0:
            return .knife
        case 1:
            return .spoon
        case 2:
            return .spatula
        default:
            return .knife
        }
    }
}

class Spawner {
    
//    private var path: UIBezierPath
//    private var paths = [UIBezierPath]()
    private var spawner: SKNode!
    private var parent: SKNode
    private var moveSpeedMultiplier: CGFloat = 1
    
    private var enemies = [SKNode]()
    
    private let interval = TimeInterval(2)
    private var currentTime = TimeInterval(0)
    
    private var startPosition = CGPoint(x: 0, y: 0)
    
    init(node: SKNode, parent: SKNode) {
        // Models setup
        self.spawner = node
        startPosition = CGPoint(x: 0, y: parent.frame.height + 300)
        self.parent = parent
    }
    
    func spawn() {
        let enemy = Enemies.random()
        switch enemy {
        case .knife:
            spawnKnife()
        case .spoon:
            spawnSpoon()
            break
        case .spatula:
            spawnSpatula()
            break
        }
    }
    
    func spawnKnife() {
        let new = spawner.childNode(withName: "knifeModel")!.copy() as! SKNode
        new.position = startPosition
        // Path Setup
        let path = generateLinearPath()
        let dashes: [CGFloat] = [20,40]
        let dashedPath = path.cgPath.copy(dashingWithPhase: 10, lengths: dashes)
        let pathNode = SKShapeNode(path: dashedPath)
        pathNode.strokeColor = .gray
        pathNode.lineWidth = 10
        pathNode.zPosition = -4
        pathNode.lineCap = .round
        
        // Animation Setup
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 200 * moveSpeedMultiplier)
        let animation = SKAction.repeatForever(move)
        
        // Add sprites
        parent.addChild(new)
        new.addChild(pathNode)
        new.childNode(withName: "knife")!.position = pathNode.position
        new.childNode(withName: "knife")!.run(animation)
        enemies.append(new)
    }
    
    func spawnSpoon() {
        let new = spawner.childNode(withName: "spoonModel")!.copy() as! SKNode
        new.position = startPosition
        
        // Path Setup
        let path = generateCirclePath(inversed: false)
        let dashes: [CGFloat] = [20,40]
        let dashedPath = path.cgPath.copy(dashingWithPhase: 10, lengths: dashes)
        let pathNode = SKShapeNode(path: dashedPath)
        pathNode.strokeColor = .gray
        pathNode.lineWidth = 10
        pathNode.zPosition = -4
        pathNode.lineCap = .round
        
        // Animation Setup
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 200 * moveSpeedMultiplier)
        let animation = SKAction.repeatForever(move)
        
        let rotation = SKAction.repeatForever(SKAction.rotate(byAngle: .pi * 2, duration: 2 / moveSpeedMultiplier))
        
        // Spoon copy animation inversed
        let path2 = generateCirclePath(inversed: true)
        let move2 = SKAction.follow(path2.cgPath, asOffset: false, orientToPath: false, speed: 200 * moveSpeedMultiplier)
        let animation2 = SKAction.repeatForever(move2)
        
        
        // Add sprites
        parent.addChild(new)
        new.addChild(pathNode)
        new.childNode(withName: "spoon2")!.run(animation2)
        new.childNode(withName: "spoon2")!.run(rotation)
        new.childNode(withName: "spoon")!.run(animation)
        new.childNode(withName: "spoon")!.run(rotation)
        enemies.append(new)
    }
    
    func spawnSpatula() {
        let new = spawner.childNode(withName: "spatulaModel")!.copy() as! SKNode
        new.position = startPosition
        // Path Setup
        let path = generateLinearPath()
        let dashes: [CGFloat] = [20,40]
        let dashedPath = path.cgPath.copy(dashingWithPhase: 10, lengths: dashes)
        let pathNode = SKShapeNode(path: dashedPath)
        pathNode.strokeColor = .gray
        pathNode.lineWidth = 10
        pathNode.zPosition = -4
        pathNode.lineCap = .round
        
        // Animation Setup
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 200 * moveSpeedMultiplier)
        let animation = SKAction.repeatForever(move)
        let rotation = SKAction.repeatForever(SKAction.rotate(byAngle: .pi * 2, duration: 1 / moveSpeedMultiplier))
        
        // Add sprites
        parent.addChild(new)
        new.addChild(pathNode)
        new.childNode(withName: "spatula")!.position = pathNode.position
        new.childNode(withName: "spatula")!.run(animation)
        new.childNode(withName: "spatula")!.run(rotation)
        enemies.append(new)
    }
    
    func generateLinearPath() -> UIBezierPath {
        let incline = Int.random(in: -150...150)
        let reversed = Bool.random()
        
        let path = UIBezierPath()

        if reversed {
            path.move(to: CGPoint(x: -(750 - 100)/2, y: CGFloat(incline)))
            path.addLine(to: CGPoint(x: (750 - 100)/2, y: -CGFloat(incline)))
        } else {
            path.move(to: CGPoint(x: (750 - 100)/2, y: CGFloat(incline)))
            path.addLine(to: CGPoint(x: -(750 - 100)/2, y: -CGFloat(incline)))
        }

        path.close()
        return path
    }
    
    func generateCirclePath(inversed: Bool) -> UIBezierPath {
        let radius: CGFloat = 250
        let path: UIBezierPath
        let start = CGPoint(x: 0, y: 0)
        if inversed {
            path = UIBezierPath(arcCenter: start, radius: radius, startAngle: .pi, endAngle: .pi * 3, clockwise: true)
        } else {
            path = UIBezierPath(arcCenter: start, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        }
//        path.close()
        return path
    }
    
    func update(deltaTime: TimeInterval, multiplier: CGFloat) {
        // interval
        currentTime += deltaTime
        if currentTime >= interval {
            spawn()
            currentTime -= interval
        }
        
        // move
        for enemy in enemies {
            enemy.position.y -= 500 * deltaTime * multiplier
        }
        
        if let firstEnemy = enemies.first {
            if enemies.count > 4 {
                firstEnemy.removeFromParent()
                enemies.removeFirst()
            }
        }
        
        // Update move speed
        moveSpeedMultiplier = (multiplier - 1) * 1.5 + 1
    }
    
    func reset() {
        for enemy in enemies {
            enemy.removeFromParent()
        }
        enemies.removeAll()
        currentTime = interval
    }
}
