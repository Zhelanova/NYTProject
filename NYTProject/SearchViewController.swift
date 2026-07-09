//
//  SearchViewController.swift
//  NYTProject
//
//  Created by Наталия Желанова on 29.06.2026.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cellIdentifier = "NewsCell"
    
    private var defaultNews: [NewsItem] = []
    private var searchResults: [DocItem] = []
    
    private var isSearching: Bool = false
    
    private let apiKey = "GSJqsppxPEQS5Ae65Ie8r5c4WSQVjzxb4JVCh5pgwuAbWGmb"
    private var searchTask: URLSessionDataTask?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search The Times"
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let startView = EmptyStateView()
            startView.configure(imageName: "magnifyingglass.circle", message: "Search The New York Times")
            collectionView.backgroundView = startView
    }
    
    func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .systemGroupedBackground
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.estimatedItemSize = .zero
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32, height: 200)

        layout.minimumLineSpacing = 16
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func performSearch(with query: String) {
        searchTask?.cancel()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.nytimes.com" 
        urlComponents.path = "/svc/search/v2/articlesearch.json"
        urlComponents.queryItems = [
            .init(name: "q", value: query),
            .init(name: "api-key", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            print("❌ Не удалось создать URL")
            return
        }
        
        searchTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error as NSError?, error.code == NSURLErrorCancelled { return }
            if let error = error {
                print("❌ Ошибка сети: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("❌ Данные от сервера не пришли")
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📡 Ответ сервера: \(jsonString)")
            }
            do {
                let decodedData = try JSONDecoder().decode(ArticleSearchRoot.self, from: data)
                DispatchQueue.main.async {
                    self?.isSearching = true
                    self?.searchResults = decodedData.response?.docs ?? []
                    
                    if let firstDoc = self?.searchResults.first {
                        print("👁️ Количество элементов в multimedia: \(firstDoc.multimedia != nil ? "Объект существует" : "nil")")
                        print("👁️ URL первой картинки: \(String(describing: firstDoc.multimedia?.defaultImage))")
                    }
                    
                    self?.collectionView.reloadData()
                    
                    if self?.searchResults.isEmpty == true {
                        let emptyView = EmptyStateView()
                        
                        emptyView.configure(imageName: "doc.text.magnifyingglass", message: "No Results")
                        
                        self?.collectionView.backgroundView = emptyView
                    } else {
                        self?.collectionView.backgroundView = nil
                    }
                }
            } catch {
                print("❌ Ошибка декодирования: \(error)")
            }
        }
        
        searchTask?.resume()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cleanText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanText.isEmpty {
            searchTask?.cancel()
            isSearching = false
            searchResults = []
            collectionView.reloadData()
            
            let startView = EmptyStateView()
            startView.configure(imageName: "magnifyingglass.circle", message: "Search The New York Times")
            collectionView.backgroundView = startView
            return
        }
        
        performSearch(with: cleanText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cleanText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !cleanText.isEmpty {
            performSearch(with: cleanText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchResults = []
        self.collectionView.reloadData()
        
        let startView = EmptyStateView()
        startView.configure(imageName: "magnifyingglass.circle", message: "Search The New York Times")
        collectionView.backgroundView = startView
        
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : defaultNews.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewsCell
        
        if isSearching {
            if indexPath.item < searchResults.count {
                let searchItem = searchResults[indexPath.item]
                cell.configure(with: searchItem)
            }
        } else {
            if indexPath.item < defaultNews.count {
                let newsItem = defaultNews[indexPath.item]
                cell.configure(with: newsItem)
            }
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width - 32, height: 400)
//    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString: String?
        
        if isSearching {
            urlString = searchResults[indexPath.item].webUrl
        } else {
            urlString = defaultNews[indexPath.item].url
        }
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("❌ Ссылка на статью пустая или повреждена")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemBlue
        present(safariVC, animated: true, completion: nil)
    }
}
