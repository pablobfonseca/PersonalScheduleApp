//
//  Reminder.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import Foundation

enum RepeatFrequency: String, Codable, CaseIterable, Identifiable {
    case none
    case daily
    case weekly

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .none: "Once"
        case .daily: "Daily"
        case .weekly: "Weekly"
        }
    }
}

struct Reminder: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var time: Date
    var notificationId: String
    var repeatFrequency: RepeatFrequency
}
