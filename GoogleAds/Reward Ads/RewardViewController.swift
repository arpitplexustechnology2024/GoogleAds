//
//  RewardViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 01/07/24.
//

import UIKit

class RewardViewController: UIViewController {
    
    private let rewardAdUtility = RewardAdUtility()

    override func viewDidLoad() {
        super.viewDidLoad()
        rewardAdUtility.loadRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313", rootViewController: self)
    }

    @IBAction func showAdButtonTapped(_ sender: UIButton) {
        rewardAdUtility.showRewardedAd()
     }

}
