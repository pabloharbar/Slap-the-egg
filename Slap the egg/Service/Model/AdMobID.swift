//
//  AdMobID.swift
//  Slap the egg
//
//  Created by Pablo Penas on 11/02/22.
//

import Foundation

struct AdMobId {
    #if DEBUG
    static let bannerID = "ca-app-pub-3940256099942544/2934735716"
    static let rewardID = "ca-app-pub-3940256099942544/1712485313"
    static let interstitalID = "ca-app-pub-3940256099942544/4411468910"
    #else
    static let bannerID = "ca-app-pub-8373172508343670/7123117443"
    static let rewardID = "ca-app-pub-8373172508343670/4608403231"
    static let interstitalID = "ca-app-pub-8373172508343670/1308565861"
    #endif
}
