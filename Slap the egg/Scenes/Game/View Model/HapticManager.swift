//
//  HapticManager.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 10/02/22.
//

import SwiftUI
class HapticsManager {
    
    static let instance = HapticsManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType, vibrationEnabled: Bool) {
        if !vibrationEnabled {
            return
        }

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle, vibrationEnabled: Bool) {
        if !vibrationEnabled {
            return
        }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct HapticManager: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("error") { HapticsManager.instance.notification(type: .error, vibrationEnabled: true) }
            Divider()
            Button("soft") {
                HapticsManager.instance.impact(style: .soft, vibrationEnabled: true) }
        }
    }
}

struct HapticManager_Previews: PreviewProvider {
    static var previews: some View {
        HapticManager()
    }
}
