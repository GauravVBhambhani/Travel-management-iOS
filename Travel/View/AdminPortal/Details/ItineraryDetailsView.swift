//
//  ItineraryDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct ItineraryDetailsView: View {
    let itinerary: Itinerary

    var body: some View {
        Form {
            Section(header: Text("Itinerary Information")) {
                Text("Destination: \(itinerary.destination)")
                Text("Start Date: \(itinerary.start_date)")
                Text("End Date: \(itinerary.end_date)")
                Text("Total Cost: $\(itinerary.total_cost, specifier: "%.2f")")
            }
            Section(header: Text("User Details")) {
                Text("User ID: \(itinerary.user_id)")
            }
        }
        .navigationTitle("Itinerary Details")
    }
}
 
