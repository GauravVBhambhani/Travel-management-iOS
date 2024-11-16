//
//  AccommodationDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AccommodationDetailsView: View {
    let accommodation: Accommodation

    var body: some View {
        Form {
            Section(header: Text("Accommodation Details")) {
                Text("Name: \(accommodation.name)")
                Text("Type: \(accommodation.type)")
                Text("Price per Night: $\(String(format: "%.2f", accommodation.price_per_night))")
                Text("Availability Status: \(accommodation.availability_status)")
            }
            Section(header: Text("Location")) {
                Text("Street: \(accommodation.street)")
                Text("City: \(accommodation.city)")
                Text("State: \(accommodation.state)")
                Text("Zip Code: \(accommodation.zipcode)")
            }
            Section(header: Text("Rating")) {
                Text("Rating: \(accommodation.rating)/5")
            }
        }
        .navigationTitle("Accommodation Details")
    }
}

#Preview {
    AccommodationDetailsView(
        accommodation: .init(
            accommodation_id: 1,
            destination_id: 1,
            name: "Canyon Lodge",
            street: "123 Canyon Rd",
            city: "Flagstaff",
            state: "AZ",
            zipcode: 86001,
            type: "Hotel",
            price_per_night: 120.00,
            availability_status: "Available",
            rating: 4
        )
    )
}
