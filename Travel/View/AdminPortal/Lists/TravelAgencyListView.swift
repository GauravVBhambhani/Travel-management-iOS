//
//  TravelAgencyListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct TravelAgencyListView: View {
    
    @ObservedObject private var travelAgencyViewModel = TravelAgencyViewModel()
    
    @State private var showAddTravelAgencySheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(travelAgencyViewModel.travelAgencies.indices, id: \.self) { index in
                    NavigationLink(travelAgencyViewModel.travelAgencies[index].name) {
                        TravelAgencyDetailsView(
                            viewModel: travelAgencyViewModel,
                            travelAgency: $travelAgencyViewModel.travelAgencies[index]
                        )
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let travelAgencyToDelete = travelAgencyViewModel.travelAgencies[index]
                        travelAgencyViewModel.deleteTravelAgency(travelAgencyToDelete)
                    }
                }
            }
            .navigationTitle("Travel Agencies")
            .toolbar {
                Button("Add") {
                    showAddTravelAgencySheet = true
                }
            }
            .sheet(isPresented: $showAddTravelAgencySheet, onDismiss: {
                travelAgencyViewModel.fetchTravelAgencies()
            }) {
                AddTravelAgencyDetailsView(travelAgencyViewModel: travelAgencyViewModel)
            }
        }
    }
}

#Preview {
    TravelAgencyListView()
}
