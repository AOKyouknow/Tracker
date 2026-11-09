//
//  SheduleViewController.swift
//  Tracker
//
//  Created by Алик on 04.11.2026.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ScheduleViewControllerDelegate?
    var selectedDays: Set<WeekDay> = []
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        [tableView, titleLabel, readyButton].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    // MARK: - Actions
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

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentDay = WeekDay.allCases[indexPath.row]
        
        var backConfig = UIBackgroundConfiguration.clear()
        backConfig.backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = currentDay.rawValue
        configuration.textProperties.color = .blackTracker
        configuration.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.contentConfiguration = configuration
        cell.backgroundConfiguration = backConfig
        
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

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == WeekDay.allCases.count - 1
        
        if isLastRow {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }

}
