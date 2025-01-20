//
//  SwipeVC.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 20/01/25.
//

import UIKit

class SwipeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView1: UICollectionView!
    private var collectionView2: UICollectionView!
    private var selectedIndex: Int = 0
    private var nativeAdLoaders: [Int: NativeMediumAdUtility] = [:]
    private let adInterval = 4
    private let regularCellCount = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView1()
        setupCollectionView2()
        // Add this new line to preload ads
        preloadAllAds()
        DispatchQueue.main.async {
            self.scrollToIndex(self.selectedIndex, animated: false)
        }
    }
    
    private func setupCollectionView1() {
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .horizontal
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        
        collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        collectionView1.dataSource = self
        collectionView1.delegate = self
        collectionView1.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        collectionView1.register(NativeAdsCell.self, forCellWithReuseIdentifier: "adCell")
        collectionView1.backgroundColor = .white
        collectionView1.isPagingEnabled = true
        collectionView1.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView1)
        collectionView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -116)
        ])
    }
    
    private func setupCollectionView2() {
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumLineSpacing = 8
        layout2.minimumInteritemSpacing = 8
        
        collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        collectionView2.dataSource = self
        collectionView2.delegate = self
        collectionView2.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        collectionView2.backgroundColor = .white
        collectionView2.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView2)
        collectionView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView2.heightAnchor.constraint(equalToConstant: 100),
            collectionView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            let adCount = regularCellCount / adInterval
            return regularCellCount + adCount
        } else {
            return regularCellCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            if shouldShowAdAt(index: indexPath.item) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as! NativeAdsCell
                if let adLoader = nativeAdLoaders[indexPath.item] {
                    cell.configure(with: adLoader.nativeAdPlaceholder)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! CollectionViewCell
                let actualIndex = getActualIndex(for: indexPath.item)
                cell.configureCell(index: actualIndex, isSelected: actualIndex == selectedIndex)
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewCell
            cell.configureCell(index: indexPath.item, isSelected: indexPath.item == selectedIndex)
            return cell
        }
    }
    
    private func shouldShowAdAt(index: Int) -> Bool {
        let adjustedIndex = index + 1
        return adjustedIndex % (adInterval + 1) == 0
    }
    
    private func getActualIndex(for visibleIndex: Int) -> Int {
        let adCount = visibleIndex / (adInterval + 1)
        return visibleIndex - adCount
    }
    
    private func preloadAllAds() {
        let dispatchGroup = DispatchGroup()
        
        let totalAds = (regularCellCount + 4) / 5
        
        for i in 0..<totalAds {
            let adIndex = (i + 1) * 5 - 1
            dispatchGroup.enter()
            
            let adPlaceholder = UIView()
            adPlaceholder.backgroundColor = .lightGray
            
            let adLoader = NativeMediumAdUtility(adUnitID: "ca-app-pub-3940256099942544/3986624511",rootViewController: self,nativeAdPlaceholder: adPlaceholder) { [weak self] success in
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
            self.collectionView1.reloadData()
            self.collectionView2.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    // MARK: - UICollectionViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView1 else { return }
        let visibleRect = CGRect(origin: collectionView1.contentOffset, size: collectionView1.bounds.size)
        guard let visibleIndexPath = collectionView1.indexPathForItem(at: CGPoint(x: visibleRect.midX, y: visibleRect.midY)) else { return }
        
        if shouldShowAdAt(index: visibleIndexPath.item) {
            
        } else {
            selectedIndex = getActualIndex(for: visibleIndexPath.item)
        }
        reloadAndScrollToSelectedIndex(from: collectionView1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView1 {
            if shouldShowAdAt(index: indexPath.item) {
                
            } else {
                selectedIndex = getActualIndex(for: indexPath.item)
            }
        } else if collectionView == collectionView2 {
            selectedIndex = indexPath.item
        }
        reloadAndScrollToSelectedIndex(from: collectionView)
    }
    
    // MARK: - Helpers
    private func reloadAndScrollToSelectedIndex(from collectionView: UICollectionView) {
        collectionView1.reloadData()
        collectionView2.reloadData()
        
        let indexPathToScroll = IndexPath(item: selectedIndex, section: 0)
        if collectionView == collectionView1 {
            collectionView2.scrollToItem(at: indexPathToScroll, at: .centeredHorizontally, animated: true)
        } else if collectionView == collectionView2 {
            let visibleIndexPath = getVisibleIndexForActualIndex(selectedIndex)
            collectionView1.scrollToItem(at: visibleIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func getVisibleIndexForActualIndex(_ actualIndex: Int) -> IndexPath {
        var visibleIndex = actualIndex
        let adCountBefore = actualIndex / adInterval
        visibleIndex += adCountBefore
        return IndexPath(item: visibleIndex, section: 0)
    }
    
    private func scrollToIndex(_ index: Int, animated: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView1.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        collectionView2.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1 {
            return collectionView.frame.size
        } else {
            let cellSize = collectionView.frame.height
            return CGSize(width: cellSize, height: cellSize)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView1 else { return }
        let centerX = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        for cell in collectionView1.visibleCells {
            let cellCenterX = cell.center.x
            let distance = abs(centerX - cellCenterX)
            let maxDistance = scrollView.frame.width
            let scale = max(1 - (distance / maxDistance), 0.75)
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
