//
//  EditReminderView.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import SwiftUI

struct EditReminderView: View {
    let reminder: Reminder
    @ObservedObject var viewModel: ReminderViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var time: Date
    @State private var repeatFrequency: RepeatFrequency

    init(reminder: Reminder, viewModel: ReminderViewModel) {
        self.reminder = reminder
        self.viewModel = viewModel
        _title = State(initialValue: reminder.title)
        _time = State(initialValue: reminder.time)
        _repeatFrequency = State(initialValue: reminder.repeatFrequency)
    }

    var body: some View {
        Form {
            Section(header: Text("Edit Reminder")) {
                TextField("Title", text: $title)
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
            }
            
            Picker("Repeat", selection: $repeatFrequency) {
                ForEach(RepeatFrequency.allCases) { freq in
                    Text(freq.displayName).tag(freq)
                }
            }
            .pickerStyle(.segmented)

            Button("Save Changes") {
                viewModel.updateReminder(reminder, newTitle: title, newTime: time, newFrequency: repeatFrequency)
                dismiss()
            }
            .disabled(title.isEmpty)

        }
        .navigationTitle("Edit")
    }
}
