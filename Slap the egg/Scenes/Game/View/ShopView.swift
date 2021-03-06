//
//  ShopView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var adManager: AdRewardManager
    @StateObject var shopManager = ShopManager()
    let storeTitle:LocalizedStringKey = "storeTitle"
    var body: some View {
        ZStack {
            BackgroundView(Colors: [
                "shopColor",
                "shopLightColor",
                "shopLightestColor"
            ], width: 360, height: 500)
            VStack(spacing: 0) {
                Text(storeTitle)
                    .font(.custom("Bangers-Regular", size: 64))
                    .foregroundColor(Color("menuLabelColor"))
                    .padding(.vertical)
                HStack {
                    ShopTabButton(pageSelected: $shopManager.cosmeticPage, pageIndex: 0, label: NSLocalizedString("Eggs", comment: ""))
                    ShopTabButton(pageSelected: $shopManager.cosmeticPage, pageIndex: 1, label: NSLocalizedString("Power ups", comment: ""))
                    ShopTabButton(pageSelected: $shopManager.cosmeticPage, pageIndex: 2, label: NSLocalizedString("Backgrounds", comment: ""))
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
                    if gameManager.menuStatus == .shop {
                        shopManager.getShopItemsCategory()
                            .padding()
                            .frame(maxHeight: 480)
                            .environmentObject(gameManager)
                            .environmentObject(adManager)
                    }
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
            .environmentObject(AdRewardManager())
    }
}
