//
//  InterstitialAdUtility.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 01/07/24.
//

import GoogleMobileAds
import UIKit

class InterstitialAdUtility: NSObject, GADFullScreenContentDelegate {
    
    private var interstitial: GADInterstitialAd?
    
    func loadInterstitial(adUnitID: String) async {
        do {
            interstitial = try await GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest())
            interstitial?.fullScreenContentDelegate = self
            print("Interstitial ad loaded.")
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    func presentInterstitial(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            print("Ad wasn't ready.")
            return
        }
        interstitial.present(fromRootViewController: viewController)
    }

    // MARK: - GADFullScreenContentDelegate
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}

