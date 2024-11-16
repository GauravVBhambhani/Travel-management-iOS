//
//  AddTourGuideDetails.swift
//  Travel
//  Created by Gaurav Bhambhani on 11/5/24.
//

import SwiftUI

struct AddTourGuideDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: TourGuidesViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var contact = ""
    @State private var language = ""
    @State private var yearsOfExperience = ""
    @State private var rating = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Contact", text: $contact)
                        .keyboardType(.numberPad)
                }
                
                Section ("Details") {
                    TextField("Language", text: $language)
                    TextField("Years Of Experience", text: $yearsOfExperience)
                        .keyboardType(.numberPad)
                    TextField("Rating", text: $rating)
                        .keyboardType(.numberPad)
                }
                
                Button ("Save") {
                    saveTourGuide()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .navigationTitle("Add Tour Guide")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onDisappear(perform: {
            viewModel.fetchTourGuides()
        })
    }
    
    private func saveTourGuide() {
        guard let contactInt = Int(contact),
              let yearsOfExperienceInt = Int(yearsOfExperience),
              let ratingInt = Int(rating) else {
            print("Invalid Input")
            return
        }
        
        let newTourGuide = TourGuide(
            tourguide_id: 0,
            firstName: firstName,
            lastName: lastName,
            language: language,
            yearsOfExperience: yearsOfExperienceInt,
            contact: contact,
            rating: ratingInt
        )
        
        viewModel.addTourGuide(newTourGuide)
        viewModel.fetchTourGuides()
        dismiss()
    }
}

//#Preview {
//    AddTourGuideDetailsView()
//}
