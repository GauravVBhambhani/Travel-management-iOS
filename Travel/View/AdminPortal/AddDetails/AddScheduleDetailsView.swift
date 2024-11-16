//
//  AddScheduleDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AddScheduleDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var scheduleViewModel: ScheduleViewModel
    @ObservedObject var assetViewModel: AssetViewModel
    
    @State private var selectedAsset: Asset? = nil
    @State private var departureTime = Date()
    @State private var arrivalTime = Date()
    @State private var price = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Schedule Details")) {
                    Picker("Asset", selection: $selectedAsset) {
                        Text("Select an Asset").tag(Asset?.none)
                        ForEach(assetViewModel.assets, id: \.self) { asset in
                            Text(asset.type).tag(asset as Asset?)
                        }
                    }
                    
                    DatePicker("Departure Time", selection: $departureTime, displayedComponents: [.date, .hourAndMinute])
                    
                    DatePicker("Arrival Time", selection: $arrivalTime, displayedComponents: [.date, .hourAndMinute])
                        .onChange(of: arrivalTime) { newValue in
                            if newValue < departureTime {
                                arrivalTime = departureTime
                            }
                        }
                    
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Schedule")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSchedule()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func saveSchedule() {
        guard let selectedAsset = selectedAsset else {
            alertMessage = "Please select an asset."
            showingAlert = true
            return
        }
        
        guard arrivalTime >= departureTime else {
            alertMessage = "Arrival time cannot be earlier than departure time."
            showingAlert = true
            return
        }
        
        guard let priceFloat = Float(price), priceFloat >= 0 else {
            alertMessage = "Price must be a positive number."
            showingAlert = true
            return
        }
        
        let newSchedule = Schedule(
            schedule_id: 0, // Assuming ID is auto-generated by the database
            assetID: selectedAsset.id,
            departureTime: departureTime.formatted(date: .numeric, time: .shortened),
            arrivalTime: arrivalTime.formatted(date: .numeric, time: .shortened),
            price: priceFloat
        )
        
        scheduleViewModel.addSchedule(newSchedule)
        dismiss()
    }
}

#Preview {
    AddScheduleDetailsView(
        scheduleViewModel: ScheduleViewModel(),
        assetViewModel: AssetViewModel()
    )
}