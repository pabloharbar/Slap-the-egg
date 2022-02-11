//
//  ShopEggCard.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import SwiftUI

struct ShopEggCard: View {
    @EnvironmentObject var gameManager: GameManager
    let egg: Egg
    let selectedItem:LocalizedStringKey = "selectedItem"
    let eggSize:LocalizedStringKey = "eggSize"
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Image(egg.image)
                    .resizable()
                .frame(width: 50, height: 72)
            }
            .frame(maxWidth: 80)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(egg.animal) ")
                    .font(.custom("Bangers-Regular", size: 24))
                Text(eggSize)
                SizeView(eggSize: egg.size)
            }
            .frame(maxWidth: 220)
            .foregroundColor(Color("modalLabelColor"))
            
            VStack {
                Button(action: {
                    gameManager.processEggPurchase(egg: egg.cosmeticsType)
                }) {
                    if gameManager.playerData.selectedEgg == egg.cosmeticsType {
                        Text(selectedItem)
                            .foregroundColor(Color("menuLabelColor"))
                            .font(.custom("Bangers-Regular", size: 12))
                            .padding(.horizontal,6)
                    } else {
                        if gameManager.playerData.eggsUnlocked.contains(egg.cosmeticsType) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color("menuLabelColor"))
                        } else {
                            HStack {
                                Image("eggShell")
                                    .resizable()
                                    .frame(width: 12.75, height: 13.5)
                                Text("\(egg.eggShellCost) ")
                                    .font(.custom("Bangers-Regular", size: 14))
                            }
                            .padding(.horizontal,6)
                        }
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: 100)
                .background(
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 24)
                            .foregroundColor(Color(gameManager.playerData.selectedEgg == egg.cosmeticsType ? "settingsColor" : "settingsLightestColor"))
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 22)
                            .foregroundColor(Color(gameManager.playerData.selectedEgg == egg.cosmeticsType ? "settingsLightestColor" :"settingsColor"))
                            .padding(.trailing, 3)
                    }
                )
                Spacer()
                PowerUpView(powerUps: egg.powerUp)
                Spacer()
            }
//            .padding(.horizontal)
        }
        .padding()
        .frame(width: 300, height: 110)
        .background(Color("shopLightColor"))
        .cornerRadius(20)
    }
}

struct PowerUpView: View {
    let life:LocalizedStringKey = "life"
    let pointCount:LocalizedStringKey = "pointCount"
    let powerUps: [PowerUp]
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(powerUps, id: \.self) { powerUp in
                switch powerUp.powerUpType {
                case .multiplicate2x,.multiplicate3x,.multiplicate5x:
                    HStack(spacing: 6) {
                        ZStack {
                            Circle().foregroundColor(Color("powerUpYellow")).frame(width: 18, height: 18)
                            Text("x\(powerUp.value) ")
                                .font(.custom("Bangers-Regular", size: 12))
                                .foregroundColor(Color("menuLabelColor"))
                        }
                        Text(pointCount)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                case.revive1,.revive2:
                    HStack(spacing: 6) {
                        ZStack {
                            Circle().foregroundColor(Color("powerUpGreen")).frame(width: 18, height: 18)
                            Text("+\(powerUp.value) ")
                                .font(.custom("Bangers-Regular", size: 12))
                                .foregroundColor(Color("menuLabelColor"))
                        }
                        Text(life)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct SizeView: View {
    let eggSize: EggSizes
    var body: some View {
        HStack(alignment: .bottom) {
            Image("eggSize")
                .resizable()
                .frame(width: 10.5, height: 14)
//                .opacity(eggSize == .small ? 1 : 0.4)
            Image("eggSize")
                .resizable()
                .frame(width: 16.5, height: 22)
                .opacity(eggSize == .medium || eggSize == .big ? 1 : 0.4)
            Image("eggSize")
                .resizable()
                .frame(width: 24, height: 32)
                .opacity(eggSize == .big ? 1 : 0.4)
        }
    }
}

struct ShopEggCard_Previews: PreviewProvider {
    static var previews: some View {
        ShopEggCard(egg: CosmeticsBank.shared.eggsAvailable[0])
            .environmentObject(GameManager())
    }
}
