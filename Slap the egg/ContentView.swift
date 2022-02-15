//
//  ContentView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 27/01/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var gameManager = GameManager()
    @StateObject var adManager = AdRewardManager()
    @State var playing = false
    @State var multiplier = 1
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameManager.scene)
                .ignoresSafeArea()
        
            VStack {
                HStack {
                    Spacer()
                    EggShellLabel(money: $gameManager.playerData.money)
                        .offset(x: -15, y: -5)
                        .opacity(gameManager.gameStatus == .menu ? 1 : 0)
                }
                Spacer()
            }
            
            VStack {
                ZStack {
                    
                    HStack {
                        if gameManager.containsMultiplier() {
                            let value = gameManager.getBiggestMultiplier()
                            ZStack {
                                Image("doubleIcon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .opacity(gameManager.displayScoreBoard())
                                Text("x\(value) ")
                                    .font(.custom("Bangers-Regular", size: 24))
                                    .opacity(gameManager.displayScoreBoard())
                            }
                        }
                        if gameManager.playerData.activePowerUps.contains(.revive2) {
                            Image("shieldIcon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .opacity(gameManager.displayScoreBoard())
                            Image("shieldIcon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .opacity(gameManager.displayScoreBoard())
                        }
                        if  gameManager.playerData.activePowerUps.contains(.revive1) {
                            Image("shieldIcon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .opacity(gameManager.displayScoreBoard())
                            
                        }
                        Spacer()
                    }
                    .padding()
                    ScoreLabel(score: $gameManager.score)
                        .opacity(gameManager.displayScoreBoard())
                }
                Spacer()
            }
            modalDisplay()
            menuDisplay()
        }
        .onReceive(gameManager.scene.scorePublisher, perform: { target in
            gameManager.score = target
        })
        .onReceive(gameManager.scene.revivePublisher, perform: { value in
            if value == 0 && gameManager.gameStatus == .playing {
//                guard let index = gameManager.playerData.activePowerUps.firstIndex(where: { $0 == .revive1}) else { return }
                let data = gameManager.playerData
                data.activePowerUps = gameManager.playerData.activePowerUps.filter { $0 != .revive1 }
                gameManager.playerData = data
            } else if value == 1 && gameManager.gameStatus == .playing {
                let data = gameManager.playerData
                data.activePowerUps = gameManager.playerData.activePowerUps.filter { $0 != .revive2 }
                data.activePowerUps.append(.revive1)
                gameManager.playerData = data
            } else if value == 2 && gameManager.gameStatus == .playing {
                let data = gameManager.playerData
                data.activePowerUps = gameManager.playerData.activePowerUps.filter { $0 != .revive1 }
                gameManager.playerData = data
            }
        })
        .onReceive(gameManager.scene.statusPublisher, perform: { status in
            gameManager.gameStatus = status
            gameManager.scene.difficulty = gameManager.difficultySelected
            if status == .gameOver {
                gameManager.updateData()
                if playing {
                    gameManager.clearPowerUps()
                    if gameManager.hasSeenAd {
                        gameManager.hasDied = true
                    }
                }
                playing = false
    
            } else if status == .playing {
                print(gameManager.playerData.activePowerUps)
                gameManager.applyPowerUps()
                gameManager.scene.vibrationEnabled = gameManager.playerData.preferences.vibrationEnable
                gameManager.scene.soundEnabled = gameManager.playerData.preferences.soundEnable
                playing = true
                multiplier = gameManager.getBiggestMultiplier()
            } else if status == .intro {
                if gameManager.hasSeenAd && gameManager.hasDied {
                    gameManager.hasSeenAd = false
                    gameManager.hasDied = false
                }
            }
        })
        .onAppear {
            gameManager.authenticatePlayer()
            adManager.LoadRewarded()
        }
    }
    
    @ViewBuilder func menuDisplay() -> some View {
        if gameManager.gameStatus == .gameOver {
            VStack(spacing: 0) {
                ZStack {
                    VStack {
                        HStack {
                            Button(action: {
                                SoundsManager.instance.playSound(sound: .mouthPop, soundEnabled: gameManager.playerData.preferences.soundEnable)
                                gameManager.scene.resetToIntro()
                            }) {
                                Image("retry")
                                    .scaleEffect(0.8)
                            }
                            Spacer()
                            EggShellLabel(money: $gameManager.playerData.money)
                                .offset(x: -15, y: -5)
                        }
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        BannerView().frame(width: 320, height: 50, alignment: .center)
                    }
                    
                   
                    VStack {
                        ScoreReviewLabel(sessionScore: $gameManager.score, multiplier: $multiplier)
                            .padding(.bottom,20)
                        Text("\(NSLocalizedString("Highest:", comment: "")) \(gameManager.playerData.highscore) ")
                            .font(.custom("Bangers-Regular", size: 36))
                        MenuLabel()
                            .environmentObject(gameManager)
                            .padding(.bottom, 20)
                       
                        ZStack {
                            Button(action: {
                                SoundsManager.instance.playSound(sound: .mouthPop, soundEnabled: gameManager.playerData.preferences.soundEnable)
                                adManager.showAd {
                                    gameManager.revive()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 48)).foregroundColor(Color("settingsColor"))
                                        .background(
                                            Image(systemName: "play.fill")
                                                .font(.system(size: 48)).foregroundColor(Color("settingsLightestColor"))
                                                .offset(x: 0.5, y: -3)
                                        )
                                    Text(NSLocalizedString("Watch a short ad to double your coins!", comment: ""))
                                        .foregroundColor(Color("menuLightColor"))
                                        .font(Font.custom("Bangers-Regular", size: 22))
                                    Image("spikePink")
                                   
                                } .padding(.top, 5)
                                .background(
                                    ZStack (alignment: .bottomLeading) {
                                        RoundedRectangle(cornerRadius: 30)
                                            .frame(width: 350, height: 110)
                                            .foregroundColor(Color("shopLightestColor"))
                                        RoundedRectangle(cornerRadius: 30)
                                            .frame(width: 340, height: 104)
                                            .foregroundColor(Color("shopColor"))
                                            .padding(.trailing, 3)
                                    }
                                )
                                .frame(maxWidth: 330)
                                .padding(.vertical)
                            }
                            .disabled(gameManager.hasSeenAd)
                            .opacity(gameManager.hasSeenAd ? 0.3 : 1)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .opacity(gameManager.displayRecord())
        } else {
            VStack(spacing: 0) {
                Text("\(NSLocalizedString("Highest:", comment: "")) \(gameManager.playerData.highscore) ")
                    .font(.custom("Bangers-Regular", size: 36))
                MenuLabel()
                    .padding(.bottom,40)
                    .environmentObject(gameManager)
            }
            .opacity(gameManager.displayRecord())
        }
    }
    
    @ViewBuilder func modalDisplay() -> some View {
        switch gameManager.menuStatus {
        case .shop:
            VStack {
                HStack {
                    Spacer()
                    EggShellLabel(money: $gameManager.playerData.money)
                        .offset(x: -15, y: -5)
                }
                Spacer()
            }
            ShopView()
                .environmentObject(gameManager)
                .environmentObject(adManager)
                .padding(.bottom, 50)
        case .leaderboard:
            LeaderboardView(menuStatus: $gameManager.menuStatus)
        case .settings:
            SettingsView()
                .environmentObject(gameManager)
        case .hidden:
            HStack {}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
