//
//  HorizontalNewsSectionCell.swift
//  NYTProject
//
//  Created by Наталия Желанова on 17.06.2026.
//
import UIKit

class HorizontalNewsSectionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static let identifier = "HorizontalNewsSectionCell"
    private var popularArticles: [PopularItems] = []
    
    var onArticleTap: ((String) -> Void)?
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(horizontalCollectionView)
        contentView.backgroundColor = .clear
        
        if let layout = horizontalCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
              layout.minimumLineSpacing = 12
              layout.minimumInteritemSpacing = 8
          }
        
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        horizontalCollectionView.register(CompactNewsCell.self, forCellWithReuseIdentifier: CompactNewsCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CompactNewsCell.identifier,
            for: indexPath
        ) as! CompactNewsCell
        
        let article = popularArticles[indexPath.item]
        cell.configure(with: article)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlString = popularArticles[indexPath.item].url {
            onArticleTap?(urlString)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 16
        let cellHeight = height / 2 - 4
        return CGSize(width: 280, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    func configure(with items: [PopularItems]) {
        self.popularArticles = items
        self.horizontalCollectionView.reloadData()
    }
}
