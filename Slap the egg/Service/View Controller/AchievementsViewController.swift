//
//  AchievementsViewController.swift
//  Slap the egg
//
//  Created by Pablo Penas on 08/03/22.
//

import GameKit
import SwiftUI

class AchievementsViewController: UIViewController,GKGameCenterControllerDelegate {
    // Gamekit
    private var gcEnabled = Bool() // Check if the user has Game Center enabled
    private var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var coordinator: LeaderboardCoordinator = LeaderboardCoordinator(menuStatus: .constant(.leaderboard))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer() { [self] in
            presentAchievements()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentAchievements()
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
        coordinator.dismiss()
    }
    
    func authenticateLocalPlayer(_ completion: @escaping () -> Void) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            }
            else if (localPlayer.isAuthenticated) {
                
                // Player is already authenticated and logged in
                self.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                 })
                
            }
            else {
                // Game center is not enabled on the user's device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    func presentAchievements() {
        let GameCenterVC = GKGameCenterViewController(state: .achievements)
        GameCenterVC.gameCenterDelegate = self
        self.present(GameCenterVC, animated: true, completion: nil)
    }
}

