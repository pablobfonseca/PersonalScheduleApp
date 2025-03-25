//
//  ReminderModel.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import Foundation
import SwiftData

@Model
class ReminderModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var time: Date
    var notificationId: String
    var repeatFrequencyRaw: String

    var repeatFrequency: RepeatFrequency {
        get { RepeatFrequency(rawValue: repeatFrequencyRaw) ?? .none }
        set { repeatFrequencyRaw = newValue.rawValue }
    }

    init(id: UUID = UUID(), title: String, time: Date, notificationId: String, repeatFrequency: RepeatFrequency) {
        self.id = id
        self.title = title
        self.time = time
        self.notificationId = notificationId
        self.repeatFrequencyRaw = repeatFrequency.rawValue
    }
}
