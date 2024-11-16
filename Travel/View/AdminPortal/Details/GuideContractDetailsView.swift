//
//  GuideContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct GuideContractDetailsView: View {
    let guideContract: GuideContract

    var body: some View {
        Form {
            Section(header: Text("Guide Contract Details")) {
                Text("Activity ID: \(guideContract.activity_id)")
                Text("Guide ID: \(guideContract.guide_id)")
                Text("Contract Start Date: \(formattedDate(guideContract.ContractStartDate))")
                Text("Contract End Date: \(formattedDate(guideContract.ContractEndDate))")
            }
        }
        .navigationTitle("Guide Contract Details")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    GuideContractDetailsView(
        guideContract: .init(
            activity_id: 1,
            guide_id: 2,
            ContractStartDate: Date(),
            ContractEndDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        )
    )
}
