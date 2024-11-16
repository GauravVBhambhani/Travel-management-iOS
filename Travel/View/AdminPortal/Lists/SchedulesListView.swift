//
//  SchedulesListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct SchedulesListView: View {

    @ObservedObject private var scheduleViewModel = ScheduleViewModel()

    @State private var showAddScheduleSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(scheduleViewModel.schedules, id: \.schedule_id) { schedule in
                    NavigationLink(value: schedule.assetID) {
                        ScheduleDetailsView(schedule: schedule)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let scheduleToDelete = scheduleViewModel.schedules[index]
                        scheduleViewModel.deleteSchedule(scheduleToDelete)
                    }
                }
            }
            .navigationTitle("Schedules")
            .toolbar {
                Button("Add") {
                    showAddScheduleSheet = true
                }
            }
            .sheet(isPresented: $showAddScheduleSheet, onDismiss: {
                scheduleViewModel.fetchSchedules()
            }) {
                AddScheduleDetailsView(scheduleViewModel: scheduleViewModel, assetViewModel: AssetViewModel())
            }
        }
    }
}

#Preview {
    SchedulesListView()
}
