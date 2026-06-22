//
//  Model.swift
//  NYTProject
//
//  Created by Наталия Желанова on 04.06.2026.
//

import UIKit

//обычные статьи
struct NYTResponse: Codable {
    let status: String
    let results: [NewsItem]
}

struct NewsItem: Codable {
    let title: String
    let abstract: String
    let publishedDate: String
    let multimedia: [Multimedia]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case abstract
        case publishedDate = "published_date"
        case multimedia
    }
}

struct Multimedia: Codable {
    let url: String
    let format: String 
}

//популярный статьи
struct NYTPopularResponse: Codable {
    let status: String
    let copyright: String
    let results: [PopularItems]
}

struct PopularItems: Codable {
    let id: Int
    let title: String
    let media: [MediaItem]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case media
    }
}

struct MediaItem: Codable {
    let mediaMetadata: [MediaMetadata]
    
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata" 
    }
}

struct MediaMetadata: Codable {
    let url: String
}


