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
    case achievements
    case settings
}

enum Difficulty: String, Codable {
    case easy = "Easy"
    case hard = "Hard"
}

enum Achievements: Int, Codable {
    case hundredPoints = 1
    case fiveHundredPoints = 2
    case thousandPoints = 3
    case tenDeaths = 4
    case hundredDeaths = 5
    case tenFry = 6
    case tenSpoon = 7
    case tenSpatula = 8
    case tenKnife = 9
    case tenToaster = 10
    case allEggs = 11
    case allBackgrounds = 12
    case tenPowerUps = 13
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
    let timeOutInterval = TimeInterval(1)
    
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
                if playerData.eggsUnlocked.count == CosmeticsBank.shared.eggsAvailable.count {
                    unlockAchievement(achievement: .allEggs)
                    playerData.achievements.append(.allEggs)
                }
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
                if playerData.backgroundsUnlocked.count == CosmeticsBank.shared.backgroundsAvailable.count {
                    unlockAchievement(achievement: .allBackgrounds)
                    playerData.achievements.append(.allBackgrounds)
                }
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
            playerData.powerUpsBought += 1
            if playerData.powerUpsBought <= 10 {
                updateAchievements(achievement: .tenPowerUps, percentage: Double(playerData.powerUpsBought) / 10.0)
                if playerData.powerUpsBought == 10 {
                    playerData.achievements.append(.tenPowerUps)
                }
            }
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
            case .revive1, .revive2, .shovelEnemy, .coinsSpawn:
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
        //Achievements related to score
        if score >= 100 {
            if !playerData.achievements.contains(Achievements.hundredPoints) {
                playerData.achievements.append(Achievements.hundredPoints)
                unlockAchievement(achievement: Achievements.hundredPoints)
            }
            if score >= 500 {
                if !playerData.achievements.contains(Achievements.fiveHundredPoints) {
                    playerData.achievements.append(Achievements.fiveHundredPoints)
                    unlockAchievement(achievement: Achievements.fiveHundredPoints)
                }
                if score >= 1000 {
                    if !playerData.achievements.contains(Achievements.thousandPoints) {
                        playerData.achievements.append(Achievements.thousandPoints)
                        unlockAchievement(achievement: Achievements.thousandPoints)
                    }
                }
            }
        }
        saveData()
        saveRecord(with: playerData.highscore)
//        print(playerData.achievements)
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
                        // Check IOS 14.8 colocar breakpoint, testar com device
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
    
    func unlockAchievement(achievement: Achievements) {
        let achievementItem = GKAchievement(identifier: "achievement\(achievement.rawValue)")
        achievementItem.percentComplete = 100
        achievementItem.showsCompletionBanner = true
        GKAchievement.report([achievementItem]) { error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            print("done!")
            print(self.playerData.achievements)
            print(achievementItem)
        }
    }
    
    func handleDeathEvents(value: Int) {
        switch value {
        case 0:
            // Pan
            playerData.deadToPanTimes += 1
            if playerData.deadToPanTimes <= 10 {
                updateAchievements(achievement: .tenFry, percentage: Double(playerData.deadToPanTimes) / 10.0)
                if playerData.deadToPanTimes == 10 {
                    playerData.achievements.append(.tenFry)
                }
            }
        case 1:
            // Toast
            playerData.deadToToast += 1
            if playerData.deadToToast <= 10 {
                updateAchievements(achievement: .tenToaster, percentage: Double(playerData.deadToToast) / 10.0)
                if playerData.deadToToast == 10 {
                    playerData.achievements.append(.tenToaster)
                }
            }
        case 2:
            // Knife
            playerData.deadToKnife += 1
            if playerData.deadToKnife <= 10 {
                updateAchievements(achievement: .tenKnife, percentage: Double(playerData.deadToKnife) / 10.0)
                if playerData.deadToKnife == 10 {
                    playerData.achievements.append(.tenKnife)
                }
            }
        case 3:
            // Spoon
            playerData.deadToSpoonTimes += 1
            if playerData.deadToSpoonTimes <= 10 {
                updateAchievements(achievement: .tenSpoon, percentage: Double(playerData.deadToSpoonTimes) / 10.0)
                if playerData.deadToSpoonTimes == 10 {
                    playerData.achievements.append(.tenSpoon)
                }
            }
        case 4:
            // Spatula
            playerData.deadToSpatula += 1
            if playerData.deadToSpatula <= 10 {
                updateAchievements(achievement: .tenSpatula, percentage: Double(playerData.deadToSpatula) / 10.0)
                if playerData.deadToSpatula == 10 {
                    playerData.achievements.append(.tenSpatula)
                }
            }
        default:
            break
        }
        let totalDeaths = playerData.deadToKnife + playerData.deadToToast + playerData.deadToSpatula + playerData.deadToSpoonTimes + playerData.deadToPanTimes
        if totalDeaths <= 10 {
            updateAchievements(achievement: .tenDeaths, percentage: Double(totalDeaths)/10.0)
            updateAchievements(achievement: .hundredDeaths, percentage: Double(totalDeaths)/100.0)
            if totalDeaths == 10 {
                playerData.achievements.append(.tenDeaths)
            }
        } else if totalDeaths <= 100 {
            updateAchievements(achievement: .hundredDeaths, percentage: Double(totalDeaths)/100.0)
            if totalDeaths == 100 {
                playerData.achievements.append(.hundredDeaths)
            }
        }
        saveData()
    }
    
    func updateAchievements(achievement: Achievements, percentage: Double) {
        let achievementItem = GKAchievement(identifier: "achievement\(achievement.rawValue)")
        achievementItem.percentComplete = 100 * percentage
        
        print("\(100 * percentage)")
        print(percentage)
        achievementItem.showsCompletionBanner = true
        GKAchievement.report([achievementItem]) { error in
            print("update achievement")
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            print("done!")
            print(self.playerData.achievements)
            print(self.playerData)
        }
    }
}
