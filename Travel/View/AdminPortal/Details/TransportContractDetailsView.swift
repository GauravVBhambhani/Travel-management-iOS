//
//  TransportContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct TransportContractDetailsView: View {
    let transportContract: TransportContract

    var body: some View {
        Form {
            Section(header: Text("Transport Contract Details")) {
                Text("Agency ID: \(transportContract.agency_id)")
                Text("Transport ID: \(transportContract.transport_id)")
                Text("Contract Start Date: \(formattedDate(transportContract.contractStartDate))")
                Text("Contract End Date: \(formattedDate(transportContract.contractEndDate))")
            }
        }
        .navigationTitle("Transport Contract Details")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    TransportContractDetailsView(
        transportContract: .init(
            agency_id: 1,
            transport_id: 3,
            contractStartDate: Date(),
            contractEndDate: Calendar.current.date(byAdding: .day, value: 120, to: Date())!
        )
    )
}
