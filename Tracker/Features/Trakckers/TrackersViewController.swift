//
//  ViewController.swift
//  Tracker
//
//  Created by Алик on 22.10.2026.
//

import UIKit

final class TrackersViewController: UIViewController, TrackerCellDelegate, TrackersCreationViewControllerDelegate {
    
    // MARK: - Properties
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []
    var currentDate: Date = Date()
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    // MARK: - UI Elements
    
    private lazy var navBarItem: UIBarButtonItem = {
        let navBarItem = UIBarButtonItem()
        navBarItem.image = UIImage(resource: .plus)
        navBarItem.tintColor = .blackTracker
        navBarItem.target = self
        navBarItem.action = #selector(plusButtonTapped)
        return navBarItem
    }()
    
    private var titleOfTab: UILabel = {
        let titleOfTab = UILabel()
        titleOfTab.text = "Трекеры"
        titleOfTab.font = UIFont.systemFont(ofSize: CGFloat(Asset.Font.sizeOfTitle), weight: .bold)
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
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 9
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        
        collectionView.register(
            TrackerSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var emptyLogoTextStackView: UIStackView = {
        let emptyLogoTextStackView = UIStackView(arrangedSubviews: [trackersEmptyLogo, titleForTrackersEmptyLogo])
        emptyLogoTextStackView.axis = .vertical
        emptyLogoTextStackView.spacing = 8
        emptyLogoTextStackView.alignment = .center
        emptyLogoTextStackView.translatesAutoresizingMaskIntoConstraints = false
        return emptyLogoTextStackView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        
        loadInitialData()
    }
    
    // MARK: - Private Methods
    
    private func loadInitialData() {
        categories = trackerCategoryStore.categories
        completedTrackers = Set((try? trackerRecordStore.fetchRecords()) ?? [])
        filterTrackersByDate()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = navBarItem
        navigationItem.searchController = searchController
        view.backgroundColor = .white
        
        let datePickerBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerBarButtonItem
        
        title = "Трекеры"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 34, weight: .bold),
                .foregroundColor: UIColor.blackTracker
            ]
            navigationBar.largeTitleTextAttributes = attributes
        }
        
        searchController.searchBar.placeholder = "Поиск"
        
        view.addSubview(emptyLogoTextStackView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            trackersEmptyLogo.widthAnchor.constraint(equalToConstant: 80),
            trackersEmptyLogo.heightAnchor.constraint(equalToConstant: 80),
            emptyLogoTextStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLogoTextStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyLogoTextStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLogoTextStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func addTracker(_ tracker: Tracker, titleOfCategory: String) {
        do {
            var categoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(with: titleOfCategory)
            
            if categoryCoreData == nil {
                try trackerCategoryStore.addNewCategory(title: titleOfCategory)
                categoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(with: titleOfCategory)
            }
            
            guard let category = categoryCoreData else { return }
            try trackerStore.addNewTracker(tracker, to: category)
        } catch {
            print("Ошибка при сохранении трекера: \(error)")
        }
    }
    
    
    private func trackerCompletion(id: UUID) {
        let dateOnly = Calendar.current.startOfDay(for: currentDate)
        let record = TrackerRecord(trackerId: id, date: dateOnly)
        
        do {
            if completedTrackers.contains(where: { $0.trackerId == id && Calendar.current.isDate($0.date, inSameDayAs: dateOnly) }) {
                try trackerRecordStore.deleteRecord(record)
            } else {
                try trackerRecordStore.addRecord(record)
            }
        } catch {
            print("Ошибка при обновлении выполнения трекера: \(error)")
        }
    }
    
    
    private func filterTrackersByDate() {
        let calendar = Calendar.current
        let weekDayNumber = calendar.component(.weekday, from: currentDate)
        guard let currentWeekDay = getWeekDay(from: weekDayNumber) else {
            return
        }
        
        visibleCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.schedule.contains(currentWeekDay)
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    func getWeekDay(from systemDayNumber: Int) -> WeekDay? {
        switch systemDayNumber {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
    
    func didTapConnectionButton(in cell: TrackerCollectionViewCell) {
        if Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedDescending {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        trackerCompletion(id: tracker.id)
    }
    
    private func reloadPlaceholder() {
        if visibleCategories.isEmpty {
            emptyLogoTextStackView.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyLogoTextStackView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    func createNewHabitVC() {
        if let presented = presentedViewController {
            presented.dismiss(animated: true) { [weak self] in
                self?.presentNewHabit()
            }
        } else {
            presentNewHabit()
        }
    }
    
    private func presentNewHabit() {
        let vc = NewHabitViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    // MARK: - Actions
    
    @objc private func plusButtonTapped() {
        createNewHabitVC()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        self.currentDate = sender.date
        filterTrackersByDate()
    }
}

// MARK: - UICollectionViewDeleagateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - 16 - 16 - 9
        let cellWidth = availableWidth / 2
        
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let isLastSection = section == visibleCategories.count - 1
        return UIEdgeInsets(top: 0, left: 16, bottom: isLastSection ? 16 : 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let topPadding: CGFloat = section == 0 ? 34 : 24
        let labelHeight: CGFloat = 23
        let bottomPadding: CGFloat = 12
        return CGSize(
            width: collectionView.bounds.width,
            height: topPadding + labelHeight + bottomPadding
        )
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        
        let dateWithoutTime = Calendar.current.startOfDay(for: currentDate)
        let isCompleted = completedTrackers.contains(where: {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: dateWithoutTime)
        })
        let completedDaysCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        
        let isTodayOrPast = Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) != .orderedDescending
        
        cell.configure(with: tracker, isCompleted: isCompleted, completedDaysCount: completedDaysCount, isEnabled: isTodayOrPast)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier,
                for: indexPath
              ) as? TrackerSectionHeaderView else {
            return UICollectionReusableView()
        }
        
        header.configure(
            title: visibleCategories[indexPath.section].title,
            topPadding: indexPath.section == 0 ? 34 : 24
        )
        return header
    }
    
}

// MARK: - NewHabitViewControllerDelegate

extension TrackersViewController: NewHabitViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, toCategory title: String) {
        
        addTracker(tracker, titleOfCategory: title)
        filterTrackersByDate()
    }
}

// MARK: - Store Delegates

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func categoryStoreDidUpdate() {
        categories = trackerCategoryStore.categories
        filterTrackersByDate()
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    func trackerStoreDidUpdate() {
        categories = trackerCategoryStore.categories
        filterTrackersByDate()
    }
    
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords() {
        completedTrackers = Set((try? trackerRecordStore.fetchRecords()) ?? [])
        collectionView.reloadData()
    }
}
