//
//  AppOpenViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 28/06/24.
//

import UIKit

class AppOpenViewController: UIViewController {
    
    private let appOpenAdUtility = AppOpenAdUtility()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           appOpenAdUtility.loadAd(adUnitID: "ca-app-pub-3940256099942544/5575463023", rootViewController: self)
           appOpenAdUtility.addObservers()
       }
       
       deinit {
           appOpenAdUtility.removeObservers()
       }
       
       @objc func appDidBecomeActive() {
           appOpenAdUtility.appDidBecomeActive()
       }
       
       @objc func appWillResignActive() {
           appOpenAdUtility.appWillResignActive()
       }
}
