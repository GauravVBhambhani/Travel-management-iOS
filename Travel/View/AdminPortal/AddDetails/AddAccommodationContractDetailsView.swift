//
//  AddAccommodationContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AddAccommodationContractDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var travelAgencyViewModel: TravelAgencyViewModel
    @ObservedObject var accommodationViewModel: AccommodationViewModel
    @ObservedObject var accommodationContractViewModel: AccommodationContractViewModel

    @State private var selectedAgencyId: Int? = nil
    @State private var selectedAccommodationId: Int? = nil
    @State private var contractStartDate: Date = Date()
    @State private var contractEndDate: Date = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Agency")) {
                    Picker("Agency", selection: $selectedAgencyId) {
                        ForEach(travelAgencyViewModel.travelAgencies, id: \.agency_id) { agency in
                            Text(agency.name).tag(agency.agency_id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Select Accommodation")) {
                    Picker("Accommodation", selection: $selectedAccommodationId) {
                        ForEach(accommodationViewModel.accommodations, id: \.accommodation_id) { accommodation in
                            Text(accommodation.name).tag(accommodation.accommodation_id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Contract Dates")) {
                    DatePicker("Start Date", selection: $contractStartDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $contractEndDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Accommodation Contract")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveAccommodationContract()
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func saveAccommodationContract() {
        guard let selectedAgencyId = selectedAgencyId else {
            alertMessage = "Please select an agency."
            showingAlert = true
            return
        }

        guard let selectedAccommodationId = selectedAccommodationId else {
            alertMessage = "Please select an accommodation."
            showingAlert = true
            return
        }

        guard contractEndDate >= contractStartDate else {
            alertMessage = "End date cannot be before start date."
            showingAlert = true
            return
        }

        let newContract = AccommodationContract(
            agency_id: selectedAgencyId,
            accommodation_id: selectedAccommodationId,
            contractStartDate: contractStartDate,
            contractEndDate: contractEndDate
        )
        accommodationContractViewModel.addAccommodationContract(newContract)
        dismiss()
    }
}

#Preview {
    AddAccommodationContractDetailsView(
        travelAgencyViewModel: TravelAgencyViewModel(),
        accommodationViewModel: AccommodationViewModel(),
        accommodationContractViewModel: AccommodationContractViewModel()
    )
}
