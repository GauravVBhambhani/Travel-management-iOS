//
//  TouristDestination.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct TouristDestination: Equatable, Identifiable {
    var touristdestination_id: Int
    var agency_id: Int
    var name: String
    var location: String
    var popular_attractions: [String] // not sure
    var rating: Int
    var description: String
    
    var id: Int {
        return touristdestination_id
    }
    
    init(touristdestination_id: Int, agency_id: Int, name: String, location: String, popular_attractions: [String], rating: Int, description: String) {
        self.touristdestination_id = touristdestination_id
        self.agency_id = agency_id
        self.name = name
        self.location = location
        self.popular_attractions = popular_attractions
        self.rating = rating
        self.description = description
    }
}
