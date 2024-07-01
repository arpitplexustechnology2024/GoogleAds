//
//  InterstitialViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 28/06/24.
//

import GoogleMobileAds
import UIKit

class InterstitialViewController: UIViewController, GADFullScreenContentDelegate {
    
    private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await loadInterstitial()
        }
    }
    
    func loadInterstitial() async {
        do {
            interstitial = try await GADInterstitialAd.load(
                withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
            interstitial?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
    
    @IBAction func interstitialShowTapped(_ sender: Any) {
        guard let interstitial = interstitial else {
            return print("Ad wasn't ready.")
        }
        
        interstitial.present(fromRootViewController: self)
    }
    
}
