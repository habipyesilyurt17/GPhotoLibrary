//
//  ThumbnailCollectionViewCell.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit

final class ThumbnailCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ThumbnailCollectionViewCell"
    
    var onCloseButtonTapped: (() -> Void)?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let closeButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12 // 24/2 için yarıçap
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var closeButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "xmark-icon")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(closeButtonContainer)
        closeButtonContainer.addSubview(closeButtonImageView)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        closeButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            closeButtonContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            closeButtonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            closeButtonContainer.widthAnchor.constraint(equalToConstant: 24),
            closeButtonContainer.heightAnchor.constraint(equalToConstant: 24),
            
            closeButtonImageView.centerXAnchor.constraint(equalTo: closeButtonContainer.centerXAnchor),
            closeButtonImageView.centerYAnchor.constraint(equalTo: closeButtonContainer.centerYAnchor),
            closeButtonImageView.widthAnchor.constraint(equalToConstant: 16),
            closeButtonImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        closeButtonContainer.addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeButtonTapped() {
        onCloseButtonTapped?()
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        onCloseButtonTapped = nil
    }
}
