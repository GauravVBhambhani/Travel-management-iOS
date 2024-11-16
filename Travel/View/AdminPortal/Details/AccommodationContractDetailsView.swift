//
//  AccommodationContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AccommodationContractDetailsView: View {
    let accommodationContract: AccommodationContract

    var body: some View {
        Form {
            Section(header: Text("Accommodation Contract Details")) {
                Text("Agency ID: \(accommodationContract.agency_id)")
                Text("Accommodation ID: \(accommodationContract.accommodation_id)")
                Text("Contract Start Date: \(formattedDate(accommodationContract.contractStartDate))")
                Text("Contract End Date: \(formattedDate(accommodationContract.contractEndDate))")
            }
        }
        .navigationTitle("Accommodation Contract Details")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    AccommodationContractDetailsView(
        accommodationContract: .init(
            agency_id: 1,
            accommodation_id: 5,
            contractStartDate: Date(),
            contractEndDate: Calendar.current.date(byAdding: .day, value: 90, to: Date())!
        )
    )
}
