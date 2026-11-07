//
//  TrackerSectionHeaderView.swift
//  Tracker
//
//  Created by Алик on 07.11.2026.
//

import UIKit

final class TrackerSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "TrackerSectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .blackTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var topConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        topConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, topPadding: CGFloat) {
        titleLabel.text = title
        topConstraint.constant = topPadding
    }
}
