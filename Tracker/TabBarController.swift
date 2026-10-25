//
//  TabBarController.swift
//  Tracker
//
//  Created by Алик on 24.10.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        configureAppearance()
        configureViewControllers()
    }
    
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.stackedLayoutAppearance.selected.iconColor = .blueTracker
        appearance.stackedLayoutAppearance.normal.iconColor = .grayTracker
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func configureViewControllers() {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle.fill"), tag: 0)
        let trackersViewNavagationController = UINavigationController(rootViewController: trackersViewController)
        
        let statisticViewController = TrackersViewController()
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare.fill"), tag: 1)
        
        viewControllers = [
            trackersViewNavagationController,
            statisticViewController
            ]
        
    }
    
    
    
}

