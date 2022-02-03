//
//  LeaderboardView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import GameKit
import SwiftUI

struct LeaderboardView: UIViewControllerRepresentable {
    @Binding var leaderboardVisible: Bool
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let leaderboard = LeaderboardViewController()
        leaderboard.coordinator = context.coordinator
        return leaderboard
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> LeaderboardCoordinator {
        LeaderboardCoordinator(leaderboardVisible: $leaderboardVisible)
    }
}

class LeaderboardCoordinator: NSObject {
    @Binding var leaderboardVisible: Bool

    init(leaderboardVisible: Binding<Bool>) {
        self._leaderboardVisible = leaderboardVisible
    }

    func dismiss() {
        leaderboardVisible.toggle()
    }
}
