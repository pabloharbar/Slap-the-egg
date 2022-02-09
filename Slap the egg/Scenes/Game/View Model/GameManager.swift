//
//  GameManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 02/02/22.
//

import SwiftUI
import SpriteKit
import GameKit

enum MenuList {
    case hidden
    case shop
    case leaderboard
    case settings
}

enum Difficulty: String, Codable {
    case easy = "Easy"
    case hard = "Hard"
}

class GameManager: ObservableObject {
    
    @Published var difficultySelected: Difficulty = .easy
    
    static var gameSpeed = CGFloat(500)
    
    var scene: GameScene
    
    @Published var score = 0
    @Published var money = 0
    @Published var record: Int
    
    @Published var gameStatus: GameStatus = .menu
    
    @Published var menuStatus: MenuList = .hidden
    
    private var gcEnabled = Bool() // Check if the user has Game Center enabled
    private var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    init() {
        scene = SKScene(fileNamed: "GameScene") as! GameScene
        scene.scaleMode = .aspectFill 
        let data = UserDefaultsWrapper.fetchRecord()
        record = data?.highscore ?? 0
        money = data?.money ?? 0
    }
    
    func updateData() {
        money += score / 10
        if score > record {
            record = score
        }
        UserDefaultsWrapper.setRecord(model: PlayerData(highscore: record, money: money))
        let data = UserDefaultsWrapper.fetchRecord()
        money = data?.money ?? 0
        record = data?.highscore ?? 0
        saveRecord(with: record)
    }
    
    func displayScoreBoard() -> Double {
        return gameStatus == .playing ? 1 : 0
    }
    
    func displayRecord() -> Double {
        return gameStatus == .menu || gameStatus == .gameOver ? 1 : 0
    }
    
    func authenticatePlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if (localPlayer.isAuthenticated) {
                
                // Player is already authenticated and logged in
                self.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                 })
                
            }
            else {
                // Game center is not enabled on the user's device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    func saveRecord(with value:Int) {
        if (self.gcEnabled) {
            GKLeaderboard.submitScore(value, context:0, player: GKLocalPlayer.local, leaderboardIDs: [self.gcDefaultLeaderBoard], completionHandler: {error in})
            print("submitted")
        }
    }
}
