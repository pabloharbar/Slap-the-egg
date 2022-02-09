//
//  ShopManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 09/02/22.
//

import SwiftUI

class ShopManager: ObservableObject {
    @Published var cosmeticPage = 0
    
    init() {
        
    }
    
    @ViewBuilder func getShopItemsCategory() -> some View {
        ScrollView {
            VStack {
                switch cosmeticPage {
                case 0:
                    ForEach(Cosmetics.Eggs.allCases, id: \.self) { egg in 
                        ShopEggCard(egg: CosmeticsBank.shared.eggsAvailable.filter {
                            $0.cosmeticsType == egg
                        }.first!)
                    }
                case 1:
                    ForEach(Cosmetics.Backgrounds.allCases, id: \.self) { background in
                        BackgroundCard(background: CosmeticsBank.shared.backgroundsAvailable.filter {
                            $0.cosmeticsType == background
                        }.first!)
                    }
                case 2:
                    ForEach(Cosmetics.Eggs.allCases, id: \.self) { egg in
                        ShopEggCard(egg: CosmeticsBank.shared.eggsAvailable.filter { $0.cosmeticsType == egg }.first!)
                    }
                default:
                    ForEach(Cosmetics.Eggs.allCases, id: \.self) { egg in
                        ShopEggCard(egg: CosmeticsBank.shared.eggsAvailable.filter { $0.cosmeticsType == egg }.first!)
                    }
                }
            }
        }
    }
}

