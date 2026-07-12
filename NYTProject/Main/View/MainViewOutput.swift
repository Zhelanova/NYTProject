//
//  MainViewOutput.swift
//  NYTProject
//
//  Created by Наталия Желанова on 12.07.2026.
//

protocol MainViewOutput: AnyObject {
    func fetchData()
    func fetchPopularData()
    
    var items: [MainItem] { get }

}
