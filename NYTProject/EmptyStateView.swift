//
//  EmptyStateView.swift
//  NYTProject
//
//  Created by Наталия Желанова on 04.07.2026.
//

import UIKit

final class EmptyStateView: UIView {
    
    //UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        imageView.image = UIImage(systemName: "magnifyingglass.circle", withConfiguration: symbolConfig)
        imageView.tintColor = UIColor.systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "Введите запрос для поиска статей"
            label.textColor = UIColor.systemGray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            label.numberOfLines = 0
            return label
        }()
    
    private lazy var stackView: UIStackView = {
           let stack = UIStackView(arrangedSubviews: [imageView, messageLabel])
           stack.axis = .vertical
           stack.spacing = 16
           stack.alignment = .center
           stack.translatesAutoresizingMaskIntoConstraints = false
           return stack
       }()
    
    //Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configure(imageName: String, message: String) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        imageView.image = UIImage(systemName: imageName, withConfiguration: symbolConfig)
        messageLabel.text = message
    }
    
    private func setupLayout() {
            addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
            ])
        }
}

