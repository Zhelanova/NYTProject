//
//  NewsHeaderView.swift
//  NYTProject
//
//  Created by Наталия Желанова on 15.06.2026.
//
import UIKit

class NewsHeaderView: UIView {
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "new_york_times_logo 1")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let modeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "moon"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let addBottomSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(logoImageView)
        addSubview(modeButton)
        addSubview(addBottomSeparator)
        
        modeButton.addTarget(self, action: #selector(toggleTheme), for: .touchUpInside)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        modeButton.translatesAutoresizingMaskIntoConstraints = false
        addBottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8),
            logoImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
                       
            modeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            modeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            modeButton.widthAnchor.constraint(equalToConstant: 40),
            modeButton.heightAnchor.constraint(equalToConstant: 40),
            modeButton.widthAnchor.constraint(equalToConstant: 40),
            
            addBottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            addBottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            addBottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            addBottomSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc
    func toggleTheme() {
        guard let window = self.window else { return }
        window.overrideUserInterfaceStyle = window.traitCollection.userInterfaceStyle == .dark ? .light : .dark
    }
}

extension NewsHeaderView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isDark = traitCollection.userInterfaceStyle == .dark
        
        backgroundColor = isDark ? .black : .white
//        searchButton.tintColor = isDark ? .white : .black
        modeButton.tintColor = isDark ? .white : .black
        logoImageView.tintColor = isDark ? .white : .black
        
        let icon = isDark ? UIImage(systemName: "sun.max") : UIImage(systemName: "moon")
        modeButton.setImage(icon, for: .normal)
    }
}
