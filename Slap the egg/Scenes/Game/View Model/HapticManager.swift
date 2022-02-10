//
//  HapticManager.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 10/02/22.
//

import SwiftUI
class HapticsManager {
    
    static let instance = HapticsManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct HapticManager: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("error") { HapticsManager.instance.notification(type: .error) }
            Divider()
            Button("soft") {
                HapticsManager.instance.impact(style: .soft) }
        }
    }
}

struct HapticManager_Previews: PreviewProvider {
    static var previews: some View {
        HapticManager()
    }
}
