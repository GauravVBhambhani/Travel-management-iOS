//
//  AddGuideContractDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AddGuideContractDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var guideViewModel: TourGuidesViewModel
    @ObservedObject var guideContractViewModel: GuideContractViewModel

    @State private var selectedActivityId: Int? = nil
    @State private var selectedGuideId: Int? = nil
    @State private var contractStartDate: Date = Date()
    @State private var contractEndDate: Date = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Activity")) {
                    Picker("Activity", selection: $selectedActivityId) {
                        ForEach(activityViewModel.activities, id: \.activity_id) { activity in
                            Text(activity.name).tag(activity.activity_id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Select Guide")) {
                    Picker("Tour Guide", selection: $selectedGuideId) {
                        ForEach(guideViewModel.tourGuides, id: \.tourguide_id) { guide in
                            Text("\(guide.firstName) \(guide.lastName)").tag(guide.tourguide_id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Contract Dates")) {
                    DatePicker("Start Date", selection: $contractStartDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $contractEndDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Guide Contract")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveGuideContract()
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func saveGuideContract() {
        guard let selectedActivityId = selectedActivityId else {
            alertMessage = "Please select an activity."
            showingAlert = true
            return
        }
        
        guard let selectedGuideId = selectedGuideId else {
            alertMessage = "Please select a tour guide."
            showingAlert = true
            return
        }
        
        guard contractEndDate >= contractStartDate else {
            alertMessage = "End date cannot be before start date."
            showingAlert = true
            return
        }

        let newContract = GuideContract(activity_id: selectedActivityId, guide_id: selectedGuideId, ContractStartDate: contractStartDate, ContractEndDate: contractEndDate)
        guideContractViewModel.addGuideContract(newContract)
        dismiss()
    }
}

//#Preview {
//    AddGuideContractDetailsView(activityViewModel: ActivityViewModel(), guideViewModel: TourGuidesViewModel(), guideContractViewModel: GuideContractViewModel())
//}
