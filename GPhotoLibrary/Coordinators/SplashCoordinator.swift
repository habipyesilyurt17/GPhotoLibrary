//
//  SplashCoordinator.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import Combine

final class SplashCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private var disposeBag = Set<AnyCancellable>()
    private let appRoot: CurrentValueSubject<Roots, Never>
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController,
         appRoot: CurrentValueSubject<Roots, Never>) {
        self.navigationController = navigationController
        self.appRoot = appRoot
    }
    
    func start() {
        let viewModel = SplashViewModel(coordinator: self)
        let splashVC = SplashViewController(viewModel: viewModel)

        splashVC.onPermissionGranted = { [weak self] in
            self?.showGallery()
        }

        navigationController.setViewControllers([splashVC], animated: false)
    }
    
    private func showGallery() {
        let galleryCoordinator = GalleryCoordinator(
            navigationController: navigationController,
            appRoot: .init(.gallery))
        galleryCoordinator.start()
    }
}
