//
//  MainPresenter.swift
//  NYTProject
//
//  Created by Наталия Желанова on 10.07.2026.
//

import UIKit

enum MainItem {
    case newsItem(NewsItem)
    case popularsItem([PopularItems])
}

final class MainPresenter {
    weak var view: MainViewController?
    
    private(set) var items: [MainItem] = []
    
    private let apiKey = "GSJqsppxPEQS5Ae65Ie8r5c4WSQVjzxb4JVCh5pgwuAbWGmb"
    
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
                    self?.view?.endRefreshing()
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
                    let news: [NewsItem] = decodedData.results ?? []
                    var mainItems: [MainItem] = news.map { .newsItem($0) }
                    var oldPopularItems: [PopularItems]?
                    
                    for item in self?.items ?? [] {
                        switch item {
                        case .newsItem(_):
                            continue
                        case .popularsItem(let popularItems):
                            oldPopularItems = popularItems
                            break
                        }
                    }
                    
                    if let oldPopularItems {
                        if mainItems.count >= 4 {
                            mainItems.insert(.popularsItem(oldPopularItems), at: 3)
                        } else {
                            mainItems.append(.popularsItem(oldPopularItems))
                        }
                    }
                    
                    self?.items = mainItems
                
                    self?.view?.reloadData()
                    self?.view?.endRefreshing()
                }
            } catch {
                print("Ошибка парсинга: \(error)")
                DispatchQueue.main.async { self?.view?.endRefreshing() }
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
                DispatchQueue.main.async { self?.view?.endRefreshing() }
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
                    let popular: [PopularItems] = decodedData.results ?? []
                    var oldPopularIndex: Int?
                    
                    let existedItems = self?.items ?? []
                    for (index, item) in existedItems.enumerated() {
                        switch item {
                        case .newsItem(_):
                            continue
                        case .popularsItem(let popularItems):
                            oldPopularIndex = index
                            break
                        }
                    }
                    
                    if let oldPopularIndex {
                        self?.items.remove(at: oldPopularIndex)
                        self?.items.insert(.popularsItem(popular), at: oldPopularIndex)
                    } else {
                        if self?.items.count ?? 0 >= 4 {
                            self?.items.insert(.popularsItem(popular), at: 3)
                        } else {
                            self?.items.append(.popularsItem(popular))
                        }
                    }
                                        
                    self?.view?.reloadData()
                    self?.view?.endRefreshing()
                }
            } catch {
                print("Ошибка парсинга популярных статей: \(error)")
                DispatchQueue.main.async { self?.view?.endRefreshing() }
            }
        }.resume()
    }
}
