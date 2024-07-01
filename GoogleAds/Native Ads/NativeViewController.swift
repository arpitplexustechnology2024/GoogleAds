//
//  NativeViewController.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 28/06/24.
//

import UIKit
import GoogleMobileAds

class NativeViewController: UIViewController {
    
    @IBOutlet weak var nativeAdPlaceholder: UIView!
    
    private var nativeAdUtility: NativeAdUtility?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nativeAdUtility = NativeAdUtility(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self, nativeAdPlaceholder: nativeAdPlaceholder)
    }
    
}
