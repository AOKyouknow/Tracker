//
//  ColorCell.swift
//  Tracker
//
//  Created by Алик on 13.11.2026.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
//            colorView.heightAnchor.constraint(equalToConstant: 40),
//            colorView.widthAnchor.constraint(equalToConstant: 40)
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
            colorView.backgroundColor = color
        }
    
    func setSelected(_ isSelected: Bool, color: UIColor) {
            if isSelected {
                contentView.layer.borderWidth = 3
                contentView.layer.cornerRadius = 8
                contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            } else {
                contentView.layer.borderWidth = 0
                contentView.layer.borderColor = nil
            }
        }
}
