//
//  SavedRemindersView.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import SwiftUI
import SwiftData
import UserNotifications

struct SavedRemindersView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ReminderModel.time) private var reminders: [ReminderModel]

    var body: some View {
        NavigationView {
            List {
                ForEach(reminders) { reminder in
                    NavigationLink(destination: EditReminderView(reminder: reminder)) {
                        ReminderCardView(reminder: reminder)
                    }
                }
                .onDelete(perform: deleteReminder)
            }
            .listStyle(.plain)
            .navigationTitle("My Reminders")
        }
    }

    private func deleteReminder(at offsets: IndexSet) {
        for index in offsets {
            let reminder = reminders[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.notificationId])
            context.delete(reminder)
        }
        try? context.save()
    }
}
