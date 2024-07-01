//
//  AppOpenAdUtility.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 01/07/24.
//

import UIKit
import GoogleMobileAds

class AppOpenAdUtility: NSObject, GADFullScreenContentDelegate {
    
    var appOpenAd: GADAppOpenAd?
    var isAppInBackground = false
    private var adUnitID: String?
    private weak var rootViewController: UIViewController?
    
    func loadAd(adUnitID: String, rootViewController: UIViewController) {
        self.adUnitID = adUnitID
        self.rootViewController = rootViewController
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: adUnitID, request: request) { [weak self] (appOpenAd, error) in
            if let error = error {
                print("Failed to load app open ad:", error)
                return
            }
            
            self?.appOpenAd = appOpenAd
            self?.appOpenAd?.fullScreenContentDelegate = self
            self?.presentAd()
        }
    }
    
    func presentAd() {
        guard let appOpenAd = appOpenAd, let rootViewController = rootViewController else {
            print("Ad wasn't ready")
            return
        }
        appOpenAd.present(fromRootViewController: rootViewController)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        if isAppInBackground {
            if let adUnitID = adUnitID, let rootViewController = rootViewController {
                loadAd(adUnitID: adUnitID, rootViewController: rootViewController)
            }
            isAppInBackground = false
        }
    }
    
    @objc func appWillResignActive() {
        isAppInBackground = true
    }

    // MARK: - GADFullScreenContentDelegate
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present app open ad:", error)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad dismissed.")
    }
}

