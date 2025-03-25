//
//  EditReminderView.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import SwiftUI
import SwiftData

struct EditReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State var title: String
    @State var time: Date
    @State var repeatFrequency: RepeatFrequency

    let reminder: ReminderModel

    init(reminder: ReminderModel) {
        self.reminder = reminder
        _title = State(initialValue: reminder.title)
        _time = State(initialValue: reminder.time)
        _repeatFrequency = State(initialValue: reminder.repeatFrequency)
    }

    var body: some View {
        Form {
            Section(header: Text("Edit Reminder")) {
                TextField("Title", text: $title)
                DatePicker("Time", selection: $time, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                Picker("Repeat", selection: $repeatFrequency) {
                    ForEach(RepeatFrequency.allCases) { freq in
                        Text(freq.displayName).tag(freq)
                    }
                }
                .pickerStyle(.segmented)
            }

            Button("Save Changes") {
                saveChanges()
            }
        }
        .navigationTitle("Edit")
    }

    private func saveChanges() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.notificationId])

        reminder.title = title
        reminder.time = time
        reminder.repeatFrequency = repeatFrequency
        reminder.notificationId = UUID().uuidString

        try? context.save()
        scheduleNotification()
        dismiss()
    }

    private func scheduleNotification() {
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
