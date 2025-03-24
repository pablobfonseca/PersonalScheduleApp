//
//  CounterViewModel.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import Foundation
import UserNotifications

@MainActor
class ReminderViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    
    private let storageKey = "ScheduledReminders"
    
    init() {
        loadReminders()
    }
    
    func addReminder(title: String, time: Date, repeatFrequency: RepeatFrequency) {
        let id = UUID()
        let notificationId = UUID().uuidString

        let reminder = Reminder(id: id, title: title, time: time, notificationId: notificationId, repeatFrequency: repeatFrequency)
        reminders.append(reminder)
        saveReminders()
        scheduleNotification(for: reminder)
    }
    
    func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id}
        saveReminders()
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.notificationId])
    }
    
    func updateReminder(_ reminder: Reminder, newTitle: String, newTime: Date, newFrequency: RepeatFrequency) {
        if let index = reminders.firstIndex(of: reminder) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.notificationId])
            
            let updated = Reminder(
                id: reminder.id,
                title: newTitle,
                time: newTime,
                notificationId: UUID().uuidString,
                repeatFrequency: newFrequency
            )
            reminders[index] = updated
            saveReminders()
            scheduleNotification(for: updated)
        }
    }
    
    private func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminder.title
        content.sound = .default

        var components: DateComponents

        switch reminder.repeatFrequency {
        case .none:
            components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.time)
        case .daily:
            components = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
        case .weekly:
            components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: reminder.time)
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: reminder.repeatFrequency != .none)

        let request = UNNotificationRequest(identifier: reminder.notificationId, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule: \(error)")
            }
        }
    }

    
    private func saveReminders() {
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadReminders() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let _ = try? JSONDecoder().decode([Reminder].self, from: data) else {
            return
        }
    }
}
