//
//  MainAssembler.swift
//  NYTProject
//
//  Created by Наталия Желанова on 12.07.2026.
//
import UIKit

struct MainAssembler {
    func build() -> UIViewController {
        let mainViewController = MainViewController()
        let mainPresenter = MainPresenter()
        
        mainViewController.presenter = mainPresenter
        mainPresenter.view = mainViewController
        
        return mainViewController
    }
}
