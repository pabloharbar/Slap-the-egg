//
//  ScoreLabel.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 02/02/22.
//

import SwiftUI

struct ScoreLabel: View {
    @Binding var score: Int
    var body: some View {
        ZStack {
            Ellipse()
                .fill(.gray)
                .frame(width: 130, height: 80)
                .opacity(0.30)
            Text("\(score)")
                .padding()
                .foregroundColor(.white)
                .font(Font.custom("Bangers-Regular", size: 36))
                
        }
    }
}

struct ScoreLabel_Previews: PreviewProvider {
    static var previews: some View {
        ScoreLabel(score: .constant(300))
    }
}
