//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Алик on 06.11.2026.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapConnectionButton(in cell: TrackerCollectionViewCell)
}

class TrackerCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackerCellDelegate?
    
    private lazy var cardView: UIView = {
        let card = UIView()
        card.layer.cornerRadius = 16
        card.layer.masksToBounds = true
        
        
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private lazy var smileLabel: UILabel = {
        let smile = UILabel()
        smile.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        smile.text = "😪"
        
        smile.textAlignment = .center
        smile.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        smile.layer.cornerRadius = 12
        smile.layer.masksToBounds = true
        
        smile.translatesAutoresizingMaskIntoConstraints = false
        return smile
    }()
    
    private lazy var titleOfTracker: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Поливать растения"
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountOfDays: UILabel = {
        let amount = UILabel()
        amount.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        amount.text = "0 дней"
        amount.textColor = .blackTracker
        
        amount.translatesAutoresizingMaskIntoConstraints = false
        return amount
    }()
    
    private lazy var markButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
//        configuration.baseBackgroundColor = UIColor(resource: .selection1)
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(resource: .plus)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        configuration.preferredSymbolConfigurationForImage = imageConfig
        
        button.configuration = configuration
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [cardView, smileLabel, titleOfTracker, amountOfDays, markButton].forEach({
            contentView.addSubview($0)
        })
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            // эмодзи внутри карточки
            smileLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            smileLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            smileLabel.widthAnchor.constraint(equalToConstant: 24),
            smileLabel.heightAnchor.constraint(equalToConstant: 24),

            // название внутри карточки
            titleOfTracker.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleOfTracker.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleOfTracker.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            // счётчик под карточкой, по центру кнопки
            amountOfDays.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            amountOfDays.centerYAnchor.constraint(equalTo: markButton.centerYAnchor),
            amountOfDays.trailingAnchor.constraint(lessThanOrEqualTo: markButton.leadingAnchor, constant: -8),

            // кнопка под карточкой, справа, внутри ячейки
            markButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            markButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            markButton.widthAnchor.constraint(equalToConstant: 34),
            markButton.heightAnchor.constraint(equalToConstant: 34)
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func completeButtonTapped() {
        delegate?.didTapConnectionButton(in: self)
    }
    
    func configure(with tracker: Tracker, isCompleted: Bool, completedDaysCount: Int, isEnabled: Bool) {
        titleOfTracker.text = tracker.name
        cardView.backgroundColor = tracker.color
        
        markButton.isEnabled = isEnabled
        markButton.alpha = isEnabled ? 1.0 : 0.5

        var config = markButton.configuration
        config?.image = UIImage(
            systemName: isCompleted ? "checkmark" : "plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        )

        if isCompleted {
            config?.background.backgroundColor = tracker.color.withAlphaComponent(0.3)
            config?.baseForegroundColor = tracker.color
        } else {
            config?.background.backgroundColor = tracker.color
            config?.baseForegroundColor = .white
        }

        markButton.configuration = config
                
        smileLabel.text = tracker.emoji
        
        // Настройка счетчика дней
        amountOfDays.text = "\(completedDaysCount) \(choiceOfdayWord(completedDaysCount))" // Здесь лучше использовать String.localizedStringWithFormat для склонений
        func choiceOfdayWord(_ daysCount: Int) -> String {
            switch daysCount {
            case 1:
                return "день"
            case 2...4:
                return "дня"
            default:
                return "дней"
            }
        }
        // Меняем картинку кнопки: плюс или галочка
        
        
        
        // Меняем прозрачность кнопки, если это будущая дата
        
        
    }
    
//    private func randomColor() -> UIColor {
//        let colorNames = ["selection 1", "selection 2", "selection 3"]
//        guard let randomName = colorNames.randomElement() else {
//            print("не найден цвет по имени")
//            return .clear }
//        return UIColor(named: randomName) ?? .clear
//    }

}
