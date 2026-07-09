//
//  MainViewController.swift
//  NYTProject
//
//  Created by Наталия Желанова on 02.06.2026.
//
//
import UIKit
import SafariServices

class MainViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cellIdentifier = "NewsCell"
    private let headerView = NewsHeaderView()
    private var newsItems: [NewsItem] = []
    private var popularItems: [PopularItems] = []
    private let refreshControl = UIRefreshControl()
    private let apiKey = "GSJqsppxPEQS5Ae65Ie8r5c4WSQVjzxb4JVCh5pgwuAbWGmb"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
        fetchPopularData()
    }
    
    func setup() {
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
        fetchData()
        fetchPopularData()
    }
    
    func fetchData() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.nytimes.com"
        urlComponents.path = "/svc/topstories/v2/home.json"
        urlComponents.queryItems = [
            .init(name: "api-key", value: apiKey),
        ]
        
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                print("Нет данных")
                
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(NYTResponse.self, from: data)
                
                /*if let firstArticle = decodedData.results?.first {
                    print("Заголовок: \(firstArticle.title ?? "без заголовка")")
                    print("Описание: \(firstArticle.abstract ?? "без описания")")
                    print("Картинка: \(firstArticle.multimedia?.first?.url ?? "нет фото")")
                }*/
                
                DispatchQueue.main.async {
                    self?.newsItems = decodedData.results ?? []
                    self?.collectionView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            } catch {
                print("Ошибка парсинга: \(error)")
                DispatchQueue.main.async { self?.refreshControl.endRefreshing() }
            }
        }.resume()
    }
    
    func fetchPopularData() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.nytimes.com"
        urlComponents.path = "/svc/mostpopular/v2/emailed/7.json"
        urlComponents.queryItems = [
            .init(name: "api-key", value: "GSJqsppxPEQS5Ae65Ie8r5c4WSQVjzxb4JVCh5pgwuAbWGmb"),
        ]
        
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                print("Ошибка: данные популярных статей не получены")
                DispatchQueue.main.async { self?.refreshControl.endRefreshing() }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(NYTPopularResponse.self, from: data)
                
                if let firstPopularArticle = decodedData.results?.first {
                    print("Заголовок: \(firstPopularArticle.title ?? "без заголовка")")
                    
                    let firstMedia = firstPopularArticle.media?.first
                    let firstMetadata = firstMedia?.mediaMetadata?.first
                    
                    print("Картинка: \(firstMetadata?.url ?? "нет фото")")
                }
                
                DispatchQueue.main.async {
                    self?.popularItems = decodedData.results ?? []
                    self?.collectionView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            } catch {
                print("Ошибка парсинга популярных статей: \(error)")
                DispatchQueue.main.async { self?.refreshControl.endRefreshing()
                }
            }
        }.resume()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if newsItems.isEmpty { return 0 }
        
        return popularItems.isEmpty ? newsItems.count : (newsItems.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewsCell
            let newsItem = newsItems[indexPath.item]
            cell.configure(with: newsItem)
            cell.stackView.arrangedSubviews.last?.isHidden = false
            return cell
            
        } else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HorizontalNewsSectionCell.identifier,
                for: indexPath
            ) as! HorizontalNewsSectionCell
            
            cell.configure(with: popularItems)
            
            cell.onArticleTap = { [weak self] urlString in
                guard let url = URL(string: urlString) else { return }
                
                let safariVC = SFSafariViewController(url: url)
                safariVC.preferredControlTintColor = .systemBlue
                self?.present(safariVC, animated: true, completion: nil)
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewsCell
            let newsItem = newsItems[indexPath.item - 1]
            cell.configure(with: newsItem)
            
            if indexPath.item == newsItems.count {
                cell.stackView.arrangedSubviews.last?.alpha = 0
            } else {
                cell.stackView.arrangedSubviews.last?.alpha = 1
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString: String?
        
        if indexPath.item < 4 {
            urlString = newsItems[indexPath.item].url
        } else if indexPath.item == 4 {
            return
        } else {
            urlString = newsItems[indexPath.item - 1].url
        }
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            print("Не удалось получить ссылку на статью")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemBlue
        present(safariVC, animated: true, completion: nil)
    }
}
