//
//  GalleryCoordinator.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import Combine

final class GalleryCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var disposeBag = Set<AnyCancellable>()
    private let appRoot: CurrentValueSubject<Roots, Never>
    
    init(navigationController: UINavigationController,
         appRoot: CurrentValueSubject<Roots, Never>){
        self.navigationController = navigationController
        self.appRoot = appRoot
    }
    
    func start() {
        let viewModel = GalleryViewModel(coordinator: self)
        let galleryVC = GalleryViewController(viewModel: viewModel)
        navigationController.setViewControllers([galleryVC], animated: true)
        navigationController.isNavigationBarHidden = true
    }
} 
