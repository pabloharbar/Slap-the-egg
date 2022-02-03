//
//  LeaderboardView.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import GameKit
import SwiftUI

struct LeaderboardView: UIViewControllerRepresentable {
    @Binding var menuStatus: MenuList
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let leaderboard = LeaderboardViewController()
        leaderboard.coordinator = context.coordinator
        return leaderboard
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> LeaderboardCoordinator {
        LeaderboardCoordinator(menuStatus: $menuStatus)
    }
}

class LeaderboardCoordinator: NSObject {
    @Binding var menuStatus: MenuList

    init(menuStatus: Binding<MenuList>) {
        self._menuStatus = menuStatus
    }

    func dismiss() {
        menuStatus = .hidden
    }
}
