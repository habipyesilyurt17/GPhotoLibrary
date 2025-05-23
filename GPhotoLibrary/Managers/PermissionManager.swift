//
//  PermissionManager.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import Photos
import UIKit

final class PermissionManager {
    static let shared = PermissionManager()
    private var isPermissionChecking = false

    private init() {}
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        guard !isPermissionChecking else { return }
        isPermissionChecking = true
        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            isPermissionChecking = false
            completion(true)
        case .denied, .restricted:
            isPermissionChecking = false
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                DispatchQueue.main.async {
                    self?.isPermissionChecking = false
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            isPermissionChecking = false
            completion(false)
        }
    }
}
