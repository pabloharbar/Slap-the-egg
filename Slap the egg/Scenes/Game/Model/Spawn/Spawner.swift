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
    case shovel
    
    static func random(shovelEnabled: Bool) -> Enemies {
        var sortLimit = Enemies.allCases.count
        if !shovelEnabled {
            sortLimit = Enemies.allCases.count - 1
        }
        let sorted = Int.random(in: 0..<sortLimit)
        switch sorted {
        case 0:
            return .knife
        case 1:
            return .spoon
        case 2:
            return .spatula
        case 3:
            return .shovel
        default:
            return .knife
        }
    }
}

class Spawner {
    private var spawner: SKNode!
    private var parent: SKNode
    private var moveSpeedMultiplier: CGFloat = 1
    
    private var enemies = [SKNode]()
    var shovelEnabled: Bool = false
    
//    private var interval = TimeInterval(4)
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
        let enemy = Enemies.random(shovelEnabled: shovelEnabled)
        switch enemy {
        case .shovel:
            spawnShovel(inversed: false)
            spawnShovel(inversed: true)
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
    
    func spawnShovel(inversed: Bool) {
        let new = spawner.childNode(withName: "shovelModel")!.copy() as! SKNode
//        let copy = spawner.childNode(withName: "shovelModel")!.copy() as! SKNode
        
        let shovel = new.childNode(withName: "shovel")!
        new.position = startPosition
        
//        let inversed = Bool.random()
        if inversed {
            shovel.position.x = -shovel.position.x
            shovel.zRotation = .pi
        }
        // Path Setup
        let path = generateShortPath(node: new.childNode(withName: "shovel") as! SKSpriteNode)
        let dashes: [CGFloat] = [20,40]
        let dashedPath = path.cgPath.copy(dashingWithPhase: 10, lengths: dashes)
        let pathNode = SKShapeNode(path: dashedPath)
        pathNode.strokeColor = .gray
        pathNode.lineWidth = 10
        pathNode.zPosition = -5
        pathNode.lineCap = .round
        
        // Animation Setup
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 200 * moveSpeedMultiplier)
        let animation = SKAction.repeatForever(move)
        
        // Add sprites
        parent.addChild(new)
        new.addChild(pathNode)
        shovel.position = pathNode.position
//        new.childNode(withName: "shovel")!.zRotation = .pi / 2
        shovel.run(animation)
        enemies.append(new)
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
        pathNode.zPosition = -5
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
        pathNode.zPosition = -5
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
        pathNode.zPosition = -5
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
    
    func generateShortPath(node: SKSpriteNode) -> UIBezierPath {
        let start = node.position
        var end = CGPoint()
        if node.position.x > 0 {
            end =  CGPoint(x: node.position.x - 300, y: node.position.y)
        } else {
            end = CGPoint(x: node.position.x + 300, y: node.position.y)
        }
        let path = UIBezierPath()
//        path.move(to: start)
//        path.addLine(to: end)
        path.move(to: end)
        path.addLine(to: start)
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
