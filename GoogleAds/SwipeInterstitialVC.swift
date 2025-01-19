//
//  Swipe.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 18/01/25.
//


import UIKit
import GoogleMobileAds

class SwipeInterstitialVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var topCollectionView: UICollectionView!
    private var bottomCollectionView: UICollectionView!
    private var selectedIndex: Int = 0
    private var nativeAdLoaders: [Int: NativeMediumAdUtility] = [:]
    
    private let cellColors: [UIColor] = [
            .systemRed, .systemBlue, .systemGreen, .systemYellow, .systemOrange, .systemPurple, .systemTeal, .systemPink, .systemIndigo,
            UIColor(red: 0.95, green: 0.2, blue: 0.2, alpha: 1.0),
            UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0),
            UIColor(red: 1.0, green: 0.9, blue: 0.4, alpha: 1.0),
            UIColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1.0),
            UIColor(red: 0.6, green: 0.3, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.2, green: 1.0, blue: 1.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.3, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0),
            UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),
            UIColor(red: 0.3, green: 0.9, blue: 0.7, alpha: 1.0),
            UIColor(red: 1.0, green: 0.6, blue: 0.4, alpha: 1.0),
            UIColor(red: 0.7, green: 0.7, blue: 0.2, alpha: 1.0),
            UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1.0),
            UIColor(red: 0.8, green: 0.2, blue: 0.5, alpha: 1.0), .red, .blue, .green, .yellow, .orange, .purple, .cyan, .magenta, .brown, .gray, .label, .link
    ]
    
    private var totalItems: Int {
        let contentCount = cellColors.count
        let adCount = (contentCount + 4) / 5
        return contentCount + adCount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTopCollectionView()
        setupBottomCollectionView()
        registerCells()
        preloadAllAds()
        
        DispatchQueue.main.async {
            self.selectCell(at: 0)
        }
    }
    
    private func registerCells() {
        topCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "topCell")
        topCollectionView.register(NativeAdCell.self, forCellWithReuseIdentifier: "adCell")
        
        bottomCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "bottomCell")
        bottomCollectionView.register(AdLabelCell.self, forCellWithReuseIdentifier: "bottomAdCell")
    }
    
    private func setupTopCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topCollectionView.isPagingEnabled = true
        topCollectionView.showsHorizontalScrollIndicator = false
        topCollectionView.backgroundColor = .white
        topCollectionView.layer.cornerRadius = 12
        topCollectionView.clipsToBounds = true
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        
        view.addSubview(topCollectionView)
        NSLayoutConstraint.activate([
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            topCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            topCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -116)
        ])
    }
    
    private func setupBottomCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCollectionView.showsHorizontalScrollIndicator = false
        bottomCollectionView.backgroundColor = .white
        bottomCollectionView.layer.cornerRadius = 12
        bottomCollectionView.clipsToBounds = true
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        
        view.addSubview(bottomCollectionView)
        NSLayoutConstraint.activate([
            bottomCollectionView.heightAnchor.constraint(equalToConstant: 100),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func preloadAllAds() {
        let dispatchGroup = DispatchGroup()
        
        let totalAds = (cellColors.count + 4) / 5
        
        for i in 0..<totalAds {
            let adIndex = (i + 1) * 5 - 1
            dispatchGroup.enter()
            
            let adPlaceholder = UIView()
            adPlaceholder.backgroundColor = .lightGray
            
            let adLoader = NativeMediumAdUtility(
                adUnitID: "ca-app-pub-3940256099942544/3986624511",
                rootViewController: self,
                nativeAdPlaceholder: adPlaceholder
            ) { [weak self] success in
                if success {
                    print("Ad loaded successfully for index: \(adIndex)")
                } else {
                    print("Failed to load ad for index: \(adIndex)")
                }
                dispatchGroup.leave()
            }
            
            nativeAdLoaders[adIndex] = adLoader
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All ads have been loaded")
            self.topCollectionView.reloadData()
            self.bottomCollectionView.reloadData()
        }
    }
    
    private func isAdCell(_ index: Int) -> Bool {
        return (index + 1) % 5 == 0
    }
    
    private func getContentIndex(for index: Int) -> Int {
        return index - ((index + 1) / 5)
    }
    
    private func selectCell(at index: Int) {
        selectedIndex = index
        topCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        bottomCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        topCollectionView.reloadData()
        bottomCollectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isAdCell(indexPath.item) {
            if collectionView == topCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as! NativeAdCell
                if let adLoader = nativeAdLoaders[indexPath.item] {
                    cell.configure(with: adLoader.nativeAdPlaceholder)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomAdCell", for: indexPath) as! AdLabelCell
                cell.layer.borderWidth = indexPath.item == selectedIndex ? 3 : 1
                cell.layer.borderColor = (indexPath.item == selectedIndex ? UIColor.black : UIColor.lightGray).cgColor
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView == topCollectionView ? "topCell" : "bottomCell", for: indexPath)
            
            let contentIndex = getContentIndex(for: indexPath.item)
            cell.backgroundColor = cellColors[contentIndex % cellColors.count]
            
            if collectionView == bottomCollectionView {
                cell.layer.borderWidth = indexPath.item == selectedIndex ? 3 : 1
                cell.layer.borderColor = (indexPath.item == selectedIndex ? UIColor.black : UIColor.lightGray).cgColor
            }
            
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            return collectionView.frame.size
        } else {
            let cellSize = collectionView.frame.height
            return CGSize(width: cellSize, height: cellSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(at: indexPath.item)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == topCollectionView {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
            selectCell(at: index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == topCollectionView else { return }
        
        let centerX = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        
        for cell in topCollectionView.visibleCells {
            let cellCenterX = cell.center.x
            let distance = abs(centerX - cellCenterX)
            let maxDistance = scrollView.frame.width
            let scale = max(1 - (distance / maxDistance), 0.75) // Scale between 0.75 and 1
            
            // Apply scaling and rotation transformation
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
}

// MARK: - Custom Cells
class AdLabelCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        clipsToBounds = true
        
        label.text = "Ad"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

class NativeAdCell: UICollectionViewCell {
    private var adView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func configure(with adView: UIView?) {
        self.adView?.removeFromSuperview()
        
        guard let adView = adView else { return }
        
        self.adView = adView
        contentView.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        adView?.removeFromSuperview()
        adView = nil
    }
}
