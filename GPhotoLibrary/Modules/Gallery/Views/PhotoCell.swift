//
//  PhotoCell.swift
//  GPhotoLibrary
//
//  Created by Habip on 23.05.2025.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.isHidden = true
        return view
    }()
    
    private let selectionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let selectedCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(blurView)
        contentView.addSubview(selectionContainer)
        selectionContainer.addSubview(selectedCountLabel)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        selectionContainer.translatesAutoresizingMaskIntoConstraints = false
        selectedCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectionContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            selectionContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            selectionContainer.widthAnchor.constraint(equalToConstant: 24),
            selectionContainer.heightAnchor.constraint(equalToConstant: 24),
            
            selectedCountLabel.centerXAnchor.constraint(equalTo: selectionContainer.centerXAnchor),
            selectedCountLabel.centerYAnchor.constraint(equalTo: selectionContainer.centerYAnchor)
        ])
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
    
    func setSelected(_ isSelected: Bool, selectionOrder: Int? = nil) {
        blurView.isHidden = !isSelected
        selectionContainer.isHidden = !isSelected
        
        if let order = selectionOrder {
            selectedCountLabel.text = "\(order)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        setSelected(false)
        selectedCountLabel.text = nil
    }
}
