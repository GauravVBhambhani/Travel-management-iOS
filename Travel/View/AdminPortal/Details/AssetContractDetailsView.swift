//
//  AssetContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AssetContractDetailsView: View {
    let assetContract: AssetContract

    var body: some View {
        Form {
            Section(header: Text("Asset Contract Details")) {
                Text("Agency ID: \(assetContract.agency_id)")
                Text("Asset ID: \(assetContract.asset_id)")
                Text("Contract Start Date: \(formattedDate(assetContract.contractStartDate))")
                Text("Contract End Date: \(formattedDate(assetContract.contractEndDate))")
            }
        }
        .navigationTitle("Asset Contract Details")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    AssetContractDetailsView(
        assetContract: .init(
            agency_id: 1,
            asset_id: 5,
            contractStartDate: Date(),
            contractEndDate: Calendar.current.date(byAdding: .day, value: 90, to: Date())!
        )
    )
}
