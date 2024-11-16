//
//  AccommodationsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct AccommodationsListView: View {
    
    @ObservedObject private var accommodationViewModel = AccommodationViewModel()
    
    @State private var showAddAccommodationSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accommodationViewModel.accommodations) { accommodation in
                    NavigationLink(accommodation.name) {
                        AccommodationDetailsView(accommodation: accommodation)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let accommodationToDelete = accommodationViewModel.accommodations[index]
                        accommodationViewModel.deleteAccommodation(accommodationToDelete)
                    }
                }
            }
            .navigationTitle("Accommodations")
            .toolbar {
                Button("Add") {
                    showAddAccommodationSheet = true
                }
            }
            .sheet(isPresented: $showAddAccommodationSheet, onDismiss: {
                accommodationViewModel.fetchAccommodations()
            }) {
                AddAccommodationDetailsView(accommodationViewModel: accommodationViewModel)
            }
        }
    }
}

#Preview {
    AccommodationsListView()
}
