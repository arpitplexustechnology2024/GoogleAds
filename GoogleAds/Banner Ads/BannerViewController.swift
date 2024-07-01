//
//  BannerViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 28/06/24.
//

import UIKit

class BannerViewController: UIViewController {
    
    var bannerAdUtility = BannerAdUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerAdUtility.setupBannerAd(in: self, adUnitID: "ca-app-pub-3940256099942544/2435281174")
    }
    
}


