//
//  CreateReminderView.swift
//  PersonalSchedule
//
//  Created by Pablo Fonseca on 25/03/2025.
//

import SwiftUI
import SwiftData
import UserNotifications

struct CreateReminderView: View {
    @Environment(\.modelContext) private var context

    @State private var title = ""
    @State private var time = Date()
    @State private var repeatFrequency: RepeatFrequency = .none

    private var datePickerComponents: DatePickerComponents {
        repeatFrequency == .daily ? [.hourAndMinute] : [.date, .hourAndMinute]
    }

    private var reminderDescription: String {
        let timeString = time.formatted(date: .omitted, time: .shortened)
        switch repeatFrequency {
        case .none:
            return "Reminder set for \(time.formatted(date: .abbreviated, time: .shortened))"
        case .daily:
            return "Repeats daily at \(timeString)"
        case .weekly:
            let weekday = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: time) - 1]
            return "Repeats every \(weekday) at \(timeString)"
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Reminder")) {
                    TextField("E.g. Stretch or Meal 2", text: $title)

                    if repeatFrequency == .none {
                        DatePicker("Time", selection: $time, in: Date()..., displayedComponents: datePickerComponents)
                    } else {
                        DatePicker("Time", selection: $time, displayedComponents: datePickerComponents)
                    }

                    Picker("Repeat", selection: $repeatFrequency) {
                        ForEach(RepeatFrequency.allCases) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(reminderDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section {
                    Button(action: addReminder) {
                        Label("Add Reminder", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(title.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Create")
        }
    }

    private func addReminder() {
        let notificationId = UUID().uuidString
        let reminder = ReminderModel(
            title: title,
            time: time,
            notificationId: notificationId,
            repeatFrequency: repeatFrequency
        )
        context.insert(reminder)
        try? context.save()
        scheduleNotification(for: reminder)

        title = ""
        time = Date()
        repeatFrequency = .none
    }

    private func scheduleNotification(for reminder: ReminderModel) {
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
        UNUserNotificationCenter.current().add(request)
    }
}
