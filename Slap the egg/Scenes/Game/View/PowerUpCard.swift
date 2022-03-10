//
//  PowerUpCard.swift
//  Slap the egg
//
//  Created by Pablo Penas on 09/02/22.
//

import SwiftUI

struct PowerUpCard: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var adManager: AdRewardManager
    let powerUp: PowerUp
    let active:LocalizedStringKey = "active"
    let ad:LocalizedStringKey = "ad"
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Image(powerUp.image)
                    .background(
                        Circle()
                            .fill(powerUp.powerUpType == .revive1 ? RadialGradient(colors: [Color(red: 196/255, green: 196/255, blue: 196/255),Color(red: 196/255, green: 196/255, blue: 196/255).opacity(0)], center: .center, startRadius: 0, endRadius: 60) : RadialGradient(colors: [.clear], center: .center, startRadius: 0, endRadius: 40))
                            .frame(width: 80, height: 80)
                    )
                .frame(width: 80, height: 80)
                if powerUp.powerUpType == .multiplicate2x {
                    Text("x\(powerUp.value) ")
                        .font(.custom("Bangers-Regular", size: 48))
                }
            }
            
            VStack {
                Text("\(powerUp.name) ")
                    .font(.custom("Bangers-Regular", size: 24))
                Text(powerUp.description)
                    .font(.system(size: 10, weight: .semibold))
                    .multilineTextAlignment(.center)
                if gameManager.playerData.activePowerUps.contains(powerUp.powerUpType) {
                    Text(active)
                        .font(.custom("Bangers-Regular", size: 14))
                        .frame(maxWidth: 200, maxHeight: 15)
                        .background(
                            ZStack(alignment: .bottomLeading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 24)
                                    .foregroundColor(Color("settingsColor"))
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 22)
                                    .foregroundColor(Color("settingsLightestColor"))
                                    .padding(.trailing, 3)
                            }
                        )

                } else {
                    HStack {
                        Button(action: {
                            adManager.showAd(rewardFunction: {
                                gameManager.getAdPowerUp(powerUp: powerUp.powerUpType)
                                if powerUp.powerUpType == .revive1 {
                                    AnalyticsManager.logEvent(eventName: AnalyticsEvents.adShield.rawValue)
                                } else if powerUp.powerUpType == .multiplicate2x {
                                    AnalyticsManager.logEvent(eventName: AnalyticsEvents.adDouble.rawValue)
                                }
                            })
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .frame(width: 12.75, height: 13.5)
                                Text(ad)
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
                        Button(action: {
                            gameManager.processPowerUpPurchase(powerUp: powerUp.powerUpType)
                        }) {
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
                    .foregroundColor(Color("menuLabelColor"))
                    .frame(maxWidth: 160)
                }
            }
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
            .environmentObject(GameManager())
            .environmentObject(AdRewardManager())
    }
}
