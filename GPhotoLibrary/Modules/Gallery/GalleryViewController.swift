//
//  GalleryViewController.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import PhotosUI

final class GalleryViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: GalleryViewModel
    private var rootView: GalleryRootView
    private var selectedAssets: [PHAsset] = []
    
    // MARK: - Initialization
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        self.rootView = GalleryRootView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presentPhotoPicker()
    }

    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 20
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension GalleryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        viewModel.handlePickedResults(results)
    }
}
