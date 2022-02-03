//
//  EggShellLabel.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 02/02/22.
//

import SwiftUI

struct EggShellLabel: View {
    @Binding var money: Int
    var body: some View {
        ZStack {
            Image("moneyBackground")
            HStack {
                Image("eggShell")
                Text("\(money)")
                    .foregroundColor(.white)
                    .font(Font.custom("Bangers-Regular", size: 36))
            }
                
        }
    }
}

struct EggShellLabel_Previews: PreviewProvider {
    static var previews: some View {
        EggShellLabel(money: .constant(200))
    }
}
