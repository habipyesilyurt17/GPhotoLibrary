//
//  GalleryViewModel.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import Foundation
import PhotosUI
import UIKit
import Combine

final class GalleryViewModel {
    // MARK: - Properties
    private let coordinator: GalleryCoordinator
    private let imageManager = PHCachingImageManager()
    
    @Published var assets: [PHAsset] = []
    @Published var selectedAssets: [PHAsset] = []
    @Published var selectedCount: Int = 0
    
    var onAssetsUpdated: (([PHAsset]) -> Void)?
    var onSelectionChanged: (([PHAsset]) -> Void)?
    
    // MARK: - Initialization
    init(coordinator: GalleryCoordinator) {
        self.coordinator = coordinator
        fetchPhotos()
    }
    
    // MARK: - Methods
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        allPhotos.enumerateObjects { [weak self] (asset, _, _) in
            self?.assets.append(asset)
        }
    }
    
    func loadImage(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            completion(image)
        }
    }
    
    func toggleSelection(for asset: PHAsset) {
        if let index = selectedAssets.firstIndex(of: asset) {
            selectedAssets.remove(at: index)
        } else if selectedAssets.count < Constants.maximumPhotoCount {
            selectedAssets.append(asset)
        }
        selectedCount = selectedAssets.count
    }
    
    func isSelected(_ asset: PHAsset) -> Bool {
        return selectedAssets.contains(asset)
    }
}
