//
//  Review.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Review: Equatable, Identifiable {
    var review_id: Int
    var user_id: Int
    var destination_id: Int
    var accommodation_id: Int?
    var activity_id: Int?
    
    var rating: Int
    var review_text: String
    var review_date: String
    
    var id: Int {
        return review_id
    }
    
    init(review_id: Int, user_id: Int, destination_id: Int, accommodation_id: Int? = nil, activity_id: Int? = nil, rating: Int, review_text: String, review_date: String) {
        self.review_id = review_id
        self.user_id = user_id
        self.destination_id = destination_id
        self.accommodation_id = accommodation_id
        self.activity_id = activity_id
        self.rating = rating
        self.review_text = review_text
        self.review_date = review_date
    }
}
