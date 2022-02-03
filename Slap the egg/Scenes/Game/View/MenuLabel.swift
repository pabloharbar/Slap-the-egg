//
//  MenuLabel.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 02/02/22.
//

import SwiftUI

struct MenuLabel: View {
    var body: some View {
        HStack {
            Image("storeButton")
            Image("leaderboardButton")
            Image("settingsButton")
            
        }
    }
}

struct MenuLabel_Previews: PreviewProvider {
    static var previews: some View {
        MenuLabel()
    }
}
