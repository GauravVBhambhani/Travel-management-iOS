//
//  AddTransportContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AddTransportContractDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var travelAgencyViewModel: TravelAgencyViewModel
    @ObservedObject var transportViewModel: TransportViewModel
    @ObservedObject var transportContractViewModel: TransportContractViewModel

    @State private var selectedAgencyId: Int? = nil
    @State private var selectedTransportId: Int? = nil
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

                Section(header: Text("Select Transport")) {
                    Picker("Transport", selection: $selectedTransportId) {
                        ForEach(transportViewModel.transports, id: \.transport_id) { transport in
                            Text("\(transport.type) - \(transport.company_name)").tag(transport.transport_id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Contract Dates")) {
                    DatePicker("Start Date", selection: $contractStartDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $contractEndDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Transport Contract")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveTransportContract()
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func saveTransportContract() {
        guard let selectedAgencyId = selectedAgencyId else {
            alertMessage = "Please select an agency."
            showingAlert = true
            return
        }

        guard let selectedTransportId = selectedTransportId else {
            alertMessage = "Please select a transport."
            showingAlert = true
            return
        }

        guard contractEndDate >= contractStartDate else {
            alertMessage = "End date cannot be before start date."
            showingAlert = true
            return
        }

        let newContract = TransportContract(
            agency_id: selectedAgencyId,
            transport_id: selectedTransportId,
            contractStartDate: contractStartDate,
            contractEndDate: contractEndDate
        )
        transportContractViewModel.addTransportContract(newContract)
        dismiss()
    }
}

#Preview {
    AddTransportContractDetailsView(
        travelAgencyViewModel: TravelAgencyViewModel(),
        transportViewModel: TransportViewModel(),
        transportContractViewModel: TransportContractViewModel()
    )
}
