//
//  ShopManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 09/02/22.
//

import SwiftUI

class ShopManager: ObservableObject {
    @Published var cosmeticPage = 0
//    let defaultEgg = Egg(animal: NSLocalizedString("Chicken", comment: ""),
//                         image: "chickenEgg",
//                         powerUp: [],
//                         cosmeticsType: .chicken,
//                         eggShellCost: 0,
//                         size: .medium)
     
    init() {
        
    }
    
    @ViewBuilder func getShopItemsCategory() -> some View {
        ScrollView {
            VStack {
                switch cosmeticPage {
                case 0:
                    ForEach(CosmeticsBank.shared.eggsAvailable, id: \.self) { egg in
                        ShopEggCard(egg: egg)
                    }
                case 1:
                    let powerUpsShopable = PowerUpsAvailable.powerUps.filter { $0.shopAvailable == true }
                    ForEach(powerUpsShopable, id: \.self) { powerUp in
                        PowerUpCard(powerUp: powerUp)
                    }
                case 2:
                    ForEach(CosmeticsBank.shared.backgroundsAvailable, id: \.self) { background in
                        BackgroundCard(background: background)
                    }
                default:
                    ForEach(CosmeticsBank.shared.eggsAvailable, id: \.self) { egg in
                        ShopEggCard(egg: egg)
                    }
                }
            }
        }
    }
}

