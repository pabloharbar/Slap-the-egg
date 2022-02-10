//
//  Background.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/02/22.
//

import Foundation

struct BackgroundModel {
    let name: String
    let image: String
    let eggShellCost: Int
    let cosmeticsType: Backgrounds
    
    init(name: String, image: String, eggShellCost: Int = 0, type: Backgrounds) {
        self.name = name
        self.image = image
        self.eggShellCost = eggShellCost
        self.cosmeticsType = type
    }
}
