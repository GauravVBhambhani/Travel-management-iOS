//
//  AssetDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AssetDetailsView: View {
    let asset: Asset

    var body: some View {
        Form {
            Section(header: Text("Asset Details")) {
                Text("Type: \(asset.type)")
                if let companyName = asset.companyName {
                    Text("Company Name: \(companyName)")
                }
                if let description = asset.description {
                    Text("Description: \(description)")
                }
                Text("Value: $\(asset.value, specifier: "%.2f")")
            }
        }
        .navigationTitle("Asset Details")
    }
}

#Preview {
    AssetDetailsView(
        asset: .init(
            asset_id: 1,
            type: "Bus",
            companyName: "TravelX Transport",
            description: "Tourist bus for group travel.",
            value: 50000.00
        )
    )
}
