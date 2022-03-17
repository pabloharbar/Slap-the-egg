//
//  AnalyticsManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 10/02/22.
//

import FirebaseAnalytics
import CoreGraphics

enum AnalyticsEvents: String {
    case firstEggPurchase = "first_egg_purchase"
    case eggPurchase = "egg_purchase"
    case firstBackgroundPurchase = "first_background_purchase"
    case backgroundPurchase = "background_purchase"
    case purchaseDoublePowerUp = "powerUp_double_purchase"
    case purchaseRevivePowerUp = "powerUp_revive_purchase"
    case adRevive = "ad_revive"
    case adShield = "ad_shield"
    case adDouble = "ad_double"
    
    case deadToPan = "dead_pan"
    case deadToKnife = "dead_knife"
    case deadToSpoon = "dead_spoon"
    case deadToSpatula = "dead_spatula"
    case deadToToaster = "dead_toaster"
    case deadToShovel = "dead_shovel"
    
    case playedInHardMode = "play_hard"
    case playWithEgg = "play_egg_count"
    case playWithBackground = "play_background_count"
}

enum AnalyticsProperties: String {
    case timesPlayedInSequence = "" // TODO
}

class AnalyticsManager {
    static func logEvent(eventName: String) {
        Analytics.logEvent(eventName, parameters: nil)
    }
    
    static func logEventWithValue(eventName: String, value: CGFloat) {
        Analytics.logEvent(eventName, parameters: [
            "Value" : value as NSNumber
        ])
    }
    
    static func setPropertyUser(eventName: String, value: CGFloat) {
        Analytics.setUserProperty("\(round(value))", forName: "last_run_score")
    }
}
