//
//  TransportContractsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct TransportContractsListView: View {
    
    @ObservedObject private var transportContractViewModel = TransportContractViewModel()
    
    @State private var showAddTransportContractSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(transportContractViewModel.transportContracts, id: \.transport_id) { transportContract in
                    NavigationLink("Agency ID: \(transportContract.agency_id), Transport ID: \(transportContract.transport_id)") {
                        TransportContractDetailsView(transportContract: transportContract)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let contractToDelete = transportContractViewModel.transportContracts[index]
                        transportContractViewModel.deleteTransportContract(contractToDelete)
                    }
                }
            }
            .navigationTitle("Transport Contracts")
            .toolbar {
                Button("Add") {
                    showAddTransportContractSheet = true
                }
            }
            .sheet(isPresented: $showAddTransportContractSheet, onDismiss: {
                transportContractViewModel.fetchTransportContracts()
            }) {
                AddTransportContractDetailsView(travelAgencyViewModel: TravelAgencyViewModel(), transportViewModel: TransportViewModel(), transportContractViewModel: transportContractViewModel)
            }
        }
    }
}

#Preview {
    TransportContractsListView()
}
