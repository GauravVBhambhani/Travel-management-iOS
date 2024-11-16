//
//  ItineraryListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct ItineraryListView: View {

    @ObservedObject private var itineraryViewModel = ItineraryViewModel()
        
    var body: some View {
        NavigationView {
            List {
                ForEach(itineraryViewModel.itineraries) { itinerary in
                    NavigationLink("Itinerary to \(itinerary.destination)") {
                        ItineraryDetailsView(itinerary: itinerary)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let itineraryToDelete = itineraryViewModel.itineraries[index]
                        itineraryViewModel.deleteItinerary(itineraryToDelete)
                    }
                }
            }
            .navigationTitle("Itineraries")
        }
    }
}

#Preview {
    ItineraryListView()
}
