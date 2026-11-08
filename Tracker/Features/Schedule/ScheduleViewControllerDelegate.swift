//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Алик on 08.11.2026.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: Set<WeekDay>)
}
