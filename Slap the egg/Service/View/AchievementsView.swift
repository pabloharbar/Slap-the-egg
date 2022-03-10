//
//  AchievementsView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/03/22.
//

import GameKit
import SwiftUI

struct AchievementsView: UIViewControllerRepresentable {
    @Binding var menuStatus: MenuList
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let leaderboard = AchievementsViewController()
        leaderboard.coordinator = context.coordinator
        return leaderboard
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    // Uses the same coordinator as leaderboardView
    func makeCoordinator() -> LeaderboardCoordinator {
        LeaderboardCoordinator(menuStatus: $menuStatus)
    }
}
