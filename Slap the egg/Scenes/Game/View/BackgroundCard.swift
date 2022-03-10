//
//  BackgroundCard.swift
//  Slap the egg
//
//  Created by Pablo Penas on 09/02/22.
//

import SwiftUI

struct BackgroundCard: View {
    @EnvironmentObject var gameManager: GameManager
    let selectedItem:LocalizedStringKey = "selectedItem"
    let background: BackgroundModel
    var body: some View {
        HStack {
            Image(background.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 80)
                .clipped()
                .cornerRadius(10)
            Spacer()
            VStack(spacing: 20) {
                Text("\(background.name) ")
                    .font(.custom("Bangers-Regular", size: 24))
                    .foregroundColor(Color("menuLabelColor"))
                Button(action: {
                    gameManager.processBackgroundPurchase(background: background.cosmeticsType)
                }) {
                    if gameManager.playerData.selectedBackground == background.cosmeticsType {
                        Text(selectedItem)
                            .foregroundColor(Color("menuLabelColor"))
                            .font(.custom("Bangers-Regular", size: 12))
                            .padding(.horizontal,6)
                    } else if gameManager.playerData.backgroundsUnlocked.contains(background.cosmeticsType) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color("menuLabelColor"))
                    } else {
                        HStack {
                            Image("eggShell")
                                .resizable()
                                .frame(width: 12.75, height: 13.5)
                            Text("\(background.eggShellCost) ")
                                .font(.custom("Bangers-Regular", size: 14))
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: 100)
                .background(
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 24)
                            .foregroundColor(Color(gameManager.playerData.selectedBackground == background.cosmeticsType ? "settingsColor" : "settingsLightestColor"))
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 22)
                            .foregroundColor(Color(gameManager.playerData.selectedBackground == background.cosmeticsType ? "settingsLightestColor" : "settingsColor"))
                            .padding(.trailing, 3)
                    }
                )
            }
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 110)
        .background(Color("shopLightColor"))
        .cornerRadius(20)
    }
}

struct BackgroundCard_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundCard(background: BackgroundModel(name: "Bricks", image: "background", eggShellCost: 0, type: .sky))
            .environmentObject(GameManager())
    }
}
