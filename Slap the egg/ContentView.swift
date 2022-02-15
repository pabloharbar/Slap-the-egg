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
                guard let index = gameManager.playerData.activePowerUps.firstIndex(where: { $0 == .revive1}) else { return }
                gameManager.playerData.activePowerUps.remove(at: index)
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
                }
                playing = false
    
            } else if status == .playing {
                print(gameManager.playerData.activePowerUps)
                gameManager.applyPowerUps()
                playing = true
                multiplier = gameManager.getBiggestMultiplier()
            }
        })
        .onAppear {
            gameManager.authenticatePlayer()
        }
    }
    
    @ViewBuilder func menuDisplay() -> some View {
        if gameManager.gameStatus == .gameOver {
            VStack(spacing: 0) {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            EggShellLabel(money: $gameManager.playerData.money)
                                .offset(x: -15, y: -5)
                        }
                        Spacer()
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
                                SoundsManager.instance.playSound(sound: .mouthPop)
                                gameManager.menuStatus = .shop
                                gameManager.scene.holdScene()
                            }) {
                                HStack {
                                    Image("double")
                                        .scaleEffect(0.8)
                                    Text("\(NSLocalizedString("Watch a short ad to double your coins!", comment: ""))")
                                        .foregroundColor(Color("menuLightColor"))
                                        .font(Font.custom("Bangers-Regular", size: 22))
                                    Image("spikeGreen")
                                   
                                } .padding(.top, 5)
                                .background(
                                    ZStack (alignment: .bottomLeading) {
                                        RoundedRectangle(cornerRadius: 30)
                                            .frame(width: 350, height: 120)
                                            .foregroundColor(Color("powerUpGreen"))
                                        RoundedRectangle(cornerRadius: 30)
                                            .frame(width: 340, height: 115)
                                            .foregroundColor(Color("darkerGreen"))
                                            .padding(.trailing, 3)
                                    }
                                )
                                .frame(maxWidth: 330)
                            }
                        }
                        Button(action: {
                            SoundsManager.instance.playSound(sound: .mouthPop)
                            gameManager.scene.resetToIntro()
                        }) {
                            Image("retry")
                                .scaleEffect(0.8)
                        }
                    }
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
