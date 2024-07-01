//
//  InterstitialViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 28/06/24.
//

import UIKit

class InterstitialViewController: UIViewController {
    
    private let interstitialAdUtility = InterstitialAdUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await interstitialAdUtility.loadInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        }
    }
    
    @IBAction func interstitialShowTapped(_ sender: Any) {
        
        interstitialAdUtility.presentInterstitial(from: self)
    }
    
}
