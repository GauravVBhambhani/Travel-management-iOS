//
//  ReviewDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct ReviewDetailsView: View {
    let review: Review

    var body: some View {
        Form {
            Section(header: Text("Review Details")) {
                Text("Rating: \(review.rating)/5")
                Text("Review Text: \(review.review_text)")
                Text("Review Date: \(review.review_date)")
            }
            Section(header: Text("User")) {
                Text("User ID: \(review.user_id)")
            }
            Section(header: Text("Destination")) {
                Text("Destination ID: \(review.destination_id)")
            }
            if let accommodationId = review.accommodation_id {
                Section(header: Text("Accommodation")) {
                    Text("Accommodation ID: \(accommodationId)")
                }
            }
            if let activityId = review.activity_id {
                Section(header: Text("Activity")) {
                    Text("Activity ID: \(activityId)")
                }
            }
        }
        .navigationTitle("Review Details")
    }
}

//#Preview {
//    ReviewDetailsView(
//        review: .init(
//            review_id: 1,
//            user_id: 1,
//            destination_id: 1,
//            accommodation_id: 1,
//            activity_id: 1,
//            rating: 5,
//            review_text: "Amazing experience!",
//            review_date: "2023-12-10"
//        )
//    )
//}
