//
//  TransportsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct TransportsListView: View {
    
    @ObservedObject private var transportViewModel = TransportViewModel()
    
    @State private var showAddTransportSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(transportViewModel.transports) { transport in
                    NavigationLink(transport.type) {
                        TransportDetailsView(transport: transport)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let transportToDelete = transportViewModel.transports[index]
                        transportViewModel.deleteTransport(transportToDelete)
                    }
                }
            }
            .navigationTitle("Transport Options")
            .toolbar {
                Button("Add") {
                    showAddTransportSheet = true
                }
            }
            .sheet(isPresented: $showAddTransportSheet, onDismiss: {
                transportViewModel.fetchTransports()
            }) {
                AddTransportDetailsView(transportViewModel: transportViewModel)
            }
        }
    }
}

#Preview {
    TransportsListView()
}
