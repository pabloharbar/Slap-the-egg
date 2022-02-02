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
                    EggShellLabel(money: $gameManager.money).offset(x: -15, y: -5)
                }
                Spacer()
                MenuLabel()

                ScoreLabel(score: $gameManager.score)
                    .opacity(Double(gameManager.alpha))
                Spacer()
                
            }
        }
        .onReceive(gameManager.scene.scorePublisher, perform: { target in
            gameManager.score = target
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
