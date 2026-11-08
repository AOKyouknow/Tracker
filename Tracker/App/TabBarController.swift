//
//  TabBarController.swift
//  Tracker
//
//  Created by Алик on 24.10.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        configureViewControllers()
    }
    
    // MARK: - Private Methods
    
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
        viewControllers = [
            makeTrackersViewController(),
            makeStatisticsViewController()
        ]
    }

    private func makeTrackersViewController() -> UIViewController {
        let viewController = TrackersViewController()

        viewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            tag: 0
        )

        return UINavigationController(rootViewController: viewController)
    }

    private func makeStatisticsViewController() -> UIViewController {
        let viewController = UIViewController()

        viewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            tag: 1
        )

        return viewController
    }
    
    
}

