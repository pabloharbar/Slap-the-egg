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
            BackgroundView(Colors: [
                "settingsColor",
                "settingsLightColor",
                "settingsLightestColor"
            ], width: 332, height: 400)
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
                            ZStack {
                                Ellipse()
                                    .frame(width: 85, height: 50)
                                    .foregroundColor(gameManager.difficultySelected == .easy ? Color("settingsOffColor") : Color("settingsOnColor"))
                                Text("\(gameManager.difficultySelected.rawValue) ")
                                    .foregroundColor(gameManager.difficultySelected == .easy ? Color("settingsOnColor") : Color("settingsOffColor"))
                            }
                        }
                        .padding(.trailing)
                    }
                    HStack {
                        Text("Sounds ")
                        Spacer()
                        Button(action: {
                            let data = gameManager.playerData
                            data.preferences.soundEnable.toggle()
                            gameManager.playerData = data
                            gameManager.scene.soundEnabled = data.preferences.soundEnable
                            gameManager.saveData()
                        }) {
                            ZStack {
                                Ellipse()
                                    .frame(width: 85, height: 50)
                                    .foregroundColor(gameManager.playerData.preferences.soundEnable ? Color("settingsOnColor") : Color("settingsOffColor"))
                                Text(gameManager.playerData.preferences.soundEnable ? "On " : "Off ")
                                    .foregroundColor(gameManager.playerData.preferences.soundEnable ? Color("settingsOffColor") : Color("settingsOnColor"))
                            }
                        }
                        .padding(.trailing)
                    }
                    HStack {
                        Text("Vibration ")
                        Spacer()
                        Button(action: {
                            let data = gameManager.playerData
                            data.preferences.vibrationEnable.toggle()
                            gameManager.playerData = data
                            gameManager.scene.vibrationEnabled = data.preferences.vibrationEnable
                            gameManager.saveData()
                        }) {
                            ZStack {
                                Ellipse()
                                    .frame(width: 85, height: 50)
                                    .foregroundColor(gameManager.playerData.preferences.vibrationEnable ? Color("settingsOnColor") : Color("settingsOffColor"))
                                Text(gameManager.playerData.preferences.vibrationEnable ? "On " : "Off ")
                                    .foregroundColor(gameManager.playerData.preferences.vibrationEnable ? Color("settingsOffColor") : Color("settingsOnColor"))
                            }
                        }
                        .padding(.trailing)
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
