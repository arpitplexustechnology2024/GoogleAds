//
//  AppOpenViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 28/06/24.
//

import UIKit
import GoogleMobileAds

class AppOpenViewController: UIViewController {
    
    var appOpenAd: GADAppOpenAd?
    var isAppInBackground = false
    var adUnitID = "ca-app-pub-3940256099942544/5575463023"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAd()
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    func loadAd() {
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
        if let appOpenAd = appOpenAd {
            appOpenAd.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
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
            loadAd()
            isAppInBackground = false
        }
    }
    
    @objc func appWillResignActive() {
        isAppInBackground = true
    }
}

extension AppOpenViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present app open ad:", error)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad dismissed.")
    }
}
