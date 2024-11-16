//
//  AccommodationsContractsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct AccommodationsContractsListView: View {
    
    @ObservedObject private var accommodationContractViewModel = AccommodationContractViewModel()
    
    @State private var showAddAccommodationContractSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(accommodationContractViewModel.accommodationContracts, id: \.accommodation_id) { accommodationContract in
                    NavigationLink("Agency ID: \(accommodationContract.agency_id), Accommodation ID: \(accommodationContract.accommodation_id)") {
                        AccommodationContractDetailsView(accommodationContract: accommodationContract)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let contractToDelete = accommodationContractViewModel.accommodationContracts[index]
                        accommodationContractViewModel.deleteAccommodationContract(contractToDelete)
                    }
                }
            }
            .navigationTitle("Accommodation Contracts")
            .toolbar {
                Button("Add") {
                    showAddAccommodationContractSheet = true
                }
            }
            .sheet(isPresented: $showAddAccommodationContractSheet, onDismiss: {
                accommodationContractViewModel.fetchAccommodationContracts()
            }) {
                AddAccommodationContractDetailsView(travelAgencyViewModel: TravelAgencyViewModel(), accommodationViewModel: AccommodationViewModel(), accommodationContractViewModel: accommodationContractViewModel)
            }
        }
    }
}

#Preview {
    AccommodationsContractsListView()
}
