//
//  CompactNewsCell.swift
//  NYTProject
//
//  Created by Наталия Желанова on 17.06.2026.
//

import UIKit

class CompactNewsCell: UICollectionViewCell {
    static let identifier = "CompactNewsCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Business Groups Denounce Proposal to Pull Customs From 'Sanctuary' City Airports"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.rectangle.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(newsImageView)
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            newsImageView.widthAnchor.constraint(equalToConstant: 90), 
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])

    }
    
    func configure(with article: PopularItems) {
        titleLabel.text = article.title
        
        if let imageUrlString = article.media?.first?.mediaMetadata.first?.url,
           let url = URL(string: imageUrlString) {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.newsImageView.image = image
                    }
                }
            }.resume()
            
        } else {
            newsImageView.image = UIImage(systemName: "person.crop.rectangle.fill")
        }
    }
}
