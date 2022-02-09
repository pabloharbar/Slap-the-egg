//
//  ShopEggCard.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import SwiftUI

struct ShopEggCard: View {
    let egg: Egg
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
                Text("Size")
                SizeView(eggSize: egg.size)
            }
            .frame(maxWidth: 220)
            .foregroundColor(Color("modalLabelColor"))
            
            VStack {
                HStack {
                    Button(action: {}) {
                        HStack {
                            Image("eggShell")
                                .resizable()
                                .frame(width: 12.75, height: 13.5)
                            Text("\(egg.eggShellCost) ")
                                .font(.custom("Bangers-Regular", size: 14))
                        }
                        .padding(.horizontal)
                    }
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 24)
                                .foregroundColor(.red)
                        }
                    )
                }
                Spacer()
                PowerUpView(powerUps: egg.powerUp)
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 300, height: 110)
        .background(Color("shopLightColor"))
        .cornerRadius(20)
    }
}

struct PowerUpView: View {
    let powerUps: [PowerUp]
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(powerUps, id: \.self) { powerUp in
                switch powerUp.powerUpType {
                case .multiplicate:
                    HStack(spacing: 6) {
                        ZStack {
                            Circle().foregroundColor(Color("powerUpYellow")).frame(width: 18, height: 18)
                            Text("x\(powerUp.value) ")
                                .font(.custom("Bangers-Regular", size: 12))
                                .foregroundColor(Color("menuLabelColor"))
                        }
                        Text("points")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                case.revive:
                    HStack(spacing: 6) {
                        ZStack {
                            Circle().foregroundColor(Color("powerUpGreen")).frame(width: 18, height: 18)
                            Text("+\(powerUp.value) ")
                                .font(.custom("Bangers-Regular", size: 12))
                                .foregroundColor(Color("menuLabelColor"))
                        }
                        Text("life")
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
        ShopEggCard(egg: CosmeticsBank.shared.eggsAvailable[1])
    }
}