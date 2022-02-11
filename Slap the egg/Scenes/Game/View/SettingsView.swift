//
//  SettingsView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameManager: GameManager
    let settingsTitle:LocalizedStringKey = "settingsTitle"
    let difficulty:LocalizedStringKey = "difficulty"
    let sounds:LocalizedStringKey = "sounds"
    let vibration:LocalizedStringKey = "vibration"
    var body: some View {
        ZStack {
            BackgroundView(Colors: [
                "settingsColor",
                "settingsLightColor",
                "settingsLightestColor"
            ], width: 332, height: 400)
            VStack(spacing: 32) {
                Text(settingsTitle)
                    .font(.custom("Bangers-Regular", size: 64))
                VStack(spacing: 45) {
                    HStack {
                        Text(difficulty)
                        Spacer()
                        Button(action: {
                            switch gameManager.difficultySelected {
                            case .easy:
                                gameManager.difficultySelected = .hard
                            case .hard :
                                gameManager.difficultySelected = .easy
                            }
                        }) {
                            Text("\(gameManager.difficultySelected.rawValue) ")
                        }
                        .padding(.trailing)
                    }
                    HStack {
                        Text(sounds)
                        Spacer()
                    }
                    HStack {
                        Text(vibration)
                        Spacer()
                    }
                }
            }
            .foregroundColor(.white)
            .font(.custom("Bangers-Regular", size: 36))
            .frame(maxWidth: 300)
            
            Button(action: {
                gameManager.menuStatus = .hidden
                gameManager.scene.resumeScene()
            }) {
                Image("dismissSettings")
            }
            .offset(x: -130, y: -160)

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(GameManager())
    }
}
