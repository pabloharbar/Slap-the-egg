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
    
    var intertitialManager = InterstitialManager()
    
    @Published var difficultySelected: Difficulty = .easy
    
    static var gameSpeed = CGFloat(500)
    
    var PowerUpMultiplicator = 1
    
    var scene: GameScene
    
    @Published var playerData: PlayerData
    
    @Published var hasSeenAd: Bool = false
    
    @Published var timeOut: Bool = false
    let timeOutInterval = TimeInterval(2)
    
    var hasDied: Bool = false
    
    @Published var score = 0
    
    @Published var gameStatus: GameStatus = .menu {
        didSet {
            if self.gameStatus == .playing && !hasSeenAd {
                AnalyticsManager.logEventWithValue(eventName: AnalyticsEvents.playWithEgg.rawValue, value: CGFloat(playerData.selectedEgg.rawValue))
                AnalyticsManager.logEventWithValue(eventName: AnalyticsEvents.playWithBackground.rawValue, value: CGFloat(playerData.selectedBackground.rawValue))
                if difficultySelected == .hard {
                    AnalyticsManager.logEvent(eventName: AnalyticsEvents.playedInHardMode.rawValue)
                }
            }
        }
    }
    
    @Published var menuStatus: MenuList = .hidden
    
    private var gcEnabled = Bool() // Check if the user has Game Center enabled
    private var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    init() {
        scene = SKScene(fileNamed: "GameScene") as! GameScene
        scene.scaleMode = .aspectFill 
        playerData = UserDefaultsWrapper.fetchRecord() ?? PlayerData(highscore: 0, money: 0)
    }
    
    func processEggPurchase(egg: Eggs) {
        if playerData.eggsUnlocked.contains(egg) {
            let data = playerData
            data.selectedEgg = egg
            scene.loadPlayerData(data: data)
            playerData = data
            saveData()
        } else {
            let item = CosmeticsBank.shared.eggsAvailable.filter { $0.cosmeticsType == egg }.first!
            if playerData.money >= item.eggShellCost {
                // Analytics - Compra do 1 ovo
                if playerData.eggsUnlocked.count <= 1 {
                    AnalyticsManager.logEvent(eventName: AnalyticsEvents.firstEggPurchase.rawValue)
                }
                
                playerData.money -= item.eggShellCost
                playerData.eggsUnlocked.append(egg)
                AnalyticsManager.logEvent(eventName: AnalyticsEvents.eggPurchase.rawValue)
                saveData()
            }
        }
    }
    
    func processBackgroundPurchase(background: Backgrounds) {
        if playerData.backgroundsUnlocked.contains(background) {
            let data = playerData
            data.selectedBackground = background
            scene.loadPlayerData(data: data)
            playerData = data
            saveData()
        } else {
            let item = CosmeticsBank.shared.backgroundsAvailable.filter { $0.cosmeticsType == background }.first!
            if playerData.money >= item.eggShellCost {
                // Analytics - 1 background
                if playerData.backgroundsUnlocked.count <= 1 {
                    AnalyticsManager.logEvent(eventName: AnalyticsEvents.firstBackgroundPurchase.rawValue)
                }
                
                playerData.money -= item.eggShellCost
                playerData.backgroundsUnlocked.append(background)
                AnalyticsManager.logEvent(eventName: AnalyticsEvents.backgroundPurchase.rawValue)
                saveData()
            }
        }
    }
    
    func processPowerUpPurchase(powerUp: PowerUpType) {
        let cost = PowerUpsAvailable.powerUps.filter { $0.powerUpType == powerUp }.first!.eggShellCost
        if !playerData.activePowerUps.contains(powerUp) && playerData.money >= cost {
            let data = playerData
            data.activePowerUps.append(powerUp)
            // Analytics
            if powerUp == .revive1 {
                AnalyticsManager.logEvent(eventName: AnalyticsEvents.purchaseRevivePowerUp.rawValue)
            } else if powerUp == .multiplicate2x {
                AnalyticsManager.logEvent(eventName: AnalyticsEvents.purchaseDoublePowerUp.rawValue)
            }
            
            for powerUp in data.activePowerUps {
                switch powerUp {
                case .multiplicate2x:
                    PowerUpMultiplicator = 2
                case .multiplicate3x:
                    PowerUpMultiplicator = 3
                case .multiplicate5x:
                    PowerUpMultiplicator = 5
                default:
                    continue
                }
            }
            data.money -= cost
            scene.loadPlayerData(data: data)
            playerData = data
            saveData()
        }
    }
    
    
    
    func applyPowerUps() {
        let eggData = CosmeticsBank.shared.eggsAvailable.filter { $0.cosmeticsType == playerData.selectedEgg}.first!
        for powerUp in eggData.powerUp {
            switch powerUp.powerUpType {
            case .multiplicate2x:
                PowerUpMultiplicator = 2
            case .multiplicate3x:
                PowerUpMultiplicator = 3
            case .multiplicate5x:
                PowerUpMultiplicator = 5
            case .revive1, .revive2:
                scene.applyPowerUp(item: powerUp.powerUpType)
            }
            let data = playerData
            if data.activePowerUps.contains(powerUp.powerUpType) && powerUp.powerUpType == .revive1 {
                data.activePowerUps = data.activePowerUps.filter { $0 != .revive1}
                data.activePowerUps.append(.revive2)
            } else {
                data.activePowerUps.append(powerUp.powerUpType)
            }
            playerData = data
        }
    }
    
    func containsMultiplier() -> Bool {
        for item in playerData.activePowerUps {
            switch item {
            case .multiplicate2x, .multiplicate3x, .multiplicate5x:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    func getBiggestMultiplier() -> Int {
        var value = 1
        for item in playerData.activePowerUps {
            switch item {
            case .multiplicate2x:
                if value < 2 {
                    value = 2
                }
            case .multiplicate3x:
                if value < 3 {
                    value = 3
                }
            case .multiplicate5x:
                if value < 5 {
                    value = 5
                }
            default:
                continue
            }
        }
        return value
    }
    
    func clearPowerUps() {
        playerData.activePowerUps.removeAll()
        print(playerData.activePowerUps)
        saveData()
    }
    
    func updateData() {
        playerData.money += PowerUpMultiplicator * score / 10
        PowerUpMultiplicator = 1
        if score > playerData.highscore {
            playerData.highscore = score
        }
        saveData()
        saveRecord(with: playerData.highscore)
    }
    
    func saveData() {
        UserDefaultsWrapper.setRecord(model: playerData)
        let data = UserDefaultsWrapper.fetchRecord() ?? PlayerData(highscore: 0, money: 0)
        playerData = data
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
    
    func revive() {
        scene.reviveScene()
        hasSeenAd = true
    }
    
    func getAdPowerUp(powerUp: PowerUpType) {
        playerData.activePowerUps.append(powerUp)
        saveData()
    }
    
    func timeOutTouches() {
        timeOut = true
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOutInterval) {
            self.timeOut = false
        }
    }
    
    func interstitialDisplay() {
        
    }
}
