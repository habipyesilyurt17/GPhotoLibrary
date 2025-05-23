//
//  GalleryViewModel.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import Foundation
import PhotosUI
import UIKit

final class GalleryViewModel {
    // MARK: - Properties
    private let coordinator: GalleryCoordinator
    
    @Published var selectedImages: [UIImage] = []

    
    var onAssetsUpdated: (([PHAsset]) -> Void)?
    var onSelectionChanged: (([PHAsset]) -> Void)?
    
    // MARK: - Initialization
    init(coordinator: GalleryCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func handlePickedResults(_ results: [PHPickerResult]) {
        guard !results.isEmpty else { return }
        
        let imageItems = results.prefix(20)
        for result in imageItems {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self,
                          let uiImage = image as? UIImage,
                          error == nil else { return }
                    
                    DispatchQueue.main.async {
                        if self.selectedImages.count < 20 {
                            self.selectedImages.append(uiImage)
                        }
                    }
                }
            }
        }
    }
}
