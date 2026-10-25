//
//  ViewController.swift
//  Tracker
//
//  Created by Алик on 22.10.2026.
//

import UIKit

class TrackersViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private lazy var navBarItem: UIBarButtonItem = {
        let navBarItem = UIBarButtonItem()
        navBarItem.image = UIImage(resource: .plus)
        navBarItem.tintColor = .blackTracker
        return navBarItem
    }()
    
    private var titleOfTab: UILabel = {
        let titleOfTab = UILabel()
        titleOfTab.text = "Трекеры"
        titleOfTab.font = UIFont.systemFont(ofSize: CGFloat(Constants.sizeOfTitle), weight: .bold)
        titleOfTab.translatesAutoresizingMaskIntoConstraints = false
        
        return titleOfTab
    }()
    
    let trackersEmptyLogo: UIImageView = {
        let trackersEmptyLogo = UIImageView(image: .trackersEmptyLogo)
        trackersEmptyLogo.translatesAutoresizingMaskIntoConstraints = false
        return trackersEmptyLogo
    }()
    
    let titleForTrackersEmptyLogo: UILabel = {
        let titleForTrackersEmptyLogo = UILabel()
        titleForTrackersEmptyLogo.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleForTrackersEmptyLogo.text = "Что будем отслеживать?"
        titleForTrackersEmptyLogo.translatesAutoresizingMaskIntoConstraints = false
        return titleForTrackersEmptyLogo
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "de_CH")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)// nil, чтобы поиск не перекидывал на другой экран
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = navBarItem
        navigationItem.searchController = searchController
        view.backgroundColor = .white
        
        let datePickerBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerBarButtonItem
        
        // Задаем текст заголовка (тоже не опциональное свойство контроллера)
        title = "Трекеры"
        
        // Безопасно включаем большой заголовок у навигейшн бара через "if let"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            
            //запомнить: настройка шрифта заголовка через словарь NSAttributeString!
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 34, weight: .bold),
                .foregroundColor: UIColor.blackTracker
            ]
            navigationBar.largeTitleTextAttributes = attributes
        }
        
        searchController.searchBar.placeholder = "Поиск"
        
        let emptyLogoTextStackView: UIStackView = {
            let emptyLogoTextStackView = UIStackView(arrangedSubviews: [trackersEmptyLogo, titleForTrackersEmptyLogo])
            emptyLogoTextStackView.axis = .vertical
            emptyLogoTextStackView.spacing = 8
            emptyLogoTextStackView.alignment = .center
            emptyLogoTextStackView.translatesAutoresizingMaskIntoConstraints = false
            return emptyLogoTextStackView
        }()
        
        view.addSubview(emptyLogoTextStackView)
        
        NSLayoutConstraint.activate([
            trackersEmptyLogo.widthAnchor.constraint(equalToConstant: 80),
            trackersEmptyLogo.heightAnchor.constraint(equalToConstant: 80),
            emptyLogoTextStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLogoTextStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyLogoTextStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLogoTextStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])
    }
    
    
    
    
}

