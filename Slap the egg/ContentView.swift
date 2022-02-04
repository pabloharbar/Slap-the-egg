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
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameManager.scene)
                .ignoresSafeArea()
        
            VStack {
                HStack {
                    Spacer()
                    EggShellLabel(money: $gameManager.money)
                        .offset(x: -15, y: -5)
                        .opacity(gameManager.gameStatus == .menu ? 1 : 0)
                }
                Spacer()
            }
            
            VStack {
                ScoreLabel(score: $gameManager.score)
                    .opacity(gameManager.displayScoreBoard())
                Spacer()
            }
            modalDisplay()
            menuDisplay()
        }
        .onReceive(gameManager.scene.scorePublisher, perform: { target in
            gameManager.score = target
        })
        .onReceive(gameManager.scene.statusPublisher, perform: { status in
            gameManager.gameStatus = status
            gameManager.scene.difficulty = gameManager.difficultySelected
            if status == .gameOver {
                gameManager.updateData()
            }
        })
        .onAppear {
            gameManager.authenticatePlayer()
        }
    }
    
    @ViewBuilder func menuDisplay() -> some View {
        if gameManager.gameStatus == .gameOver {
            VStack(spacing: 0) {
                ScoreReviewLabel(sessionScore: $gameManager.score)
                    .padding(.bottom,30)
                Text(" Highest: \(gameManager.record) ")
                    .font(.custom("Bangers-Regular", size: 36))
                MenuLabel()
                    .padding(.bottom,40)
                    .environmentObject(gameManager)
                EggShellLabel(money: $gameManager.money)
            }
            .opacity(gameManager.displayRecord())
        } else {
            VStack(spacing: 0) {
                Text(" Highest: \(gameManager.record) ")
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
            ShopView()
                .environmentObject(gameManager)
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
