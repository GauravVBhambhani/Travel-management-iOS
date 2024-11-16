//
//  ReviewsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct ReviewsListView: View {
    
    @ObservedObject private var reviewViewModel = ReviewViewModel()
        
    var body: some View {
        NavigationView {
            List {
                ForEach(reviewViewModel.reviews) { review in
                    NavigationLink("Review ID: \(review.id)") {
                        ReviewDetailsView(review: review)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let reviewToDelete = reviewViewModel.reviews[index]
                        reviewViewModel.deleteReview(reviewToDelete)
                    }
                }
            }
            .navigationTitle("Reviews")
        }
    }
}

#Preview {
    ReviewsListView()
}
