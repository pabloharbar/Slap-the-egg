//
//  MenuLabel.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 02/02/22.
//

import SwiftUI

struct MenuLabel: View {
    @Binding var menuStatus: MenuList
    var body: some View {
        HStack(spacing: 28) {
            Button(action: {
                menuStatus = .shop
            }) {
                Image("storeButton")
            }
            Button(action: {
                menuStatus = .leaderboard
            }) {
                Image("leaderboardButton")
            }
            Button(action: {
                menuStatus = .settings
            }) {
                Image("settingsButton")
            }
        }
    }
}

struct MenuLabel_Previews: PreviewProvider {
    static var previews: some View {
        MenuLabel(menuStatus: .constant(.hidden))
    }
}
