//
//  TourGuidesListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct TourGuidesListView: View {
    
    @State private var tourGuideViewModel = TourGuidesViewModel()
    
    @State private var showAddTourGuideSheet = false
    
    var body: some View {
            
        NavigationView {
            List {
                ForEach(tourGuideViewModel.tourGuides) { tourGuide in
                        
                    NavigationLink(tourGuide.firstName + " " + tourGuide.lastName) {
                        
                        TourGuideDetailsView(tourGuide: tourGuide)
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        showAddTourGuideSheet = true
                    }
                }
            }
            .sheet(isPresented: $showAddTourGuideSheet) {
                AddTourGuideDetailsView(viewModel: tourGuideViewModel)
            }
        }
    }
}

//#Preview {
//    TourGuidesListView()
//}
