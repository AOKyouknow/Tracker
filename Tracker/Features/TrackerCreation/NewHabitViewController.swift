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

final class NewHabitViewController: UIViewController, ScheduleViewControllerDelegate {
    
    //MARK: - Properties
    
    weak var delegate: NewHabitViewControllerDelegate?
    
    private var savedDays: Set<WeekDay> = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    //MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
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
        textField.backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
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
        
        button.configuration = configuration
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
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
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false // Отключаем скролл. коллекция лежит внутри общего UIScrollView
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        collection.register(UICollectionViewListCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        collection.register(UICollectionViewListCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerColors")
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        setupUI()
        
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, textField, tableView, emojiCollectionView, colorsCollectionView, buttonStackView]
            .forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorsCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 34),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            //почему такие рамки я использовал????
            
            buttonStackView.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 40),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func goToSheduleViewController() {
        let vc = ScheduleViewController()
        vc.delegate = self
        vc.selectedDays = self.savedDays
        self.present(vc, animated: true)
    }
    
    func didSelectDays(_ days: Set<WeekDay>) {
        self.savedDays = days
        tableView.reloadData()
        updateCreateButtonState()
    }
    
    
    private func updateCreateButtonState() {
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let isFormValid = !trimmedText.isEmpty && !savedDays.isEmpty && selectedEmoji != nil && selectedColor != nil
        
        var configuration = createButton.configuration
        configuration?.baseBackgroundColor = isFormValid ? .blackTracker : .grayTracker
        createButton.configuration = configuration
    }
    
    //MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let title = textField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty,
              !savedDays.isEmpty,
              let selectedEmoji,
              let selectedColor else {
            return
        }
        
        let trackerName = textField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let finalSchedule = savedDays.isEmpty
        ? Set(WeekDay.allCases)
        : savedDays
        
        let newTracker = Tracker(
            id: UUID(),
            title: trackerName.isEmpty ? "Без названия" : trackerName,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: finalSchedule
        )
        
        delegate?.didCreateTracker(newTracker, toCategory: "Домашний уют")
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }
    
}

// MARK: - UITableViewDelegate

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Категория")
        } else {
            print("Расписание")
            goToSheduleViewController()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == 1
        
        if isLastRow {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

// MARK: - UITableViewDataSource

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        cell.backgroundConfiguration = background
        
        var configuration = UIListContentConfiguration.subtitleCell()
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
            } else if
                Set(WeekDay.allCases).isSubset(of: savedDays) {
                configuration.secondaryText = "Каждый день"
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





// MARK: - UICollectionViewDataSource

extension NewHabitViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == emojiCollectionView ? Asset.emojiArray.count : Asset.colorHexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath)
            let emojiItem = Asset.emojiArray[indexPath.item]
            
            var content = UIListContentConfiguration.cell()
            content.text = emojiItem
            content.textProperties.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            content.textProperties.alignment = .center
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .clear
            background.backgroundColor = (emojiItem == selectedEmoji) ? .backgroundGray : .clear
            background.cornerRadius = 16
            cell.backgroundConfiguration = background
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
            
            let color = UIColor(hex: Asset.colorHexes[indexPath.item])
            cell.configure(with: color)
            
            cell.setSelected(color == selectedColor, color: color)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == emojiCollectionView {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? UICollectionViewListCell ?? UICollectionViewListCell()
            
            var configuration = UIListContentConfiguration.plainHeader()
            configuration.text = "Emoji"
            configuration.textProperties.color = .blackTracker
            configuration.textProperties.font = UIFont.systemFont(ofSize: 19, weight: .bold)
            configuration.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 28, bottom: 0, trailing: 0)
            
            view.contentConfiguration = configuration
            
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerColors", for: indexPath) as? UICollectionViewListCell ?? UICollectionViewListCell()
            
            var configuration = UIListContentConfiguration.plainHeader()
            configuration.text = "Цвет"
            configuration.textProperties.color = .blackTracker
            configuration.textProperties.font = UIFont.systemFont(ofSize: 19, weight: .bold)
            configuration.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 28, bottom: 0, trailing: 0)
            
            view.contentConfiguration = configuration
            
            return view
        }
    }
    
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let horizontalInsets:CGFloat = 2 * 29
        let interItemSpacing: CGFloat = 5 * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - horizontalInsets - interItemSpacing
        let place = availableWidth / itemsPerRow
        
        return CGSize(width: place, height: place)
    }
    
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 31, left: 29, bottom: 31, right: 29)
    }
    
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case emojiCollectionView:
            selectedEmoji = Asset.emojiArray[indexPath.item]
            emojiCollectionView.reloadData()
        case colorsCollectionView:
            let hex = Asset.colorHexes[indexPath.item]
            selectedColor = UIColor(hex: hex)
            colorsCollectionView.reloadData()
        default:
            break
        }
        updateCreateButtonState()
    }
    
}
