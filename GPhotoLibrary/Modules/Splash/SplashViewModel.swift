//
//  SplashViewModel.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import Combine
import Photos

final class SplashViewModel {
    // MARK: - Properties
    private let coordinator: SplashCoordinator
    private var disposeBag = Set<AnyCancellable>()
    private var isPermissionChecked = false
    var permissionStateDidChange: ((PermissionState) -> Void)?
    var onPermissionGranted: (() -> Void)?
    private var currentPermissionState: PermissionState = .notDetermined {
        didSet {
            permissionStateDidChange?(currentPermissionState)
            if currentPermissionState == .granted {
                onPermissionGranted?()
            }
        }
    }
    
    init(coordinator: SplashCoordinator,
         onPermissionGranted: (() -> Void)? = nil,
         onPermissionDenied: (() -> Void)? = nil
    ) {
        self.coordinator = coordinator
        self.onPermissionGranted = onPermissionGranted
    }
    
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .notDetermined:
            requestPermission()
        case .restricted, .denied:
            currentPermissionState = .denied
        case .authorized, .limited:
            currentPermissionState = .granted
        @unknown default:
            currentPermissionState = .denied
        }
    }
    
    private func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.currentPermissionState = .granted
                case .denied, .restricted:
                    self?.currentPermissionState = .denied
                case .notDetermined:
                    self?.currentPermissionState = .notDetermined
                @unknown default:
                    self?.currentPermissionState = .denied
                }
            }
        }
    }
}
