//
//  TourGuidesListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct TourGuidesListView: View {
    
    @ObservedObject private var tourGuideViewModel = TourGuidesViewModel()
    
    @State private var showAddTourGuideSheet = false
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(tourGuideViewModel.tourGuides.indices, id: \.self) { index in
                    NavigationLink(tourGuideViewModel.tourGuides[index].firstName + " " + tourGuideViewModel.tourGuides[index].lastName) {
                        TourGuideDetailsView(viewModel: tourGuideViewModel, tourGuide: $tourGuideViewModel.tourGuides[index])
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let tourGuideToDelete = tourGuideViewModel.tourGuides[index]
                        tourGuideViewModel.deleteTourGuide(tourGuideToDelete)
                    }
                }
            }
            .navigationTitle("Tour Guides")
            .toolbar {
                Button("Add") {
                    showAddTourGuideSheet = true
                }
            }
            .sheet(isPresented: $showAddTourGuideSheet, onDismiss: {
                tourGuideViewModel.fetchTourGuides()
            }) {
                AddTourGuideDetailsView(viewModel: tourGuideViewModel)
            }
        }
    }
}

#Preview {
    TourGuidesListView()
}
