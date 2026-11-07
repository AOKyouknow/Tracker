//
//  TrackersCreationViewController.swift
//  Tracker
//
//  Created by Алик on 01.11.2026.
//

import UIKit

protocol TrackersCreationViewControllerDelegate: AnyObject {
    func createNewHabitVC()
}

final class TrackersCreationViewController: UIViewController {
    
    weak var delegate: TrackersCreationViewControllerDelegate?
    
    private lazy var titleVC: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private lazy var habitButton: UIButton = {
       
       var config = UIButton.Configuration.filled()
       config.baseBackgroundColor = .blackTracker
       config.baseForegroundColor = .white
       config.background.cornerRadius = 16
       let action = UIAction { [weak self] _ in
           guard let self else { return }
           self.delegate?.createNewHabitVC()
           }
       
       var attributeContainer = AttributeContainer()
       attributeContainer.font = UIFont.systemFont(ofSize: 16, weight: .medium)
       
       config.attributedTitle = AttributedString("Привычка", attributes: attributeContainer)
       
       let button = UIButton(configuration: config, primaryAction: action)
       
       button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    private lazy var unregularButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .blackTracker
        config.baseForegroundColor = .white
        config.background.cornerRadius = 16
        config.title = "Нерегулярное событие"
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [habitButton, unregularButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(buttonsStackView)
        view.addSubview(titleVC)
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleVC.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleVC.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
//    private func habitButtonTapped() {
//        let vc = NewHabitViewController()
//        self.present(vc, animated: true)
//    }
}
