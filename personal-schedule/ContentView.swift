//
//  ContentView.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ReminderViewModel()
    @State private var newTitle = ""
    @State private var newTime = Date()
    @State private var repeatFrequency: RepeatFrequency = .none

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Reminder (e.g. Meal 2)", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                DatePicker("Select time", selection: $newTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                
                Picker("Repeat", selection: $repeatFrequency) {
                    ForEach(RepeatFrequency.allCases) { freq in
                        Text(freq.displayName).tag(freq)
                    }
                }
                .pickerStyle(.segmented)


                Button("Add Reminder") {
                    viewModel.addReminder(title: newTitle, time: newTime, repeatFrequency: repeatFrequency)
                    newTitle = ""
                    newTime = Date()
                    repeatFrequency = .none
                }
                .disabled(newTitle.isEmpty)
                .buttonStyle(.borderedProminent)

                List {
                    ForEach(viewModel.reminders) { reminder in
                        NavigationLink(destination: EditReminderView(reminder: reminder, viewModel: viewModel)) {
                            VStack(alignment: .leading) {
                                Text(reminder.title).bold()
                                Text(reminder.time.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(reminder.repeatFrequency.displayName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.map { viewModel.reminders[$0] }.forEach(viewModel.deleteReminder)
                    }
                }
            }
            .padding()
            .navigationTitle("My Schedule")
        }
    }
}


// Enable preview
#Preview {
    ContentView()
}
