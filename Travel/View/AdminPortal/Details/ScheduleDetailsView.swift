//
//  ScheduleDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct ScheduleDetailsView: View {
    let schedule: Schedule

    var body: some View {
        Form {
            Section(header: Text("Schedule Details")) {
                Text("Asset ID: \(schedule.assetID)")
                Text("Departure Time: \(schedule.departureTime)")
                Text("Arrival Time: \(schedule.arrivalTime)")
                Text("Price: $\(schedule.price, specifier: "%.2f")")
            }
        }
        .navigationTitle("Schedule Details")
    }
}

#Preview {
    ScheduleDetailsView(
        schedule: .init(
            schedule_id: 1,
            assetID: 101,
            departureTime: "2024-12-01 08:00 AM",
            arrivalTime: "2024-12-01 12:00 PM",
            price: 150.00
        )
    )
}
