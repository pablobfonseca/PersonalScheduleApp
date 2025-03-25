//
//  ContentView.swift
//  personal-schedule
//
//  Created by Pablo Fonseca on 24/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CreateReminderView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle")
                }
            
            ReminderListView()
                .tabItem {
                    Label("Reminders", systemImage: "list.bullet")
                }
        }
    }
}

// Enable preview
#Preview {
    ContentView()
}
