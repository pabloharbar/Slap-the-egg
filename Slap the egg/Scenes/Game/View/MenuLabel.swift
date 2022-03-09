//
//  MenuLabel.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 02/02/22.
//

import SwiftUI

struct MenuLabel: View {
    @EnvironmentObject var gameManager: GameManager
    var body: some View {
        HStack(spacing: 14) {
            Button(action: {
                SoundsManager.instance.playSound(sound: .mouthPop, soundEnabled: gameManager.playerData.preferences.soundEnable)
                gameManager.menuStatus = .shop
                gameManager.scene.holdScene()
            }) {
                Image("storeButton")
            }
            Button(action: {
                SoundsManager.instance.playSound(sound: .mouthPop, soundEnabled: gameManager.playerData.preferences.soundEnable)
                gameManager.menuStatus = .leaderboard
            }) {
                Image("leaderboardButton")
            }
//            Button(action: {
//                SoundsManager.instance.playSound(sound: .mouthPop, soundEnabled: gameManager.playerData.preferences.soundEnable)
//                gameManager.menuStatus = .achievements
//            }) {
//                Image("achievementsButton")
//            }
            Button(action: {
                SoundsManager.instance.playSound(sound: .mouthPop, soundEnabled: gameManager.playerData.preferences.soundEnable)
                gameManager.menuStatus = .settings
                gameManager.scene.holdScene()
            }) {
                Image("settingsButton")
            }
        }
    }
}

struct MenuLabel_Previews: PreviewProvider {
    static var previews: some View {
        MenuLabel()
            .environmentObject(GameManager())
    }
}
