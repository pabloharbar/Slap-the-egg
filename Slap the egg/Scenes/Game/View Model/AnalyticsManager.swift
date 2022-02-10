//
//  AnalyticsManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 10/02/22.
//

import FirebaseAnalytics
import CoreGraphics

class AnalyticsManager {
    
    
    func logEvent() {
        Analytics.logEvent("Event", parameters: nil)
    }
    
    func logEventWithValue(value: CGFloat) {
        Analytics.logEvent("Event", parameters: [
            "Value" : value as NSNumber
        ])
    }
    
    func setPropertyUser() {
        Analytics.setUserProperty("\(round(1))", forName: "last_run_score")
    }
}
