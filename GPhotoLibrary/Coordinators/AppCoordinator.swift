//
//  AppCoordinator.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import Combine

protocol Coordinator: AnyObject {
    func start()
}

enum Roots: String {
    case splash
    case gallery
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private var childCoordinators = [Roots: Coordinator]()
    private var appRoot = CurrentValueSubject<Roots, Never>(.splash)
    private var disposeBag = Set<AnyCancellable>()
    private let scheduler: DispatchQueue

    
    init(window: UIWindow,
         scheduler: DispatchQueue = .main) {
        self.window = window
        self.scheduler = scheduler
    }
    
    func start() {
        subscribeToRootChanges()
    }
    
    private func subscribeToRootChanges() {
        appRoot
            .receive(on: scheduler)
            .removeDuplicates()
            .sink { [weak self] root in
                self?.transition(to: root)
            }
            .store(in: &disposeBag)
    }
    
    private func transition(to root: Roots) {
        switch root {
        case .splash:
            startSplashFlow()
        case .gallery:
            startGalleryFlow()
        }
    }
    
    private func startSplashFlow() {
        self.childCoordinators.removeAll()
        let navigationController = UINavigationController()
        let splashCoordinator = SplashCoordinator(
            navigationController: navigationController,
            appRoot: appRoot)
        splashCoordinator.start()
        childCoordinators[.splash] = splashCoordinator
        setRootWithAnimation(navigationController)
    }
    
    private func startGalleryFlow() {
        self.childCoordinators.removeAll()
        let navigationController = UINavigationController()
        let galleryCoordinator = GalleryCoordinator(
            navigationController: navigationController,
            appRoot: appRoot)
        galleryCoordinator.start()
        childCoordinators[.gallery] = galleryCoordinator
        setRootWithAnimation(navigationController)
    }
    
    private func setRootWithAnimation(_ controller: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.window.rootViewController = controller
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: { _ in })
        }
    }
}
