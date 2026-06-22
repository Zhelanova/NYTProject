//
//  NewsHeaderView.swift
//  NYTProject
//
//  Created by Наталия Желанова on 15.06.2026.
//
import UIKit

class NewsHeaderView: UIView {
    private let stackView = UIStackView()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "magnifyingglass")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
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
        addSubview(stackView)
        addSubview(addBottomSeparator)
        
        modeButton.addTarget(self, action: #selector(toggleTheme), for: .touchUpInside)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addBottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        stackView.addArrangedSubview(searchButton)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(modeButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchButton.widthAnchor.constraint(equalToConstant: 40),
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
        searchButton.tintColor = isDark ? .white : .black
        modeButton.tintColor = isDark ? .white : .black
        logoImageView.tintColor = isDark ? .white : .black
        
        let icon = isDark ? UIImage(systemName: "sun.max") : UIImage(systemName: "moon")
        modeButton.setImage(icon, for: .normal)
    }
}
