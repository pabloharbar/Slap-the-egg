//
//  ShopView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var gameManager: GameManager
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Text("Shop ")
                    .font(.custom("Bangers-Regular", size: 64))
                    .padding(.top)

                Spacer()
            }
            .foregroundColor(.white)
            .font(.custom("Bangers-Regular", size: 36))
            .frame(maxWidth: 300, maxHeight: 480)
            .background(
                Image("shopBackground")
            )
            
            Button(action: {
                gameManager.menuStatus = .hidden
                gameManager.scene.resumeScene()
            }) {
                Image("dismissShop")
            }
            .offset(x: -130, y: -190)

        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
            .environmentObject(GameManager())
    }
}
