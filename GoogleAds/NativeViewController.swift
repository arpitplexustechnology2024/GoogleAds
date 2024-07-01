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
    
    var adLoader: GADAdLoader!
    
    var nativeAdView: GADNativeAdView!
    
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADNativeAdView
        else {
            assert(false, "Could not load nib file for adView")
        }
        setAdView(adView)
        addRequest()
        
    }
    
    func addRequest() {
        adLoader = 	GADAdLoader(adUnitID: adUnitID, rootViewController: self, adTypes: [.native], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func setAdView(_ view: GADNativeAdView) {
        
        nativeAdView = view
        nativeAdPlaceholder.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
    }
    
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
}

extension NativeViewController: GADVideoControllerDelegate {
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        print("Video playback has ended.")
    }
}

extension NativeViewController: GADAdLoaderDelegate, GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: any Error) {
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [self] in
            print("Recived native ad: \(nativeAd)")
            
            let nibView = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil)?.first
            guard let nativeAdView = nibView as? GADNativeAdView else {
                return
            }
            setAdView(nativeAdView)
            
            nativeAd.delegate = self
            
            (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
            nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
            
            if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
                let heightConstraint = NSLayoutConstraint(
                    item: mediaView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: mediaView,
                    attribute: .width,
                    multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                    constant: 0)
                heightConstraint.isActive = true
            }
            
            (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
            nativeAdView.bodyView?.isHidden = nativeAd.body == nil
            
            (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
            nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
            
            (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
            nativeAdView.iconView?.isHidden = nativeAd.icon == nil
            
            (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
            nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
            
            (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
            nativeAdView.storeView?.isHidden = nativeAd.store == nil
            
            (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
            nativeAdView.priceView?.isHidden = nativeAd.price == nil
            
            (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
            nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
            
            nativeAdView.callToActionView?.isUserInteractionEnabled = false
            
            nativeAdView.nativeAd = nativeAd
        }
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension NativeViewController: GADNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
}
