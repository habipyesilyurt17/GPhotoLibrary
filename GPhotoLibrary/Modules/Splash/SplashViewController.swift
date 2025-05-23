//
//  SplashViewController.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit
import PhotosUI

final class SplashViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: SplashViewModel
    private var rootView: SplashRootView
    var onPermissionGranted: (() -> Void)?
    
    // MARK: - Initialization
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        self.rootView = SplashRootView(viewModel: viewModel)
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
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkPermission()
    }
    
    private func setupBindings() {
        viewModel.onPermissionGranted = { [weak self] in
            self?.onPermissionGranted?()
        }
        
        viewModel.onPermissionDenied = { [weak self] in
            DispatchQueue.main.async {
                self?.showPermissionAlert()
            }
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(applicationDidBecomeActive),
                                             name: UIApplication.didBecomeActiveNotification,
                                             object: nil)
    }
    
    @objc private func applicationDidBecomeActive() {
        viewModel.checkPermission()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func showPermissionAlert() {
        if presentedViewController != nil { return }
        
        let alert = UIAlertController(
            title: "Permission Required",
            message: "You must grant access to the photo gallery.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        let exitAction = UIAlertAction(title: "Exit Application", style: .destructive) { _ in
            exit(0)
        }
        
        alert.addAction(settingsAction)
        alert.addAction(exitAction)
        
        present(alert, animated: true)
    }
    
    private func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = Constants.maximumPhotoCount
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension SplashViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let itemProviders = results.map(\.itemProvider)
        
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let _ = self else { return }
                    if let _ = image as? UIImage {
                        DispatchQueue.main.async {}
                    }
                }
            }
        }
    }
}
