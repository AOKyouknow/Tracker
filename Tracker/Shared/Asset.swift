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
    
    
    static let emojiArray: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    static let colorHexes: [String] = [
        "#FD4C49", "#FF881E", "#007BFA", "#6E44FE", "#33CF69", "#E66DD4",
        "#F9D4D4", "#34A7FE", "#46E69D", "#35347C", "#FF674D", "#FF99CC",
        "#F6C48B", "#7994F5", "#832CF1", "#AD56DA", "#8D72E6", "#2FD058"
    ]
}
