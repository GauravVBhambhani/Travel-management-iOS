//
//  AddTravelAgencyDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/5/24.
//

import SwiftUI

struct AddTravelAgencyDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var travelAgencyViewModel: TravelAgencyViewModel
    
    var existingAgency: TravelAgency?
    
    @State private var name = ""
    @State private var location = ""
    @State private var contact_info = ""
    @State private var rating = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Agency Information")) {
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
                    TextField("Contact Info (10 digits)", text: $contact_info)
                        .keyboardType(.numberPad)
                    TextField("Rating (1-5)", text: $rating)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle(existingAgency == nil ? "Add Travel Agency" : "Update Travel Agency")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(existingAgency == nil ? "Save" : "Update") {
                        existingAgency == nil ? saveTravelAgency() : updateTravelAgency()
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
            .onAppear {
                if let agency = existingAgency {
                    name = agency.name
                    location = agency.location
                    contact_info = agency.contact_info
                    rating = String(agency.rating)
                }
            }
        }
    }
    
    private func saveTravelAgency() {
        guard validateInputs() else {
            return
        }
        
        let newTravelAgency = TravelAgency(
            agency_id: 0, // Assuming ID is auto-generated by the database
            name: name,
            location: location,
            contact_info: contact_info,
            rating: Int(rating) ?? 0
        )
        
        travelAgencyViewModel.addTravelAgency(newTravelAgency)
        dismiss()
    }
    
    private func updateTravelAgency() {
        guard let existingAgency = existingAgency else {
            return
        }
        
        guard validateInputs() else {
            return
        }
        
        let updatedTravelAgency = TravelAgency(
            agency_id: existingAgency.agency_id,
            name: name,
            location: location,
            contact_info: contact_info,
            rating: Int(rating) ?? 0
        )
        
        travelAgencyViewModel.updateTravelAgency(updatedTravelAgency)
        dismiss()
    }
    
    private func validateInputs() -> Bool {
        guard !name.isEmpty else {
            alertMessage = "Agency name is required."
            showingAlert = true
            return false
        }
        
        guard !location.isEmpty else {
            alertMessage = "Location is required."
            showingAlert = true
            return false
        }
        
        guard contact_info.count == 10, let _ = Int(contact_info) else {
            alertMessage = "Contact info must be 10 digits."
            showingAlert = true
            return false
        }
        
        guard let ratingInt = Int(rating), ratingInt >= 1, ratingInt <= 5 else {
            alertMessage = "Please enter a valid rating between 1 and 5."
            showingAlert = true
            return false
        }
        
        return true
    }
}

#Preview {
    AddTravelAgencyDetailsView(travelAgencyViewModel: TravelAgencyViewModel(), existingAgency: nil)
}
