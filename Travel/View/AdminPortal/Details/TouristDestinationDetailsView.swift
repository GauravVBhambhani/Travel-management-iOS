//
//  DestinationsDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct TouristDestinationDetailsView: View {
    let destination: TouristDestination
    
    var body: some View {
        Form {
            Section(header: Text("General Information")) {
                Text("Name: \(destination.name)")
                Text("Location: \(destination.location)")
                Text("Agency ID: \(destination.agency_id)")
            }
            Section(header: Text("Details")) {
                Text("Popular Attractions: \(destination.popular_attractions)")
                Text("Rating: \(destination.rating)")
                Text("Description: \(destination.description)")
            }
        }
        .navigationTitle("Destination Details")
    }
}

#Preview {
    TouristDestinationDetailsView(
        destination: .init(
            destination_id: 1,
            agency_id: 1,
            name: "Grand Canyon",
            location: "Arizona",
            popular_attractions: "Hiking",
            rating: 5,
            description: "A breathtaking natural wonder."
        )
    )
}
