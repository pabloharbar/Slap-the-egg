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
        HStack(spacing: 28) {
            Button(action: {
                SoundsManager.instance.playSound(sound: .mouthPop)
                gameManager.menuStatus = .shop
                gameManager.scene.holdScene()
            }) {
                Image("storeButton")
            }
            Button(action: {
                SoundsManager.instance.playSound(sound: .mouthPop)
                gameManager.menuStatus = .leaderboard
            }) {
                Image("leaderboardButton")
            }
            Button(action: {
                SoundsManager.instance.playSound(sound: .mouthPop)
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
