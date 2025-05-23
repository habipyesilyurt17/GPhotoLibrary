//
//  BannerManager.swift
//  GPhotoLibrary
//
//  Created by Habip on 24.05.2025.
//

import UIKit

enum BannerType {
    case success
    case error
    case warning
    case info

    var iconName: String {
        switch self {
        case .success: return "checkmark.circle"
        case .error: return "xmark.circle"
        case .warning: return "exclamationmark.triangle"
        case .info: return "info.circle"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .success: return UIColor.systemGreen
        case .error: return UIColor.systemRed
        case .warning: return UIColor.systemOrange
        case .info: return UIColor.systemBlue
        }
    }
}


final class BannerManager {
    static let shared = BannerManager()
    
    private var bannerWindow: UIWindow?
    
    private init() {}
    
 
    func showBanner(type: BannerType, title: String, duration: TimeInterval = 2.0) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let bannerHeight: CGFloat = 80
        let banner = BannerView(type: type, title: title)
        banner.translatesAutoresizingMaskIntoConstraints = false

        keyWindow.addSubview(banner)

        let topConstraint = banner.topAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.topAnchor, constant: -bannerHeight)
        NSLayoutConstraint.activate([
            topConstraint,
            banner.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 16),
            banner.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -16),
            banner.heightAnchor.constraint(greaterThanOrEqualToConstant: bannerHeight)
        ])

        keyWindow.layoutIfNeeded()

        topConstraint.constant = 16
        UIView.animate(withDuration: 0.3) {
            keyWindow.layoutIfNeeded()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            topConstraint.constant = -bannerHeight
            UIView.animate(withDuration: 0.3, animations: {
                keyWindow.layoutIfNeeded()
            }) { _ in
                banner.removeFromSuperview()
            }
        }
    }

}
