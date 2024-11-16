//
//  ActivitiesListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct ActivitiesListView: View {

    @ObservedObject private var activityViewModel = ActivityViewModel()
    @ObservedObject private var destinationViewModel = TouristDestinationViewModel()
    
    @State private var showAddActivitySheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(activityViewModel.activities) { activity in
                    NavigationLink(activity.name) {
                        ActivitiesDetailsView(activity: activity)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let activityToDelete = activityViewModel.activities[index]
                        activityViewModel.deleteActivity(activityToDelete)
                    }
                }
            }
            .navigationTitle("Activities")
            .toolbar {
                Button("Add") {
                    showAddActivitySheet = true
                }
            }
            .sheet(isPresented: $showAddActivitySheet, onDismiss: {
                activityViewModel.fetchActivities()
            }) {
                AddActivityDetailsView(activityViewModel: activityViewModel, touristDestinationViewModel: destinationViewModel)
            }
        }
    }
}

#Preview {
    ActivitiesListView()
}
