//
//  InterstitialManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 17/02/22.
//

import SwiftUI
import UIKit
import GoogleMobileAds

final class InterstitialManager: NSObject, GADFullScreenContentDelegate {
    var interstitialEnabled = true
    var deathCounts = 0
    
    var interstitial: GADInterstitialAd?
    
    override init() {
        super.init()
        LoadInterstitial()
    }
    
    func LoadInterstitial(){
        let req = GADRequest()
        
        GADInterstitialAd.load(withAdUnitID: AdMobId.interstitalID, request: req, completionHandler: { [self] ad, error in
            if error != nil {
                print("failed to load ad")
                return
            } else {
                print("ad loaded")
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func showAd() {
        if !interstitialEnabled {
            deathCounts += 1
            if deathCounts >= 2 {
                interstitialEnabled = true
                deathCounts = 0
            }
            return
        }
        if interstitial != nil {
            let root = UIApplication.shared.windows.first?.rootViewController
            interstitial!.present(fromRootViewController: root!)
            interstitialEnabled = false
            print("Interstitial disabled")
        }
        else {
            print("Not Ready")
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        LoadInterstitial()
    }
    
}
