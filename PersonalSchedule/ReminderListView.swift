//
//  ReminderListView.swift
//  PersonalSchedule
//
//  Created by Pablo Fonseca on 25/03/2025.
//

import SwiftUI
import SwiftData
import UserNotifications

enum ReminderFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case today = "Today"
    
    var id: String { rawValue }
}

struct ReminderListView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedFilter: ReminderFilter = .all
    @Query(sort: \ReminderModel.time) private var reminders: [ReminderModel]
    
    private var filteredReminders: [ReminderModel] {
        switch selectedFilter {
        case .all:
            return reminders
        case .today:
            return reminders.filter { Calendar.current.isDateInToday($0.time)}
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(ReminderFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                List {
                    ForEach(filteredReminders) { reminder in
                        NavigationLink(destination: EditReminderView(reminder: reminder)) {
                            ReminderCardView(reminder: reminder)
                        }
                    }
                    .onDelete(perform: deleteReminder)
                }
                .listStyle(.plain)
            }
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
