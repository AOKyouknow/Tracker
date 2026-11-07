//
//  SheduleViewController.swift
//  Tracker
//
//  Created by Алик on 04.11.2026.
//

import UIKit

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    
}

protocol SсheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: Set<WeekDay>)
}

class SсheduleViewController: UIViewController {
    
    weak var delegate: SсheduleViewControllerDelegate?
    var selectedDays: Set<WeekDay> = []
    
    private lazy var titleVC: UILabel = {
        let title = UILabel()
        title.text = "Расписание"
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 16
        table.clipsToBounds = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .blackTracker
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 16
        
        var attributes = AttributeContainer()
        attributes.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        configuration.attributedTitle = AttributedString("Готово", attributes: attributes)
        button.addTarget(self, action: #selector(readyDidTapped), for: .touchUpInside)
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [tableView, titleVC, readyButton].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            titleVC.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleVC.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleVC.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        
        
        ])
        
    }
    
    @objc private func readyDidTapped() {
        delegate?.didSelectDays(selectedDays)
        self.dismiss(animated: true)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let dayIndex = sender.tag
        let day = WeekDay.allCases[dayIndex]
        
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
}

extension SсheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentDay = WeekDay.allCases[indexPath.row]
        
        var backConfig = UIBackgroundConfiguration.clear()
        backConfig.backgroundColor = .backgroundGray
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = currentDay.rawValue
        configuration.textProperties.color = .blackTracker
        configuration.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.contentConfiguration = configuration
        cell.backgroundConfiguration = backConfig
        
//        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let switchView = UISwitch()
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchView.onTintColor = .blueTracker
        
        switchView.isOn = selectedDays.contains(currentDay) // проверка
        cell.accessoryView = switchView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension SсheduleViewController: UITableViewDelegate {
    
}
