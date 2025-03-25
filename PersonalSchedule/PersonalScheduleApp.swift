//
//  PersonalScheduleApp.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct PersonalScheduleApp: App {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error)")
            } else {
                print("Notitications granted: \(granted)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: ReminderModel.self)
    }
}
