//
//  LeaderboardViewController.swift
//  Slap the egg
//
//  Created by Pablo Penas on 03/02/22.
//

import GameKit
import SwiftUI

class LeaderboardViewController: UIViewController,GKGameCenterControllerDelegate {
    // Gamekit
    private var gcEnabled = Bool() // Check if the user has Game Center enabled
    private var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var coordinator: LeaderboardCoordinator = LeaderboardCoordinator(menuStatus: .constant(.leaderboard))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer() { [self] in
            presentLeaderboard()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentLeaderboard()
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
    
    func updateScore(with value:Int) {
        if (self.gcEnabled) {
            GKLeaderboard.submitScore(value, context:0, player: GKLocalPlayer.local, leaderboardIDs: [self.gcDefaultLeaderBoard], completionHandler: {error in})
        }
    }
    
    func presentLeaderboard() {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        self.present(GameCenterVC, animated: true, completion: nil)
    }
}
