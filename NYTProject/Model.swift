//
//  Model.swift
//  NYTProject
//
//  Created by Наталия Желанова on 04.06.2026.

import UIKit
import UIKit

// обычные статьи
struct NYTResponse: Codable {
    let status: String
    let results: [NewsItem]?
}

struct NewsItem: Codable {
    let title: String?
    let abstract: String?
    let publishedDate: String?
    let multimedia: [Multimedia]?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case abstract
        case publishedDate = "published_date"
        case multimedia
        case url
    }
}

struct Multimedia: Codable {
    let url: String
    let format: String?
}

//популярные статьи
struct NYTPopularResponse: Codable {
    let status: String
    let copyright: String?
    let results: [PopularItems]?
}

struct PopularItems: Codable {
    let id: Int
    let title: String?
    let media: [MediaItem]?
    let url: String?
}

struct MediaItem: Codable {
    let mediaMetadata: [MediaMetadata]?
    
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadata: Codable {
    let url: String
    let height: Int?
    let width: Int?
} 

// поисковые запросы
struct ArticleSearchRoot: Codable {
    let status: String?
    let copyright: String?
    let response: ArticleSearchContainer?
}

struct ArticleSearchContainer: Codable {
    let docs: [DocItem]?
}

struct DocItem: Codable {
    let abstract: String?
    let headline: HeadlineItem?
    let byline: BylineItem?
    let multimedia: SearchMultimediaItem?
    let webUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case abstract
        case headline
        case byline
        case multimedia
        case webUrl = "web_url" 
    }
}

struct HeadlineItem: Codable {
    let main: String?
}

struct BylineItem: Codable {
    let original: String?
}

struct SearchMultimediaItem: Codable {
    let caption: String?
    let credit: String?
    let defaultImage: ImageDetails?
    let thumbnail: ImageDetails?
    
    enum CodingKeys: String, CodingKey {
        case caption
        case credit
        case defaultImage = "default"
        case thumbnail
    }
}

struct ImageDetails: Codable {
    let url: String
    let height: Int?
    let width: Int?
}

