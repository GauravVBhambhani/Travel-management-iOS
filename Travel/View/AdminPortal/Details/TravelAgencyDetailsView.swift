//
//  TravelAgencyDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/5/24.
//

import SwiftUI

struct TravelAgencyDetailsView: View {
    @ObservedObject var viewModel: TravelAgencyViewModel
    @Binding var travelAgency: TravelAgency
    
    @State private var isEditing = false
    @State private var name: String
    @State private var location: String
    @State private var contactInfo: String
    @State private var rating: String
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: TravelAgencyViewModel, travelAgency: Binding<TravelAgency>) {
        self.viewModel = viewModel
        _travelAgency = travelAgency
        _name = State(initialValue: travelAgency.wrappedValue.name)
        _location = State(initialValue: travelAgency.wrappedValue.location)
        _contactInfo = State(initialValue: "\(travelAgency.wrappedValue.contact_info)")
        _rating = State(initialValue: "\(travelAgency.wrappedValue.rating)")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Agency Information")) {
                if isEditing {
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
                } else {
                    Text("Name: \(travelAgency.name)")
                    Text("Location: \(travelAgency.location)")
                }
            }
            Section(header: Text("Contact Information")) {
                if isEditing {
                    TextField("Contact Info", text: $contactInfo)
                        .keyboardType(.numberPad)
                    TextField("Rating", text: $rating)
                        .keyboardType(.numberPad)
                } else {
                    Text("Contact Info: \(travelAgency.contact_info)")
                    Text("Rating: \(travelAgency.rating)")
                }
            }
            if isEditing {
                Button("Save") {
                    saveUpdatedDetails()
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
        .navigationTitle("Travel Agency Details")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Cancel" : "Update") {
                    isEditing.toggle()
                    if !isEditing {
                        resetFields()
                    }
                }
            }
        }
        .onAppear {
            // Fetch the latest version of the agency in case it was updated elsewhere
            viewModel.fetchTravelAgencies()
            if let updatedAgency = viewModel.travelAgencies.first(where: { $0.agency_id == travelAgency.agency_id }) {
                travelAgency = updatedAgency
            }
        }
    }
    
    private func saveUpdatedDetails() {
        // Validate the input fields
        guard !name.isEmpty else {
            alertMessage = "Agency name is required."
            showingAlert = true
            return
        }
        
        guard !location.isEmpty else {
            alertMessage = "Location is required."
            showingAlert = true
            return
        }
        
        //        guard let contactInfoInt = Int(contactInfo), contactInfo.count == 10 else {
        //            alertMessage = "Contact Info must be a valid 10-digit number."
        //            showingAlert = true
        //            return
        //        }
        
        guard let ratingInt = Int(rating), ratingInt >= 1, ratingInt <= 5 else {
            alertMessage = "Rating must be between 1 and 5."
            showingAlert = true
            return
        }
        
        // Create an updated TravelAgency object
        let updatedAgency = TravelAgency(
            agency_id: travelAgency.agency_id,
            name: name,
            location: location,
            contact_info: contactInfo,
            rating: ratingInt
        )
        
        // Update the travel agency in the database
        viewModel.updateTravelAgency(updatedAgency)
        // Refresh the travel agency details in the UI
        travelAgency = updatedAgency
        isEditing = false
        
        // Fetch latest data in ViewModel so that list views are updated
        viewModel.fetchTravelAgencies()
    }
    
    private func resetFields() {
        // Reset the fields to their original values
        name = travelAgency.name
        location = travelAgency.location
        contactInfo = "\(travelAgency.contact_info)"
        rating = "\(travelAgency.rating)"
    }
}
//
//#Preview {
//    TravelAgencyDetailsView(
//        viewModel: TravelAgencyViewModel(),
//        travelAgency: .init(
//            agency_id: 1,
//            name: "Wanderlust Travel",
//            location: "New York",
//            contact_info: "9988776655",
//            rating: 5
//        )
//    )
//}
