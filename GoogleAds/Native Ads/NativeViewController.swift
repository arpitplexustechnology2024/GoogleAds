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
    @IBOutlet weak var nativeAd: UIView!
    
    private var nativeMediumAdUtility: NativeMediumAdUtility?
    private var nativeSmallAdUtility: NativeSmallAdUtility?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nativeMediumAdUtility = NativeMediumAdUtility(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self, nativeAdPlaceholder: nativeAdPlaceholder)
        nativeSmallAdUtility = NativeSmallAdUtility(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self, nativeAdPlaceholder: nativeAd)
    }
    
}
