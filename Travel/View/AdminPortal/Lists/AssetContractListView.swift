//
//  AssetContractListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AssetContractListView: View {
    
    @ObservedObject private var assetContractViewModel = AssetContractViewModel()
    
    @State private var showAddAssetContractSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(assetContractViewModel.assetContracts, id: \.asset_id) { assetContract in
                    NavigationLink("Agency ID: \(assetContract.agency_id), Asset ID: \(assetContract.asset_id)") {
                        AssetContractDetailsView(assetContract: assetContract)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let contractToDelete = assetContractViewModel.assetContracts[index]
                        assetContractViewModel.deleteAssetContract(contractToDelete)
                    }
                }
            }
            .navigationTitle("Asset Contracts")
            .toolbar {
                Button("Add") {
                    showAddAssetContractSheet = true
                }
            }
            .sheet(isPresented: $showAddAssetContractSheet, onDismiss: {
                assetContractViewModel.fetchAssetContracts()
            }) {
                AddAssetContractDetailsView(travelAgencyViewModel: TravelAgencyViewModel(), assetViewModel: AssetViewModel(), assetContractViewModel: assetContractViewModel)
            }
        }
    }
}

#Preview {
    AssetContractListView()
}
