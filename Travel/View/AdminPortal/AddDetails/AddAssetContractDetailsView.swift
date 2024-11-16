//
//  AddAssetContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AddAssetContractDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var travelAgencyViewModel: TravelAgencyViewModel
    @ObservedObject var assetViewModel: AssetViewModel
    @ObservedObject var assetContractViewModel: AssetContractViewModel

    @State private var selectedAgencyId: Int? = nil
    @State private var selectedAssetId: Int? = nil
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

                Section(header: Text("Select Asset")) {
                    Picker("Asset", selection: $selectedAssetId) {
                        ForEach(assetViewModel.assets, id: \.asset_id) { asset in
                            Text("\(asset.type) - \(asset.companyName ?? "Unknown")").tag(asset.asset_id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Contract Dates")) {
                    DatePicker("Start Date", selection: $contractStartDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $contractEndDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Asset Contract")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveAssetContract()
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func saveAssetContract() {
        guard let selectedAgencyId = selectedAgencyId else {
            alertMessage = "Please select an agency."
            showingAlert = true
            return
        }

        guard let selectedAssetId = selectedAssetId else {
            alertMessage = "Please select an asset."
            showingAlert = true
            return
        }

        guard contractEndDate >= contractStartDate else {
            alertMessage = "End date cannot be before start date."
            showingAlert = true
            return
        }

        let newContract = AssetContract(
            agency_id: selectedAgencyId,
            asset_id: selectedAssetId,
            contractStartDate: contractStartDate,
            contractEndDate: contractEndDate
        )
        assetContractViewModel.addAssetContract(newContract)
        dismiss()
    }
}

#Preview {
    AddAssetContractDetailsView(
        travelAgencyViewModel: TravelAgencyViewModel(),
        assetViewModel: AssetViewModel(),
        assetContractViewModel: AssetContractViewModel()
    )
}
