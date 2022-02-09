//
//  BackgroundView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import SwiftUI

struct BackgroundView: View {
    let Colors: [String]
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 45)
                    .frame(width: width, height: height)
                    .foregroundColor(Color(Colors[1]))
                RoundedRectangle(cornerRadius: 45)
                    .frame(width: width - 32, height: height - 15)
                    .foregroundColor(Color(Colors[0]))
            }
            Ellipse()
                .frame(width: 38, height: 13)
                .rotationEffect(Angle(degrees: 35))
                .padding(12)
                .foregroundColor(Color(Colors[2]))
            Ellipse()
                .frame(width: 14, height: 7)
                .rotationEffect(Angle(degrees: 34))
                .padding(.top,34)
                .padding(.trailing,8)
                .foregroundColor(Color(Colors[2]))
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(Colors: [
            "settingsColor",
            "settingsLightColor",
            "settingsLightestColor"
        ],
           width: 332,
           height: 400
        )
    }
}
