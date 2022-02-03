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
                Text(" \(gameManager.score) ")
                    .font(.custom("Bangers-Regular", size: 48))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.6))
                    .cornerRadius(20)
                    .opacity(gameManager.displayScoreBoard())
                Spacer()
            }
            Text(" Highest: \(gameManager.record) ")
                .font(.custom("Bangers-Regular", size: 36))
                .padding(.bottom, 80)
                .opacity(gameManager.displayRecord())
        }
        .onReceive(gameManager.scene.scorePublisher, perform: { target in
            gameManager.score = target
        })
        .onReceive(gameManager.scene.statusPublisher, perform: { status in
            gameManager.gameStatus = status
            if status == .gameOver {
                gameManager.updateRecord()
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
