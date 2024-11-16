//
//  TouristDestination.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct TouristDestination: Equatable, Identifiable, Hashable {
    var destination_id: Int
    var agency_id: Int
    var name: String
    var location: String
    var popular_attractions: String
    var rating: Int
    var description: String
    
    var id: Int {
        return destination_id
    }
    
    init(destination_id: Int, agency_id: Int, name: String, location: String, popular_attractions: String, rating: Int, description: String) {
        self.destination_id = destination_id
        self.agency_id = agency_id
        self.name = name
        self.location = location
        self.popular_attractions = popular_attractions
        self.rating = rating
        self.description = description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(destination_id)
    }
}
