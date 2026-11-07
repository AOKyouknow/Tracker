//
//  newHabitViewController.swift
//  Tracker
//
//  Created by Алик on 01.11.2026.
//

import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, toCategory title: String)
}

class NewHabitViewController: UIViewController, SсheduleViewControllerDelegate {
    
    weak var delegate: NewHabitViewControllerDelegate?
    
    private var savedDays: Set<WeekDay> = []
    
    private lazy var titleVC: UILabel = {
        let title = UILabel()
        title.text = "Новая привычка"
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.borderStyle = .none
        textField.backgroundColor = .backgroundGray
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .backgroundGray
        table.layer.cornerRadius = 16
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        var attributeContainer = AttributeContainer()
        attributeContainer.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        configuration.attributedTitle = AttributedString("Отмена", attributes: attributeContainer)
        configuration.baseForegroundColor = .redForCancelButton
        configuration.background.cornerRadius = 16
        configuration.background.strokeColor = .redForCancelButton
        configuration.background.strokeWidth = 1.0
        
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .grayTracker
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 16
        var attributeContainer = AttributeContainer()
        attributeContainer.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        configuration.attributedTitle = AttributedString("Создать", attributes: attributeContainer)
        
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.spacing = 8
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        setupUI()
        
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        [titleVC, textField, tableView, buttonStackView]
            .forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            titleVC.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleVC.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: titleVC.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
//        let trackerName = textField.text ?? "Без названия"
//        
//        // 2. Создаем новый объект трекера (id генерируем через случайное число, раз у вас UInt)
//        let newTracker = Tracker(
//            id: UInt(bitPattern: UUID().hashValue), // Безопасно делаем уникальный UInt из UUID
//            name: trackerName,
//            color: UIColor(resource: .selection1),
//            emoji: "🌺",            // Здесь подставите выбранный эмодзи
//            schedule: savedDays     // Передаем те самые дни, которые нащелкали во втором экране!
//        )
//        
//        // 3. Отправляем трекер «по проводу» на главный экран в категорию «Важное»
//        delegate?.didCreateTracker(newTracker, toCategory: "Важное")
//        
//        // 4. Закрываем текущий экран создания привычки
//        self.dismiss(animated: true)
        
        let trackerName = textField.text?
               .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

           let finalSchedule = savedDays.isEmpty
               ? Set(WeekDay.allCases)
               : savedDays

           let newTracker = Tracker(
               id: UInt(bitPattern: UUID().hashValue),
               name: trackerName.isEmpty ? "Без названия" : trackerName,
               color: UIColor(resource: .greenTracker),
               emoji: "😪",
               schedule: finalSchedule
           )

           delegate?.didCreateTracker(newTracker, toCategory: "Домашний уют")
           dismiss(animated: true)

    }
    
    private func goToSheduleViewController() {
        let vc = SсheduleViewController()
        vc.delegate = self
        vc.selectedDays = self.savedDays
        self.present(vc, animated: true)
    }
    
    func didSelectDays(_ days: Set<WeekDay>) {
        self.savedDays = days
        tableView.reloadData()
    }
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Категория")
        } else {
            print("Расписание")
            goToSheduleViewController()
        }
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .backgroundGray
        cell.backgroundConfiguration = background
        
        var configuration = UIListContentConfiguration.subtitleCell()
        //var configuration = cell.defaultContentConfiguration()
        configuration.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        configuration.textProperties.color = .blackTracker
        
        configuration.secondaryTextProperties.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        configuration.secondaryTextProperties.color = .grayTracker
        
        configuration.imageToTextPadding = 2
        
        if indexPath.row == 0 {
            configuration.text = "Категория"
            configuration.secondaryText = "Важное"
        } else {
            configuration.text = "Расписание"
            if savedDays.isEmpty {
                configuration.secondaryText = nil
            } else {
                let shortNames = WeekDay.allCases
                    .filter({savedDays.contains($0)})
                    .map({$0.shortName})
                configuration.secondaryText = shortNames.joined(separator: ", ")
            }
        }
        
        cell.contentConfiguration = configuration
        
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
