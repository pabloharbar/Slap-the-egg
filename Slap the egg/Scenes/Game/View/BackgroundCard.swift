//
//  BackgroundCard.swift
//  Slap the egg
//
//  Created by Pablo Penas on 09/02/22.
//

import SwiftUI

struct BackgroundCard: View {
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
            VStack {
                Text("\(background.name) ")
                    .font(.custom("Bangers-Regular", size: 24))
                    .foregroundColor(Color("menuLabelColor"))
                HStack {
                    Image("eggShell")
                        .resizable()
                        .frame(width: 12.75, height: 13.5)
                    Text("\(background.eggShellCost) ")
                        .font(.custom("Bangers-Regular", size: 14))
                }
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
    }
}
