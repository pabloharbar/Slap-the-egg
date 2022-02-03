//
//  MenuLabel.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 02/02/22.
//

import SwiftUI

struct MenuLabel: View {
    @Binding var leaderboardVisible: Bool
    var body: some View {
        HStack(spacing: 28) {
//            Button(action: {}) {
//                Image("storeButton")
//            }
            Button(action: {
                leaderboardVisible.toggle()
            }) {
                Image("leaderboardButton")
            }
//            Button(action: {}) {
//                Image("settingsButton")
//            }
        }
    }
}

struct MenuLabel_Previews: PreviewProvider {
    static var previews: some View {
        MenuLabel(leaderboardVisible: .constant(true))
    }
}
