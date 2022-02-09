//
//  ShopView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var gameManager: GameManager
    @StateObject var shopManager = ShopManager()
    var body: some View {
        ZStack {
            BackgroundView(Colors: [
                "shopColor",
                "shopLightColor",
                "shopLightestColor"
            ], width: 360, height: 500)
            VStack(spacing: 0) {
                Text("Store ")
                    .font(.custom("Bangers-Regular", size: 64))
                    .foregroundColor(Color("menuLabelColor"))
                    .padding(.vertical)
                HStack {
                    ShopTabButton(pageSelected: $shopManager.cosmeticPage, pageIndex: 0, label: "Eggs")
                    ShopTabButton(pageSelected: $shopManager.cosmeticPage, pageIndex: 1, label: "Power Ups")
                    ShopTabButton(pageSelected: $shopManager.cosmeticPage, pageIndex: 2, label: "Backgrounds")
                    Spacer()
                }
                ZStack(alignment: .topLeading) {
                    HStack {
                        Rectangle()
                            .foregroundColor(Color("shopMenuColor"))
                            .frame(maxWidth: 328, maxHeight: 480)
                            .cornerRadius(42, corners: [.bottomLeft,.bottomRight])
                        Spacer()
                    }
                    shopManager.getShopItemsCategory()
                        .padding()
                        .frame(maxHeight: 480)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: 360, maxHeight: 500)
            
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
