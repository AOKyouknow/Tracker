//
//  Tracker.swift
//  Tracker
//
//  Created by Алик on 01.11.2026.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>
}
