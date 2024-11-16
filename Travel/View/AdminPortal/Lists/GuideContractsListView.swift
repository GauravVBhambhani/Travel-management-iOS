//
//  GuideContractsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct GuideContractsListView: View {

    @ObservedObject private var guideContractViewModel = GuideContractViewModel()
    @ObservedObject private var activityViewModel = ActivityViewModel() // Add activity view model
    @ObservedObject private var guideViewModel = TourGuidesViewModel() // Add guide view model

    @State private var showAddGuideContractSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(guideContractViewModel.guideContracts) { guideContract in
                    NavigationLink("Activity ID: \(guideContract.activity_id), Guide ID: \(guideContract.guide_id)") {
                        GuideContractDetailsView(guideContract: guideContract)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let guideContractToDelete = guideContractViewModel.guideContracts[index]
                        guideContractViewModel.deleteGuideContract(guideContractToDelete)
                    }
                }
            }
            .navigationTitle("Guide Contracts")
            .toolbar {
                Button("Add") {
                    showAddGuideContractSheet = true
                }
            }
            .sheet(isPresented: $showAddGuideContractSheet, onDismiss: {
                guideContractViewModel.fetchGuideContracts()
            }) {
                AddGuideContractDetailsView(activityViewModel: activityViewModel, guideViewModel: guideViewModel, guideContractViewModel: guideContractViewModel)
            }
        }
    }
}

#Preview {
    GuideContractsListView()
}
