//
//  SplashRootView.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit

final class SplashRootView: UIView {
    // MARK: - UI Components
    private lazy var permissionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open Settings", for: .normal)
        button.isHidden = true
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        return button
    }()
    
    private lazy var permissionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please grant photo access permission"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    private let viewModel: SplashViewModel
    
    // MARK: - Initialization
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .white
        addSubview(permissionLabel)
        addSubview(permissionButton)
    }
    
    private func setupConstraints() {
        permissionLabel.translatesAutoresizingMaskIntoConstraints = false
        permissionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            permissionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            permissionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            permissionButton.topAnchor.constraint(equalTo: permissionLabel.bottomAnchor, constant: 20),
            permissionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            permissionButton.widthAnchor.constraint(equalToConstant: 200),
            permissionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupBindings() {
        viewModel.permissionStateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateUI(for: state)
            }
        }
    }
    
    private func updateUI(for state: PermissionState) {
        switch state {
        case .notDetermined:
            permissionLabel.isHidden = true
            permissionButton.isHidden = true
        case .granted:
            permissionLabel.isHidden = true
            permissionButton.isHidden = true
        case .denied:
            permissionLabel.isHidden = false
            permissionButton.isHidden = false
        }
    }
    
    @objc private func openSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
}
