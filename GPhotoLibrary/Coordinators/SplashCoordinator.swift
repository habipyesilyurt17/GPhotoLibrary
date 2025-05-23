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

    init(navigationController: UINavigationController,
         appRoot: CurrentValueSubject<Roots, Never>) {
        self.navigationController = navigationController
        self.appRoot = appRoot
    }
    
    func start() {
        let viewModel = SplashViewModel(coordinator: self)
        let splashVC = SplashViewController(viewModel: viewModel)

        splashVC.onPermissionGranted = { [weak self] in
            self?.navigateToGallery()
        }

        navigationController.setViewControllers([splashVC], animated: false)
    }
    
    private func navigateToGallery() {
        self.appRoot.send(.gallery)
    }
}
