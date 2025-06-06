//
//  GalleryRootView.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import Photos
import Combine

final class GalleryRootView: UIView {
    // MARK: - Properties
    private let viewModel: GalleryViewModel
    private let imageManager = PHCachingImageManager()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private lazy var mainVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "All Images"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 1
        let width = (UIScreen.main.bounds.width - spacing * 3) / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var selectedPhotosContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var selectedPhotosStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = .white
        return stack
    }()
    
    private lazy var thumbnailHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var arrowImageViewVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var spacerView1: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var spacerView2: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let arrowImageViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        imageView.image = UIImage(systemName: "arrow.right", withConfiguration: config)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var selectedCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var thumbnailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let height: CGFloat = 70
        layout.itemSize = CGSize(width: height, height: height)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.reuseIdentifier)
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
        addSubview(mainVerticalStack)
        headerView.addSubview(titleLabel)
        mainVerticalStack.addArrangedSubview(headerView)
        mainVerticalStack.addArrangedSubview(collectionView)
        mainVerticalStack.addArrangedSubview(selectedPhotosContainer)
        
        selectedPhotosContainer.addSubview(selectedPhotosStack)
        selectedPhotosStack.addArrangedSubview(selectedCountLabel)
        selectedPhotosStack.addArrangedSubview(thumbnailHorizontalStack)
        
        thumbnailHorizontalStack.addArrangedSubview(thumbnailCollectionView)
        thumbnailHorizontalStack.addArrangedSubview(arrowImageViewVerticalStack)
        arrowImageViewVerticalStack.addArrangedSubview(spacerView1)
        arrowImageViewVerticalStack.addArrangedSubview(arrowImageViewContainer)
        arrowImageViewVerticalStack.addArrangedSubview(spacerView2)
        arrowImageViewContainer.addSubview(arrowImageView)
    }
    
    private func setupConstraints() {
        mainVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedPhotosContainer.translatesAutoresizingMaskIntoConstraints = false
        selectedPhotosStack.translatesAutoresizingMaskIntoConstraints = false
        thumbnailHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainVerticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainVerticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVerticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVerticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            selectedPhotosStack.topAnchor.constraint(equalTo: selectedPhotosContainer.topAnchor),
            selectedPhotosStack.leadingAnchor.constraint(equalTo: selectedPhotosContainer.leadingAnchor),
            selectedPhotosStack.trailingAnchor.constraint(equalTo: selectedPhotosContainer.trailingAnchor),
            selectedPhotosStack.bottomAnchor.constraint(equalTo: selectedPhotosContainer.bottomAnchor),
            
            arrowImageViewContainer.widthAnchor.constraint(equalToConstant: 50),
            arrowImageViewContainer.heightAnchor.constraint(equalToConstant: 50),
            
            arrowImageView.centerXAnchor.constraint(equalTo: arrowImageViewContainer.centerXAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: arrowImageViewContainer.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 25),
            arrowImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupBindings() {
        viewModel.$selectedCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.updateSelectedPhotosView(count: count)
            }
            .store(in: &cancellables)
        
        viewModel.$isSelectionModeActive
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                self?.selectedPhotosContainer.isHidden = !isActive
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func updateSelectedPhotosView(count: Int) {
        selectedPhotosContainer.isHidden = count == 0
        let remainingCount = Constants.maximumPhotoCount - count
        selectedCountLabel.isHidden = count >= Constants.maximumPhotoCount
        selectedCountLabel.text = "You can add \(remainingCount) more photos"
        thumbnailCollectionView.reloadData()
    }
    
    // MARK: - Public Methods
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryRootView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == thumbnailCollectionView {
            return viewModel.selectedAssets.count
        }
        return viewModel.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == thumbnailCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.reuseIdentifier, for: indexPath) as? ThumbnailCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let asset = viewModel.selectedAssets[indexPath.item]
            let size = CGSize(width: 70 * UIScreen.main.scale, height: 70 * UIScreen.main.scale)
            
            viewModel.loadImage(for: asset, size: size) { image in
                DispatchQueue.main.async {
                    cell.configure(with: image)
                }
            }
            
            cell.onCloseButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.toggleSelection(for: asset)
                self.collectionView.reloadData()
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
                return UICollectionViewCell()
            }
            
            let asset = viewModel.assets[indexPath.item]
            let size = CGSize(width: cell.bounds.width * UIScreen.main.scale,
                            height: cell.bounds.height * UIScreen.main.scale)
            
            viewModel.loadImage(for: asset, size: size) { image in
                DispatchQueue.main.async {
                    cell.configure(with: image)
                }
            }
            
            let isSelected = viewModel.isSelected(asset)
            let selectionOrder = viewModel.selectionOrder(for: asset)
            cell.setSelected(isSelected || viewModel.isSelectionModeActive, selectionOrder: selectionOrder)
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension GalleryRootView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == thumbnailCollectionView {
            return
        }
        
        let asset = viewModel.assets[indexPath.item]
        
        if viewModel.selectedCount >= Constants.maximumPhotoCount && !viewModel.isSelected(asset) {
            BannerManager.shared.showBanner(type: .warning, title: "You can choose up to \(Constants.maximumPhotoCount) photos!")
            return
        }
        
        viewModel.toggleSelection(for: asset)
        collectionView.reloadData()
    }
}
