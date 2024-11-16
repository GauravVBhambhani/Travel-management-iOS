//
//  TransportDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct TransportDetailsView: View {
    let transport: Transport

    var body: some View {
        Form {
            Section(header: Text("Transport Details")) {
                Text("Type: \(transport.type)")
                Text("Company: \(transport.company_name)")
            }
            Section(header: Text("Schedule Information")) {
                Text("Departure Time: \(transport.departure_time)")
                Text("Arrival Time: \(transport.arrival_time)")
            }
            Section(header: Text("Price")) {
                Text("Price: $\(String(format: "%.2f", transport.price))")
            }
        }
        .navigationTitle("Transport Details")
    }
}

#Preview {
    TransportDetailsView(
        transport: .init(
            transport_id: 1,
            type: "Bus",
            company_name: "TravelX Transport",
            departure_time: "2024-01-10 08:00:00",
            arrival_time: "2024-01-10 12:00:00",
            price: 100.00
        )
    )
}
