//
//  ReminderCardView.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import SwiftUI

struct ReminderCardView: View {
    let reminder: ReminderModel
    
    func iconName(for reminder: ReminderModel) -> String {
        if reminder.title.lowercased().contains("stretch") {
            return "figure.cooldown"
        } else if reminder.title.lowercased().contains("workout") {
            return "dumbbell"
        } else if reminder.title.lowercased().contains("meal") {
            return "fork.knife"
        } else if reminder.title.lowercased().contains("study") {
            return "book"
        } else {
            return "bell"
        }
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label {
                Text(reminder.title)
                    .font(.headline)
            } icon: {
                Image(systemName: iconName(for: reminder))
                    .foregroundColor(.blue)
            }

            Text(reminder.time.formatted(date: .abbreviated, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.secondary)

            if reminder.repeatFrequency != .none {
                Text(reminder.repeatFrequency.displayName)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .shadow(radius: 1)
        )
        .listRowInsets(EdgeInsets())
        .padding(.horizontal)
    }
}
