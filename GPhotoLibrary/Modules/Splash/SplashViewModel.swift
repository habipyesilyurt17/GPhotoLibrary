//
//  SplashViewModel.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import Combine

final class SplashViewModel {
    // MARK: - Properties
    private let coordinator: SplashCoordinator
    private var disposeBag = Set<AnyCancellable>()

    var onPermissionGranted: (() -> Void)?
    var onPermissionDenied: (() -> Void)?
    
    init(coordinator: SplashCoordinator,
         onPermissionGranted: (() -> Void)? = nil,
         onPermissionDenied: (() -> Void)? = nil
    ) {
        self.coordinator = coordinator
        self.onPermissionGranted = onPermissionGranted
        self.onPermissionDenied = onPermissionDenied
    }
    
    func checkPermission() {
        PermissionManager.shared.checkPhotoLibraryPermission { [weak self] granted in
            if granted {
                self?.onPermissionGranted?()
            } else {
                self?.onPermissionDenied?()
            }
        }
    }
}
