//
//  TourGuideDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/5/24.
//

import SwiftUI

struct TourGuideDetailsView: View {
    @ObservedObject var viewModel: TourGuidesViewModel
    @Binding var tourGuide: TourGuide
    
    @State private var isEditing = false
    @State private var firstName: String
    @State private var lastName: String
    @State private var contact: String
    @State private var language: String
    @State private var yearsOfExperience: String
    @State private var rating: String
    
    @State private var showingAlert = false
    @State private var alertMessage = ""

    init(viewModel: TourGuidesViewModel, tourGuide: Binding<TourGuide>) {
        self.viewModel = viewModel
        _tourGuide = tourGuide
        _firstName = State(initialValue: tourGuide.wrappedValue.firstName)
        _lastName = State(initialValue: tourGuide.wrappedValue.lastName)
        _contact = State(initialValue: tourGuide.wrappedValue.contact)
        _language = State(initialValue: tourGuide.wrappedValue.language)
        _yearsOfExperience = State(initialValue: "\(tourGuide.wrappedValue.yearsOfExperience)")
        _rating = State(initialValue: "\(tourGuide.wrappedValue.rating)")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Personal Details")) {
                if isEditing {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Phone", text: $contact)
                        .keyboardType(.phonePad)
                } else {
                    Text("Name: \(tourGuide.firstName) \(tourGuide.lastName)")
                    Text(verbatim: "Phone: \(tourGuide.contact)")
                }
            }
            
            Section(header: Text("Details")) {
                if isEditing {
                    TextField("Language", text: $language)
                    TextField("Years of Experience", text: $yearsOfExperience)
                        .keyboardType(.numberPad)
                    TextField("Rating", text: $rating)
                        .keyboardType(.numberPad)
                } else {
                    Text("Language: \(tourGuide.language)")
                    Text("Years Of Experience: \(tourGuide.yearsOfExperience)")
                    Text("Rating: \(tourGuide.rating)")
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
        .navigationTitle("Tour Guide Details")
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
    }
    
    private func saveUpdatedDetails() {
        // Validate the input fields
        guard !firstName.isEmpty else {
            alertMessage = "First name is required."
            showingAlert = true
            return
        }
        
        guard !lastName.isEmpty else {
            alertMessage = "Last name is required."
            showingAlert = true
            return
        }
        
//        guard !contact.isEmpty, contact.count == 10, Int(contact) != nil else {
//            alertMessage = "Contact must be a valid 10-digit number."
//            showingAlert = true
//            return
//        }
        
        guard !language.isEmpty else {
            alertMessage = "Language is required."
            showingAlert = true
            return
        }
        
        guard let years = Int(yearsOfExperience), years >= 0 else {
            alertMessage = "Years of Experience must be a valid number."
            showingAlert = true
            return
        }
        
        guard let ratingValue = Int(rating), ratingValue >= 1, ratingValue <= 5 else {
            alertMessage = "Rating must be between 1 and 5."
            showingAlert = true
            return
        }
        
        // Create an updated TourGuide object
        let updatedGuide = TourGuide(
            tourguide_id: tourGuide.id,
            firstName: firstName,
            lastName: lastName,
            language: language,
            yearsOfExperience: years,
            contact: contact,
            rating: ratingValue
        )
        
        // Update the tour guide in the database
        viewModel.updateTourGuide(updatedGuide)
        
        // Refresh the tour guide details in the UI
        tourGuide = updatedGuide
        isEditing = false
    }
    
    private func resetFields() {
        // Reset the fields to their original values
        firstName = tourGuide.firstName
        lastName = tourGuide.lastName
        contact = tourGuide.contact
        language = tourGuide.language
        yearsOfExperience = "\(tourGuide.yearsOfExperience)"
        rating = "\(tourGuide.rating)"
    }
}

//#Preview {
//    TourGuideDetailsView(viewModel: TourGuideViewModel(), tourGuide: .constant(TourGuide(id: 1, firstName: "John", lastName: "Doe", contact: "1234567890", language: "English", yearsOfExperience: 5, rating: 4)))
//}

