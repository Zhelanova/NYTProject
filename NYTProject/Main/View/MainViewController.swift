//
//  MainViewController.swift
//  NYTProject
//
//  Created by Наталия Желанова on 02.06.2026.
//
//
import UIKit
import SafariServices

class MainViewController: UIViewController, MainViewInput {
    var presenter: MainViewOutput?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cellIdentifier = "NewsCell"
    private let headerView = NewsHeaderView()
    private let refreshControl = UIRefreshControl()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.fetchData()
        presenter?.fetchPopularData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(HorizontalNewsSectionCell.self, forCellWithReuseIdentifier: HorizontalNewsSectionCell.identifier)
        
        collectionView.backgroundColor = .systemGroupedBackground
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        layout.minimumLineSpacing = 16
        
        view.addSubview(headerView)
        view.addSubview(collectionView)
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func refreshData() {
        presenter?.fetchData()
        presenter?.fetchPopularData()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let items = presenter?.items else {
            fatalError()
        }
        
        let item = items[indexPath.item]
        
        switch item {
        case .newsItem(let newsItemModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewsCell
            cell.configure(with: newsItemModel)
            return cell
        case .popularsItem(let popularItemModel):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HorizontalNewsSectionCell.identifier,
                for: indexPath
            ) as! HorizontalNewsSectionCell
            cell.configure(with: popularItemModel)
            cell.onArticleTap = { [weak self] urlString in
                guard let url = URL(string: urlString) else { return }
                
                let safariVC = SFSafariViewController(url: url)
                safariVC.preferredControlTintColor = .systemBlue
                self?.present(safariVC, animated: true, completion: nil)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = presenter?.items else {
            fatalError()
        }
        
        let item = items[indexPath.item]
        switch item {

        case .newsItem(let newsItemModel):
            guard let urlString = newsItemModel.url,
                  let url = URL(string: urlString) else {
                print("Не удалось получить ссылку на статью")
                return
            }
            
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredControlTintColor = .systemBlue
            present(safariVC, animated: true, completion: nil)
        case .popularsItem:
            return
        }
    }
}
