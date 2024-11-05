//
//  TourGuide.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct TourGuide: Equatable, Identifiable {
    var tourguide_id: Int
    
    var firstName: String
    var lastName: String
    var contact: Int
    
    var language: String
    var yearsOfExperience: Int
    var rating: Int
    
    var id: Int {
        return tourguide_id
    }
    
    init(tourguide_id: Int, firstName: String, lastName: String, language: String, yearsOfExperience: Int, contact: Int, rating: Int) {
        self.tourguide_id = tourguide_id
        self.firstName = firstName
        self.lastName = lastName
        self.language = language
        self.yearsOfExperience = yearsOfExperience
        self.contact = contact
        self.rating = rating
    }
}
