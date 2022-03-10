//
//  ShopTabButton.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import SwiftUI

struct ShopTabButton: View {
    // Navigation
    @Binding var pageSelected: Int
    let pageIndex: Int
    
    let label: String
    var body: some View {
        Button(action: {
            pageSelected = pageIndex
        }) {
            Text("\(label) ")
                .foregroundColor(Color("menuLabelColor"))
                .font(.custom("Bangers-Regular", size: 18))
                .padding(.horizontal)
                .background(
                    ZStack(alignment: .topTrailing) {
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .cornerRadius(8, corners: [.topLeft,.topRight])
                                .frame(height: 34)
                                .foregroundColor(Color("shopLightColor"))
                                                    Rectangle()
                                .cornerRadius(8, corners: [.topLeft,.topRight])
                                .frame(height: 28)
                                .foregroundColor(Color(pageSelected == pageIndex ? "shopMenuColor" : "shopColor"))
                                .padding(.trailing, 4)

                        }
                        Ellipse()
                            .frame(width: 12, height: 3)
                            .rotationEffect(Angle(degrees: 5))
                            .padding(.top, 2)
                            .padding(.trailing, 8)
                            .foregroundColor(Color("shopLightestColor"))
                        Ellipse()
                            .frame(width: 3, height: 2)
                            .rotationEffect(Angle(degrees: 35))
                            .padding(.top, 4)
                            .padding(.trailing, 4)
                            .foregroundColor(Color("shopLightestColor"))
                    }
            )
        }
    }
}

struct ShopTabButton_Previews: PreviewProvider {
    static var previews: some View {
        ShopTabButton(pageSelected: .constant(0), pageIndex: 0, label: "Eggs")
    }
}
