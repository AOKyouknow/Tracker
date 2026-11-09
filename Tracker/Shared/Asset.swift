//
//  Constants.swift
//  Tracker
//
//  Created by Алик on 25.10.2026.
//

import UIKit

enum Asset {
    enum Font {
        static let screenTitle = UIFont.systemFont(
            ofSize: 34,
            weight: .bold
        )
        static let fontSFProBold = "SFPro-Bold"
        static let sizeOfTitle = 34
    }

    enum Color {
        static let background = UIColor(resource: .backgroundGray)
    }

    enum Image {
        static let plus = UIImage(resource: .plus)
    }

}
