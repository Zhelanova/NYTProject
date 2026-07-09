//
//  NewsCell.swift
//  NYTProject
//
//  Created by Наталия Желанова on 04.06.2026.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    //MARK - UI Elemets
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NewYork-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
        label.numberOfLines = 3
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "NewYork-Regular", size: 14) ?? .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 180)
            heightConstraint.priority = .defaultHigh
            heightConstraint.isActive = true
                
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        timeLabel.textColor = .tertiaryLabel
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        timeLabel.text = nil
        imageView.image = nil
        
        imageView.isHidden = false
    }
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            imageView,
            timeLabel,
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func setupViews() {
        contentView.addSubview(stackView)
        contentView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32),
            
            imageView.heightAnchor.constraint(equalToConstant: 180),
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        
        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        attributes.frame.size.height = ceil(size.height)
        return attributes
    }
    
    func formatNYTDate(_ dateString: String) -> String {
        let ISOFormatter = ISO8601DateFormatter()
        
        guard let date = ISOFormatter.date(from: dateString) else { return dateString }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)
        
        if Calendar.current.isDateInToday(date) {
            return "Today, \(timeString)"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, HH:mm"
            return dateFormatter.string(from: date)
        }
    }
    
    func configure(with item: NewsItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.abstract
        timeLabel.text = formatNYTDate(item.publishedDate ?? "")
                
        if let imageUrlString = item.multimedia?.first?.url,
           let url = URL(string: imageUrlString) {
            
            imageView.isHidden = false
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        } else {
            imageView.image = nil
            imageView.isHidden = true
        }
    }
    
    func configure(with searchItem: DocItem) {
        titleLabel.text = searchItem.headline?.main ?? "No title available"
        subtitleLabel.text = searchItem.abstract ?? "No description available"
        
        if let author = searchItem.byline?.original {
            timeLabel.text = author
        } else {
            timeLabel.text = nil
        }
                
        if let imageUrlString = searchItem.multimedia?.defaultImage?.url,
           let url = URL(string: imageUrlString) {
            
            imageView.isHidden = false
            imageView.image = nil
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
            
        } else {
            imageView.image = nil
            imageView.isHidden = true
        }
    }
}
