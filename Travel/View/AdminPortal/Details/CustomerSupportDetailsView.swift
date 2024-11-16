//
//  CustomerSupportDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct CustomerSupportDetailsView: View {
    let customerSupport: CustomerSupport

    var body: some View {
        Form {
            Section(header: Text("Support Details")) {
                Text("Support ID: \(customerSupport.support_id)")
                Text("User ID: \(customerSupport.user_id)")
                Text("Issue Description: \(customerSupport.issueDescription)")
                Text("Resolution Status: \(customerSupport.resolutionStatus)")
                
                if let resolutionDate = customerSupport.resolutionDate {
                    Text("Resolution Date: \(formattedDate(resolutionDate))")
                } else {
                    Text("Resolution Date: Pending")
                }
            }
        }
        .navigationTitle("Customer Support Details")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    CustomerSupportDetailsView(
        customerSupport: .init(
            support_id: 1,
            user_id: 10,
            issueDescription: "Booking issue with itinerary",
            resolutionStatus: "Pending",
            resolutionDate: nil
        )
    )
}
