//
//  SettingsView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameManager: GameManager
    var body: some View {
        ZStack {
            Image("settingsBackground")
            VStack(spacing: 32) {
                Text("Settings ")
                    .font(.custom("Bangers-Regular", size: 64))
                VStack(spacing: 45) {
                    HStack {
                        Text("Difficulty ")
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
                        Text("GameCenter ")
                        Spacer()
                    }
                    HStack {
                        Text("Vibration ")
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
