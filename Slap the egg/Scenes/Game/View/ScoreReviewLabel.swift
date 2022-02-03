//
//  ScoreReviewLabel.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import SwiftUI

struct ScoreReviewLabel: View {
    @Binding var sessionScore: Int
    var body: some View {
        ZStack {
            Image("sessionLabel")
            VStack {
                Text("\(sessionScore) Points ")
                    .font(Font.custom("Bangers-Regular", size: 64))
                    .foregroundColor(Color("scoreYellow"))
                Text("+ \(sessionScore/10) Eggshells ")
                    .font(Font.custom("Bangers-Regular", size: 24))
                    .foregroundColor(Color("menuLightColor"))
            }
        }
    }
}

struct ScoreReviewLabel_Previews: PreviewProvider {
    static var previews: some View {
        ScoreReviewLabel(sessionScore: .constant(1200))
    }
}
