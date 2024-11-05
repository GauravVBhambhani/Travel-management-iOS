//
//  TourGuideDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/5/24.
//

import SwiftUI

struct TourGuideDetailsView: View {
    
    let tourGuide: TourGuide
    
    var body: some View {
        Form {
            Section(header: Text("Personal Details")) {
                Text("Name: \(tourGuide.firstName) \(tourGuide.lastName)")
                Text(verbatim: "Phone: \(tourGuide.contact)")
                    
            }

            Section(header: Text("Details")) {
                Text("Language: \(tourGuide.language)")
                Text("Years Of Experience: \(tourGuide.yearsOfExperience)")
                Text("Rating: \(tourGuide.rating)")
            }
        }
        .navigationTitle("Tour Guide Details")
    
    }
}

//#Preview {
//    TourGuideDetailsView()
//}
