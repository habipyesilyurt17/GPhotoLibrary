//
//  GalleryViewController.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import PhotosUI
import Combine

final class GalleryViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: GalleryViewModel
    private var cancellables = Set<AnyCancellable>()
    private var rootView: GalleryRootView
    
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
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.$assets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.reloadData()
            }
            .store(in: &cancellables)
    }
}
