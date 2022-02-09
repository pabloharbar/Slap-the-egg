//
//  PowerUpCard.swift
//  Slap the egg
//
//  Created by Pablo Penas on 09/02/22.
//

import SwiftUI

struct PowerUpCard: View {
    let powerUp: PowerUp
    var body: some View {
        HStack(spacing: 20) {
            Image(powerUp.image)
                .background(
                    Circle()
                        .fill(powerUp.powerUpType == .revive ? RadialGradient(colors: [Color(red: 196/255, green: 196/255, blue: 196/255),Color(red: 196/255, green: 196/255, blue: 196/255).opacity(0)], center: .center, startRadius: 0, endRadius: 60) : RadialGradient(colors: [.clear], center: .center, startRadius: 0, endRadius: 40))
                        .frame(width: 80, height: 80)
                )
                .frame(width: 80, height: 80)
            VStack {
                Text("\(powerUp.name) ")
                    .font(.custom("Bangers-Regular", size: 24))
                Text(powerUp.description)
                    .font(.system(size: 10, weight: .semibold))
                    .multilineTextAlignment(.center)
                HStack {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 12.75, height: 13.5)
                            Text("Ad ")
                                .font(.custom("Bangers-Regular", size: 14))
                        }
                        .padding(.horizontal)
                    }
                    .background(
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 24)
                                .foregroundColor(Color("settingsLightestColor"))
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 22)
                                .foregroundColor(Color("settingsColor"))
                                .padding(.trailing, 3)
                        }
                    )
                    Button(action: {}) {
                        HStack {
                            Image("eggShell")
                                .resizable()
                                .frame(width: 12.75, height: 13.5)
                            Text("\(powerUp.eggShellCost) ")
                                .font(.custom("Bangers-Regular", size: 14))
                        }
                        .padding(.horizontal)
                    }
                    .background(
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 24)
                                .foregroundColor(Color("settingsLightestColor"))
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 22)
                                .foregroundColor(Color("settingsColor"))
                                .padding(.trailing, 3)
                        }
                    )
                }
            }
            .foregroundColor(Color("menuLabelColor"))
            .frame(maxWidth: 160)
        }
        .padding()
        .frame(width: 300, height: 110)
        .background(Color("shopLightColor"))
        .cornerRadius(20)
    }
}

struct PowerUpCard_Previews: PreviewProvider {
    static var previews: some View {
        PowerUpCard(powerUp: PowerUpsAvailable.powerUps[3])
//        PowerUpCard(powerUp: PowerUp(name: "One more Life", description: "In the next session, if the egg gets cracked it ignores one time", type: .revive, value: 1, shopAvailable: true, image: "shieldIcon"))
    }
}
