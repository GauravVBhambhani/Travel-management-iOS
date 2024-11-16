//
//  DestinationsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct TouristDestinationsListView: View {
    
    @ObservedObject private var destinationViewModel = TouristDestinationViewModel()
    @ObservedObject private var agencyViewModel = TravelAgencyViewModel()
    
    @State private var showAddDestinationSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(destinationViewModel.destinations) { destination in
                    NavigationLink(destination.name) {
                        TouristDestinationDetailsView(destination: destination)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let destinationToDelete = destinationViewModel.destinations[index]
                        destinationViewModel.deleteDestination(destinationToDelete)
                    }
                }
            }
            .navigationTitle("Tourist Destinations")
            .toolbar {
                Button("Add") {
                    showAddDestinationSheet = true
                }
            }
            .sheet(isPresented: $showAddDestinationSheet, onDismiss: {
                destinationViewModel.fetchDestinations()
            }) {
                AddTouristDestinationDetailsView(viewModel: destinationViewModel, agencyViewModel: agencyViewModel)
            }
        }
    }
}

#Preview {
    TouristDestinationsListView()
}
