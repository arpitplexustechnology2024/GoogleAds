//
//  RewardViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 01/07/24.
//

import UIKit
import GoogleMobileAds

class RewardViewController: UIViewController, GADFullScreenContentDelegate {
    
    private var rewardedAd: GADRewardedAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadRewardedAd()
    }
    
    func loadRewardedAd() {
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest()) { [self] ad, error in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
            print("Rewarded ad loaded.")
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content: \(error.localizedDescription)")
        loadRewardedAd()
      }

      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        loadRewardedAd()
      }
    
    func showRewardedAd() {
      guard let rewardedAd = rewardedAd else {
        print("Ad wasn't ready.")
        return
      }

      rewardedAd.present(fromRootViewController: self) {
        let reward = rewardedAd.adReward
        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
      }
    }

    @IBAction func showAdButtonTapped(_ sender: UIButton) {
       showRewardedAd()
     }

}
