//
//  GalleryRootView.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import Photos

final class GalleryRootView: UIView {
    // MARK: - Properties
    private let viewModel: GalleryViewModel
    private var assets: [PHAsset] = []
    private let imageManager = PHCachingImageManager()
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 1
        let width = (UIScreen.main.bounds.width - spacing * 3) / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground

        return collectionView
    }()
    
    // MARK: - Initialization
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onAssetsUpdated = { [weak self] assets in
            self?.assets = assets
            self?.collectionView.reloadData()
        }
    }
}
