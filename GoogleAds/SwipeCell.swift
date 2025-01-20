//
//  Swipe.swift
//  GoogleAds
//
//  Created by Arpit iOS Dev. on 18/01/25.
//

import UIKit

// MARK: - NativeAds Cell
class NativeAdsCell: UICollectionViewCell {
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

// MARK: - Custom Cell
class CollectionViewCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureCell(index: Int, isSelected: Bool) {
        label.text = "Index \(index + 1)"
        layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.lightGray.cgColor
        layer.borderWidth = isSelected ? 2 : 1
    }
}
