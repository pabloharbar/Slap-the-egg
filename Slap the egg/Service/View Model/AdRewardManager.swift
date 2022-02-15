//
//  AdRewardManager.swift
//  Slap the egg
//
//  Created by Pablo Penas on 11/02/22.
//

import SwiftUI
import GoogleMobileAds
import UIKit
    
final class AdRewardManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    var rewardedAd: GADRewardedAd?

    var rewardFunction: (() -> Void)? = nil

    override init() {
        super.init()
        LoadRewarded()
    }
    
    func LoadRewarded(){
        
        let req = GADRequest()
        GADRewardedAd.load(withAdUnitID: AdMobId.rewardID, request: req, completionHandler: { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            } else {
                self.rewardedAd = ad
                self.rewardedAd?.fullScreenContentDelegate = self
            }
        })
    }

    func showAd(rewardFunction: @escaping () -> Void){
        let root = UIApplication.shared.windows.first?.rootViewController
        if let ad = rewardedAd {
            self.rewardFunction = rewardFunction
            ad.present(fromRootViewController: root!, userDidEarnRewardHandler: {
//                let reward = ad.adReward
                rewardFunction()
            })
        }
        else{
            print("Not Ready")
        }
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        if let rf = rewardFunction {
            rf()
        }
        LoadRewarded()
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        LoadRewarded()
    }
}
