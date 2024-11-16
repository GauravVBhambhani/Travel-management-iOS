//
//  ActivitiesDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct ActivitiesDetailsView: View {
    let activity: Activity

    var body: some View {
        Form {
            Section(header: Text("Activity Details")) {
                Text("Name: \(activity.name)")
                Text("Description: \(activity.description)")
                Text("Location: \(activity.location)")
                Text("Duration: \(activity.duration) hours")
                Text("Price: $\(activity.price)")
            }
        }
        .navigationTitle("Activity Details")
    }
}

#Preview {
    ActivitiesDetailsView(
        activity: .init(
            activity_id: 1,
            destination_id: 10,
            name: "Scenic Hike",
            description: "A beautiful guided hike through the mountains.",
            location: "Mountain Trail",
            duration: "5",
            price: "100.00"
        )
    )
}
